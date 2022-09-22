import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'amplify_push_notifications_pinpoint_android_method_channel.dart';

abstract class AmplifyPushNotificationsPinpointAndroidPlatform extends PlatformInterface {
  /// Constructs a AmplifyPushNotificationsPinpointAndroidPlatform.
  AmplifyPushNotificationsPinpointAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static AmplifyPushNotificationsPinpointAndroidPlatform _instance = MethodChannelAmplifyPushNotificationsPinpointAndroid();

  /// The default instance of [AmplifyPushNotificationsPinpointAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelAmplifyPushNotificationsPinpointAndroid].
  static AmplifyPushNotificationsPinpointAndroidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AmplifyPushNotificationsPinpointAndroidPlatform] when
  /// they register themselves.
  static set instance(AmplifyPushNotificationsPinpointAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
