
import 'amplify_notifications_pinpoint_ios_platform_interface.dart';

class AmplifyNotificationsPinpointIos {
  Future<String?> getPlatformVersion() {
    return AmplifyNotificationsPinpointIosPlatform.instance.getPlatformVersion();
  }
}
