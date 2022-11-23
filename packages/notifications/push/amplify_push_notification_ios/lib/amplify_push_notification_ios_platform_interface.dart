import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'amplify_push_notification_ios_method_channel.dart';

abstract class AmplifyPushNotificationIosPlatform extends PlatformInterface {
  /// Constructs a AmplifyPushNotificationIosPlatform.
  AmplifyPushNotificationIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static AmplifyPushNotificationIosPlatform _instance = MethodChannelAmplifyPushNotificationIos();

  /// The default instance of [AmplifyPushNotificationIosPlatform] to use.
  ///
  /// Defaults to [MethodChannelAmplifyPushNotificationIos].
  static AmplifyPushNotificationIosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AmplifyPushNotificationIosPlatform] when
  /// they register themselves.
  static set instance(AmplifyPushNotificationIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
