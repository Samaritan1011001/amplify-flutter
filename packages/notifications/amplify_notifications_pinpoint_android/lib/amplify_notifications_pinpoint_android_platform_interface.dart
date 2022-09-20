import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'amplify_notifications_pinpoint_android_method_channel.dart';

abstract class AmplifyNotificationsPinpointAndroidPlatform extends PlatformInterface {
  /// Constructs a AmplifyNotificationsPinpointAndroidPlatform.
  AmplifyNotificationsPinpointAndroidPlatform() : super(token: _token);

  static final Object _token = Object();

  static AmplifyNotificationsPinpointAndroidPlatform _instance = MethodChannelAmplifyNotificationsPinpointAndroid();

  /// The default instance of [AmplifyNotificationsPinpointAndroidPlatform] to use.
  ///
  /// Defaults to [MethodChannelAmplifyNotificationsPinpointAndroid].
  static AmplifyNotificationsPinpointAndroidPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AmplifyNotificationsPinpointAndroidPlatform] when
  /// they register themselves.
  static set instance(AmplifyNotificationsPinpointAndroidPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
