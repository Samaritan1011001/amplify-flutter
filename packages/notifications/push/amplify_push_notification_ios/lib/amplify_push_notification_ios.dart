
import 'amplify_push_notification_ios_platform_interface.dart';

class AmplifyPushNotificationIos {
  Future<String?> getPlatformVersion() {
    return AmplifyPushNotificationIosPlatform.instance.getPlatformVersion();
  }
}
