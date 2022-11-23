import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_push_notification_android/amplify_push_notification_android.dart';
import 'package:amplify_push_notification_android/amplify_push_notification_android_platform_interface.dart';
import 'package:amplify_push_notification_android/amplify_push_notification_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAmplifyPushNotificationAndroidPlatform
    with MockPlatformInterfaceMixin
    implements AmplifyPushNotificationAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AmplifyPushNotificationAndroidPlatform initialPlatform = AmplifyPushNotificationAndroidPlatform.instance;

  test('$MethodChannelAmplifyPushNotificationAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAmplifyPushNotificationAndroid>());
  });

  test('getPlatformVersion', () async {
    AmplifyPushNotificationAndroid amplifyPushNotificationAndroidPlugin = AmplifyPushNotificationAndroid();
    MockAmplifyPushNotificationAndroidPlatform fakePlatform = MockAmplifyPushNotificationAndroidPlatform();
    AmplifyPushNotificationAndroidPlatform.instance = fakePlatform;

    expect(await amplifyPushNotificationAndroidPlugin.getPlatformVersion(), '42');
  });
}
