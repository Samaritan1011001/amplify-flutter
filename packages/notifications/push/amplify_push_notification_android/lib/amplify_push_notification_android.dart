
import 'amplify_push_notification_android_platform_interface.dart';

class AmplifyPushNotificationAndroid {
  Future<String?> getPlatformVersion() {
    return AmplifyPushNotificationAndroidPlatform.instance.getPlatformVersion();
  }
}
