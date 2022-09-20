
import 'amplify_notifications_pinpoint_android_platform_interface.dart';

class AmplifyNotificationsPinpointAndroid {
  Future<String?> getPlatformVersion() {
    return AmplifyNotificationsPinpointAndroidPlatform.instance.getPlatformVersion();
  }
}
