import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'amplify_push_notifications_pinpoint_ios_method_channel.dart';

abstract class AmplifyPushNotificationsPinpointIosPlatform extends PlatformInterface {
  /// Constructs a AmplifyPushNotificationsPinpointIosPlatform.
  AmplifyPushNotificationsPinpointIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static AmplifyPushNotificationsPinpointIosPlatform _instance = MethodChannelAmplifyPushNotificationsPinpointIos();

  /// The default instance of [AmplifyPushNotificationsPinpointIosPlatform] to use.
  ///
  /// Defaults to [MethodChannelAmplifyPushNotificationsPinpointIos].
  static AmplifyPushNotificationsPinpointIosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AmplifyPushNotificationsPinpointIosPlatform] when
  /// they register themselves.
  static set instance(AmplifyPushNotificationsPinpointIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
