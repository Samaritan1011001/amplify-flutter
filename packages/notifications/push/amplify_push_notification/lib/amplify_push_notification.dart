library amplify_push_notification;

import 'dart:io';

import 'package:amplify_core/amplify_core.dart';
import 'package:meta/meta.dart';

import 'dart:async';

import 'package:amplify_core/amplify_core.dart';
// import 'package:amplify_push_notifications_pinpoint/endpoint_client.dart';
// import 'package:amplify_push_notifications_pinpoint/src/impl/device_info_context_provider.dart';
// import 'package:amplify_push_notifications_pinpoint/src/sdk/pinpoint.dart';
import 'package:flutter/services.dart';
import 'package:amplify_secure_storage/amplify_secure_storage.dart';
import '../amplify_push_notification.dart';

// import 'package:amplify_push_notifications_pinpoint/lib/sdk/pinpoint.dart';

const MethodChannel _methodChannel =
    MethodChannel('com.amazonaws.amplify/notifications_pinpoint');

class AmplifyPushNotification extends NotificationsPluginInterface {
  AmplifyPushNotification({this.serviceProviderClient});
  ServiceProviderClient? serviceProviderClient;

  // EndpointClient? __endpointClient;
  static final AmplifyLogger _logger =
      AmplifyLogger.category(Category.notifications)
          .createChild('AmplifyPushNotification');

  final StreamController<String> _newTokenStream = StreamController<String>();
  final StreamController<RemotePushMessage> _foregroundEventStreamController =
      StreamController<RemotePushMessage>();
  final StreamController<RemotePushMessage> _backgroundEventStreamController =
      StreamController<RemotePushMessage>();
  final StreamController<RemotePushMessage>
      _notificationOpenedStreamController =
      StreamController<RemotePushMessage>();
  bool _isConfigured = false;

  Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    print('Native call!');
    switch (methodCall.method) {
      case "onForegroundNotificationReceived":
        print("onForegroundNotificationReceived");
        _foregroundEventStreamController.add(RemotePushMessage());
        break;
      case "onBackgroundNotificationReceived":
        print("onBackgroundNotificationReceived");
        _backgroundEventStreamController.add(RemotePushMessage());
        break;
      case "onNotificationOpenedApp":
        print("onNotificationOpenedApp");
        _notificationOpenedStreamController.add(RemotePushMessage());
        break;
      case "onNewToken":
        print("onNewToken");
        _newTokenStream.add("token");
        break;
      default:
        return "Nothing";
    }
  }

  @override
  Future<void> configure({
    AmplifyConfig? config,
    required AmplifyAuthProviderRepository authProviderRepo,
  }) async {
    // Parse config values from amplifyconfiguration.json
    if (config == null ||
        config.analytics == null ||
        config.analytics?.awsPlugin == null) {
      throw const AnalyticsException('No Pinpoint plugin config available');
    }

    if (!_isConfigured) {
      _logger.info("Configure works in AmplifyPushNotification!");

      // Register FCM and APNS if auto-registeration is enabled
      await _registerForRemoteNotifications();

      // Register native listeners for token generation and notification handling
      _methodChannel.setMethodCallHandler(nativeMethodCallHandler);

      // Register library listeners for token, notificaiton handling
      onNewToken().then(
        (stream) => stream.listen(
          (address) async {
            // Register with service provider
            await _registerDevice(address: address);
          },
        ),
      );
      onForegroundNotificationReceived()
          .then((stream) => stream.listen((event) {}));
      onBackgroundNotificationReceived()
          .then((stream) => stream.listen((event) {}));
      onNotificationOpenedApp().then((stream) => stream.listen((event) {}));

      // Initialize Endpoint Client
      await serviceProviderClient?.init(
        config: config,
        authProviderRepo: authProviderRepo,
      );
    }

    // Register with service provider
    await _registerDevice();

    _isConfigured = true;
  }

  Future<void> _registerDevice({String? address}) async {
    _logger.info("registerDevice");
    address = address ?? await getToken();
    await serviceProviderClient?.registerDevice(address);
  }

  Future<void> _registerForRemoteNotifications() async {
    _logger.info("registerForRemoteNotifications");
    await _methodChannel.invokeMethod<String>('registerForRemoteNotifications');
  }

  @override
  Future<PushPermissionRequestStatus> requestMessagingPermission(
      {PushNotificationPermissionRequest? pushNotificationPermissionRequest}) async {
    PushPermissionRequestStatus pushPermissionRequestStatus = PushPermissionRequestStatus.undetermined;
    pushNotificationPermissionRequest ??= PushNotificationPermissionRequest();

    bool? granted =
        await _methodChannel.invokeMethod<bool>('requestMessagingPermission');

    if (granted != null) {
      pushPermissionRequestStatus =
          granted ? PushPermissionRequestStatus.granted : PushPermissionRequestStatus.denied;
    }
    _logger.info(
        "pushPermissionRequestStatus -> $pushPermissionRequestStatus");
    return pushPermissionRequestStatus;
  }

  // @override
  // Future<void> identifyUser({
  //   required String userId,
  //   required NotificationsUserProfile userProfile,
  // }) async {
  //   print("userId -> $userId");
  //   print("userProfile -> $userProfile");

  //   // await _methodChannel.invokeMethod<bool>('identifyUser');
  // }

  @override
  Future<Stream<String>> onNewToken() async {
    await _methodChannel.invokeMethod('onNewToken');
    return _newTokenStream.stream;
  }

  @override
  Future<String> getToken() async {
    String? token = await _methodChannel.invokeMethod<String>('getToken');
    print("Token -> $token");

    return token!;
  }

  @override
  Future<Stream<RemotePushMessage>> onForegroundNotificationReceived() async =>
      _foregroundEventStreamController.stream;

  @override
  Future<Stream<RemotePushMessage>> onBackgroundNotificationReceived() async =>
      _backgroundEventStreamController.stream;

  @override
  Future<Stream<RemotePushMessage>> onNotificationOpenedApp() async =>
      _notificationOpenedStreamController.stream;

  @override
  Future<RemotePushMessage> getInitialNotification() async {
    return RemotePushMessage();
  }

  @override
  Future<int> getBadgeCount() async {
    return 0;
  }

  @override
  Future<void> setBadgeCount(int badgeCount) async {}
}
