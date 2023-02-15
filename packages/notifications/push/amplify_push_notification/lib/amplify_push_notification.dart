library amplify_push_notification;

import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'callback_dispatcher.dart';

const MethodChannel _methodChannel =
    MethodChannel('com.amazonaws.amplify/push_notification_plugin');

class AmplifyPushNotification extends NotificationsPluginInterface
    with WidgetsBindingObserver {
  AmplifyPushNotification({this.serviceProviderClient});

  final ServiceProviderClient? serviceProviderClient;
  final StreamController<String> _onTokenReceivedStream =
      StreamController<String>();
  final StreamController<RemotePushMessage> _foregroundEventStreamController =
      StreamController<RemotePushMessage>.broadcast();
  final StreamController<RemotePushMessage>
      _onNotificaitonOpenedEventStreamController =
      StreamController<RemotePushMessage>.broadcast();

  RemoteMessageCallback? bgUserGivenCallback;
  RemoteMessageCallback? appOpeningUserGivenCallback;
  String bgCallbackId = "bg_user_given_callback";
  String appOpeningCallbackId = "app_opening_user_given_callback";

  bool _isConfigured = false;
  final AmplifyLogger _logger = AmplifyLogger.category(Category.notifications)
      .createChild('AmplifyPushNotification');

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
      // Register FCM and APNS if auto-registeration is enabled
      await _registerForRemoteNotifications();

      // Register native listeners for token generation and notification handling
      _methodChannel.setMethodCallHandler(_nativeToDartMethodCallHandler);

      // Register library listeners for token
      // onNewToken().then(
      //   (stream) => stream.listen(
      //     (address) async {
      //       // Register with service provider
      //       await _registerDevice(address: address);
      //     },
      //   ),
      // );

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

    _logger.info("CONFIGURE API | Successfully configure push notifications");

    _isConfigured = true;
  }

  Future<void> recordNotificationEvent({
    required AnalyticsEvent event,
  }) async {
    if (serviceProviderClient == null) {
      throw const PushNotificationException('Configure Amplify first.');
    }
    event.properties
      ..addStringProperty('app_state', 'foreground')
      ..addStringProperty('channel', 'PUSH')
      ..addBoolProperty('Successful', true);
    serviceProviderClient?.recordNotificationEvent(event: event);
  }

  Future<dynamic> _nativeToDartMethodCallHandler(MethodCall methodCall) async {
    try {
      final decodedContent = jsonDecode(methodCall.arguments);
      switch (methodCall.method) {
        case "NEW_TOKEN":
          print(
            "TOKENS API | Plugin received a new device token: $decodedContent",
          );
          _onTokenReceivedStream.sink.add(
            decodedContent,
          );
          break;
        case "FOREGROUND_MESSAGE_RECEIVED":
          print(
            "NOTIFICATION HANDLING API | Plugin received foreground notification: $decodedContent",
          );
          _foregroundEventStreamController.sink.add(
            RemotePushMessage.fromJson(decodedContent),
          );
          // recordNotificationEvent(
          //     event: AnalyticsEvent("foreground_message_received"));
          break;
        case "BACKGROUND_MESSAGE_RECEIVED":
          print(
            "NOTIFICATION HANDLING API | Plugin received background notification: $decodedContent",
          );
          if (bgUserGivenCallback != null) {
            bgUserGivenCallback!(RemotePushMessage.fromJson(decodedContent));
          }
          break;
        case "NOTIFICATION_OPENED_APP":
          print(
            "NOTIFICATION HANDLING API | Plugin received notificaiton tapped event: $decodedContent",
          );
          _onNotificaitonOpenedEventStreamController.sink.add(
            RemotePushMessage.fromJson(decodedContent),
          );
          break;
        default:
          break;
      }
    } catch (e) {
      _logger.error("Error in native-dart method handler $e");
    }
  }

  Future<void> _registerCallbackDispatcher() async {
    try {
      final callback = PluginUtilities.getCallbackHandle(callbackDispatcher);
      await _methodChannel.invokeMethod<void>(
          'initializeService', <dynamic>[callback?.toRawHandle()]);
      _logger.info("Successfully registered callback dispatcher");
    } catch (e) {
      _logger.error(
        "Error when registering callback dispatcher: $e",
      );
    }
  }

  Future<void> _registerUserGivenCallback(
    String callbackId,
    RemoteMessageCallback userCallback,
  ) async {
    try {
      final callback = PluginUtilities.getCallbackHandle(userCallback);
      _logger.info("Successfully registered notification handling callback");

      await _methodChannel.invokeMethod(
          callbackId == bgCallbackId
              ? 'registerBGUserGivenCallback'
              : 'registerAppOpeningUserGivenCallback',
          <dynamic>[callback?.toRawHandle()]);
    } catch (e) {
      _logger.error(
        "Error when registering notification handling callback: $e",
      );
    }
  }

  Future<void> _registerDevice({String? address}) async {
    try {
      address = address ?? await getToken();
      if (address != null) await serviceProviderClient?.registerDevice(address);
      _logger.info("Successfully registered device with the servvice provider");
    } catch (e) {
      _logger.error(
        "Error when registering device with the servvice provider: $e",
      );
    }
  }

  Future<void> _registerForRemoteNotifications() async {
    try {
      await _methodChannel
          .invokeMethod<String>('registerForRemoteNotifications');
      _logger.info(
          "Successfully registered device to receive remote notifications");
    } catch (e) {
      _logger.error(
        "Error when registering device to receive remote notifications: $e",
      );
    }
  }

  @override
  Future<PushPermissionRequestStatus> getPermissionStatus() async {
    PushPermissionRequestStatus pushPermissionRequestStatus =
        PushPermissionRequestStatus.undetermined;

    try {
      String? currentStatus =
          await _methodChannel.invokeMethod<String>('getPermissionStatus');
      print("currentStatus -> $currentStatus");
      if (currentStatus != null) {
        switch (currentStatus) {
          case "granted":
            pushPermissionRequestStatus = PushPermissionRequestStatus.granted;
            break;
          case "denied":
            pushPermissionRequestStatus = PushPermissionRequestStatus.denied;
            break;
          case "undetermined":
            pushPermissionRequestStatus =
                PushPermissionRequestStatus.undetermined;
            break;
          default:
            pushPermissionRequestStatus =
                PushPermissionRequestStatus.undetermined;
            break;
        }
        // pushPermissionRequestStatus =
        //     currentStatus == PushPermissionRequestStatus.granted.name
        //         ? PushPermissionRequestStatus.granted
        //         : PushPermissionRequestStatus.denied;
      }
      _logger.info(
        "PERMISSIONS API | getPermissionStatus API | Push Notification Permission request status: $pushPermissionRequestStatus",
      );
    } catch (e) {
      _logger.error("Error when requesting permission: $e");
    }

    return pushPermissionRequestStatus;
  }

  @override
  Future<PushPermissionRequestStatus> requestMessagingPermission(
      {bool? alert = true, bool? badge = true, bool? sound = true}) async {
    PushPermissionRequestStatus pushPermissionRequestStatus =
        PushPermissionRequestStatus.undetermined;

    try {
      String? granted = await _methodChannel.invokeMethod<String>(
          'requestMessagingPermission',
          jsonEncode({
            "alert": alert,
            "badge": badge,
            "sound": sound,
          }));
      print(
          "request permission status -> ${PushPermissionRequestStatus.granted.name}");
      if (granted != null) {
        pushPermissionRequestStatus =
            granted == PushPermissionRequestStatus.granted.name
                ? PushPermissionRequestStatus.granted
                : PushPermissionRequestStatus.denied;
      }
      _logger.info(
        "PERMISSIONS API | requestPermission API | Push Notification Permission request status: $pushPermissionRequestStatus",
      );
    } catch (e) {
      _logger.error("Error when requesting permission: $e");
    }

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
  Stream<String> onTokenReceived() => _onTokenReceivedStream.stream;

  Future<String?> getToken() async {
    try {
      String? token = await _methodChannel.invokeMethod<String>('getToken');
      if (token != null) {
        print("TOKEN API |  Successfully retreived device token: $token");

        return token;
      }
    } catch (e) {
      _logger.error("Error when getting device token: $e");
    }
    return null;
  }

  @override
  Stream<RemotePushMessage> onForegroundNotificationReceived() =>
      _foregroundEventStreamController.stream;

  @override
  void onBackgroundNotificationReceived(RemoteMessageCallback callback) {
    bgUserGivenCallback = callback;
    // if (Platform.isAndroid) {
    _registerUserGivenCallback(bgCallbackId, callback);
    // }
  }

  @override
  Stream<RemotePushMessage> onNotificationOpenedApp() =>
      _onNotificaitonOpenedEventStreamController.stream;

  @override
  Future<RemotePushMessage?> getInitialNotification() async {
    try {
      String? launchNotification =
          await _methodChannel.invokeMethod<String>('getLaunchNotification');
      if (launchNotification != null) {
        print(
            "NOTIFICATION HANDLING API |  Successfully retreived launch notification: $launchNotification");
        final decodedContent = jsonDecode(launchNotification);
        return RemotePushMessage.fromJson(decodedContent);
      } else {
        return null;
      }
    } catch (e) {
      _logger.error("Error when getting launch notification: $e");
    }
    return null;
    // return RemotePushMessage(messageId: 'test');
  }

  @override
  Future<int> getBadgeCount() async {
    return 0;
  }

  @override
  Future<void> setBadgeCount(int badgeCount) async {}
}
