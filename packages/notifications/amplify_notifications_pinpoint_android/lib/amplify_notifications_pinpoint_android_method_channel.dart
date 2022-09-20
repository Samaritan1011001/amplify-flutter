import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'amplify_notifications_pinpoint_android_platform_interface.dart';

/// An implementation of [AmplifyNotificationsPinpointAndroidPlatform] that uses method channels.
class MethodChannelAmplifyNotificationsPinpointAndroid extends AmplifyNotificationsPinpointAndroidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('amplify_notifications_pinpoint_android');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
