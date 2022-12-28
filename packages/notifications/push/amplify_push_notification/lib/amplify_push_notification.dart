library amplify_push_notification;

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:amplify_core/amplify_core.dart';
// import 'package:amplify_push_notifications_pinpoint/endpoint_client.dart';
// import 'package:amplify_push_notifications_pinpoint/src/impl/device_info_context_provider.dart';
// import 'package:amplify_push_notifications_pinpoint/src/sdk/pinpoint.dart';
import 'package:flutter/services.dart';

import 'callback_dispatcher.dart';

// import 'package:amplify_push_notifications_pinpoint/lib/sdk/pinpoint.dart';

// @pragma(
//     'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
// void callbackDispatcher() {
//   Workmanager().executeTask((task, inputData) {
//     print("Native called background task:"); //simpleTask will be emitted here.
//     return Future.value(true);
//   });
// }

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
      StreamController<RemotePushMessage>.broadcast();
  final StreamController<RemotePushMessage> _backgroundEventStreamController =
      StreamController<RemotePushMessage>.broadcast();
  final StreamController<RemotePushMessage>
      _notificationOpenedStreamController =
      StreamController<RemotePushMessage>.broadcast();

  bool _isConfigured = false;

  Future<dynamic> nativeMethodCallHandler(MethodCall methodCall) async {
    print('Native call!');
    switch (methodCall.method) {
      // case "onForegroundNotificationReceived":
      //   print("onForegroundNotificationReceived");
      //   // _foregroundEventStreamController.add(RemotePushMessage());
      //   break;
      // case "onBackgroundNotificationReceived":
      //   print("onBackgroundNotificationReceived");
      //   // _backgroundEventStreamController.add(RemotePushMessage());
      //   break;
      // case "onNotificationOpenedApp":
      //   print("onNotificationOpenedApp");
      //   // _notificationOpenedStreamController.add(RemotePushMessage());
      //   break;
      // case "onNewToken":
      //   print("onNewToken");
      //   _newTokenStream.add("token");
      //   break;
      // case "RTNPushNotification_NewToken":
      //   print("Android onNewToken");
      //   final jData = jsonDecode(methodCall.arguments);
      //   print("Android onNewToken data -> $jData");
      //   _newTokenStream.add(jData);
      //   break;
      case "FOREGROUND_MESSAGE_RECEIVED":
        try {
          final jData = jsonDecode(methodCall.arguments);
          print(
              "ForegroundMessageReceived data IOS -> ${methodCall.arguments}");

          print("ForegroundMessageReceived data -> $jData");
          _foregroundEventStreamController.sink
              .add(RemotePushMessage.fromJson(jData));
        } catch (e) {
          _logger.info("Error $e");
        }
        break;
      case "BACKGROUND_MESSAGE_RECEIVED":
        try {
          final jData = jsonDecode(methodCall.arguments);
          print("BackgroundMessageReceived data -> $jData");
          _backgroundEventStreamController.sink
              .add(RemotePushMessage.fromJson(jData));
          // Workmanager().registerOneOffTask("task-identifier", "simpleTask");
        } catch (e) {
          _logger.info("Error $e");
        }
        break;
      default:
        print("Nothing ${methodCall.method}");
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
      onForegroundNotificationReceived().listen((event) {
        // AppleNotification notif = event.notification as AppleNotification;

        _logger.info("received notification in foreground listener $event");
      });

      // onBackgroundNotificationReceived().listen((event) {
      //   _logger.info("received notification in background listener $event");
      // });

      onNotificationOpenedApp().listen((event) {});

      // Initialize Endpoint Client
      await serviceProviderClient?.init(
        config: config,
        authProviderRepo: authProviderRepo,
      );
    }

    // Register with service provider
    await _registerDevice();

    // Register the callback dispatcher
    _registerCallbackDispatcher();

    // Workmanager().initialize(
    //     callbackDispatcher, // The top level function, aka callbackDispatcher
    //     isInDebugMode:
    //         true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
    //     );

    _isConfigured = true;
  }

  Future<void> _registerCallbackDispatcher() async {
    _logger.info("_registerCallbackDispatcher");
    final callback = PluginUtilities.getCallbackHandle(callbackDispatcher);
    await _methodChannel.invokeMethod<void>(
        'registerCallbackDispatcher', <dynamic>[callback?.toRawHandle()]);
  }

  Future<void> _registerUserGivenCallback(VoidCallback userCallback) async {
    _logger.info("_registerUserGivenCallback");
    final callback = PluginUtilities.getCallbackHandle(userCallback);
    _logger.info(
        "callback was registered in plugin cache ${callback?.toRawHandle()}");

    await _methodChannel.invokeMethod(
        'registerUserGivenCallback', <dynamic>[callback?.toRawHandle()]);
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
      {bool? alert = true, bool? badge = true, bool? sound = true}) async {
    PushPermissionRequestStatus pushPermissionRequestStatus =
        PushPermissionRequestStatus.undetermined;

    bool? granted =
        await _methodChannel.invokeMethod<bool>('requestMessagingPermission');

    if (granted != null) {
      pushPermissionRequestStatus = granted
          ? PushPermissionRequestStatus.granted
          : PushPermissionRequestStatus.denied;
    }
    _logger.info("pushPermissionRequestStatus -> $pushPermissionRequestStatus");
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
  Stream<RemotePushMessage> onForegroundNotificationReceived() =>
      _foregroundEventStreamController.stream;

  @override
  void onBackgroundNotificationReceived(VoidCallback callback) {
    _registerUserGivenCallback(callback);
  }

  @override
  Stream<RemotePushMessage> onNotificationOpenedApp() =>
      _notificationOpenedStreamController.stream;

  @override
  Future<RemotePushMessage> getInitialNotification() async {
    return RemotePushMessage(messageId: 'test');
  }

  @override
  Future<int> getBadgeCount() async {
    return 0;
  }

  @override
  Future<void> setBadgeCount(int badgeCount) async {}
}
