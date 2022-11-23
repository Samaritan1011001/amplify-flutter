import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'amplify_push_notification_android_method_channel.dart';

abstract class AmplifyPushNotificationAndroidPlatform extends PlatformInterface {
  /// Constructs a AmplifyPushNotificationAndroidPlatform.
  AmplifyPushNotificationAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static AmplifyPushNotificationAndroidPlatform _instance = MethodChannelAmplifyPushNotificationAndroid();

  /// The default instance of [AmplifyPushNotificationAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelAmplifyPushNotificationAndroid].
  static AmplifyPushNotificationAndroidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AmplifyPushNotificationAndroidPlatform] when
  /// they register themselves.
  static set instance(AmplifyPushNotificationAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
