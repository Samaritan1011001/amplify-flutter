import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'amplify_push_notification_ios_platform_interface.dart';

/// An implementation of [AmplifyPushNotificationIosPlatform] that uses method channels.
class MethodChannelAmplifyPushNotificationIos extends AmplifyPushNotificationIosPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('amplify_push_notification_ios');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
