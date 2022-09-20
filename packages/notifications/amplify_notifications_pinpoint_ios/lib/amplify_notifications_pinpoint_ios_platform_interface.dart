import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'amplify_notifications_pinpoint_ios_method_channel.dart';

abstract class AmplifyNotificationsPinpointIosPlatform extends PlatformInterface {
  /// Constructs a AmplifyNotificationsPinpointIosPlatform.
  AmplifyNotificationsPinpointIosPlatform() : super(token: _token);

  static final Object _token = Object();

  static AmplifyNotificationsPinpointIosPlatform _instance = MethodChannelAmplifyNotificationsPinpointIos();

  /// The default instance of [AmplifyNotificationsPinpointIosPlatform] to use.
  ///
  /// Defaults to [MethodChannelAmplifyNotificationsPinpointIos].
  static AmplifyNotificationsPinpointIosPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AmplifyNotificationsPinpointIosPlatform] when
  /// they register themselves.
  static set instance(AmplifyNotificationsPinpointIosPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
