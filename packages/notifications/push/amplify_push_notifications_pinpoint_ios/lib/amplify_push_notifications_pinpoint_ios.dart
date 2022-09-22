
import 'amplify_push_notifications_pinpoint_ios_platform_interface.dart';

class AmplifyPushNotificationsPinpointIos {
  Future<String?> getPlatformVersion() {
    return AmplifyPushNotificationsPinpointIosPlatform.instance.getPlatformVersion();
  }
}
