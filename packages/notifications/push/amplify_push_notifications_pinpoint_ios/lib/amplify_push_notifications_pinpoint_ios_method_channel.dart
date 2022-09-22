import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'amplify_push_notifications_pinpoint_ios_platform_interface.dart';

/// An implementation of [AmplifyPushNotificationsPinpointIosPlatform] that uses method channels.
class MethodChannelAmplifyPushNotificationsPinpointIos extends AmplifyPushNotificationsPinpointIosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('amplify_push_notifications_pinpoint_ios');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
