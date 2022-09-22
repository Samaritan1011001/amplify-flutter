import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'amplify_push_notifications_pinpoint_android_platform_interface.dart';

/// An implementation of [AmplifyPushNotificationsPinpointAndroidPlatform] that uses method channels.
class MethodChannelAmplifyPushNotificationsPinpointAndroid extends AmplifyPushNotificationsPinpointAndroidPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('amplify_push_notifications_pinpoint_android');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
