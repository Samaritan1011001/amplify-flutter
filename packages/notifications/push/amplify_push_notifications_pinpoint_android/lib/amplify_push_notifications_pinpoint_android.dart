
import 'amplify_push_notifications_pinpoint_android_platform_interface.dart';

class AmplifyPushNotificationsPinpointAndroid {
  Future<String?> getPlatformVersion() {
    return AmplifyPushNotificationsPinpointAndroidPlatform.instance.getPlatformVersion();
  }
}
