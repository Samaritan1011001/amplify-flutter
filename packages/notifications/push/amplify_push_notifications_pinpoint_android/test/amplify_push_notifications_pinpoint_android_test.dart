import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_push_notifications_pinpoint_android/amplify_push_notifications_pinpoint_android.dart';
import 'package:amplify_push_notifications_pinpoint_android/amplify_push_notifications_pinpoint_android_platform_interface.dart';
import 'package:amplify_push_notifications_pinpoint_android/amplify_push_notifications_pinpoint_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAmplifyPushNotificationsPinpointAndroidPlatform
    with MockPlatformInterfaceMixin
    implements AmplifyPushNotificationsPinpointAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AmplifyPushNotificationsPinpointAndroidPlatform initialPlatform = AmplifyPushNotificationsPinpointAndroidPlatform.instance;

  test('$MethodChannelAmplifyPushNotificationsPinpointAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAmplifyPushNotificationsPinpointAndroid>());
  });

  test('getPlatformVersion', () async {
    AmplifyPushNotificationsPinpointAndroid amplifyPushNotificationsPinpointAndroidPlugin = AmplifyPushNotificationsPinpointAndroid();
    MockAmplifyPushNotificationsPinpointAndroidPlatform fakePlatform = MockAmplifyPushNotificationsPinpointAndroidPlatform();
    AmplifyPushNotificationsPinpointAndroidPlatform.instance = fakePlatform;

    expect(await amplifyPushNotificationsPinpointAndroidPlugin.getPlatformVersion(), '42');
  });
}
