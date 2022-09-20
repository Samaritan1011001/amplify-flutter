import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_notifications_pinpoint_android/amplify_notifications_pinpoint_android.dart';
import 'package:amplify_notifications_pinpoint_android/amplify_notifications_pinpoint_android_platform_interface.dart';
import 'package:amplify_notifications_pinpoint_android/amplify_notifications_pinpoint_android_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAmplifyNotificationsPinpointAndroidPlatform
    with MockPlatformInterfaceMixin
    implements AmplifyNotificationsPinpointAndroidPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AmplifyNotificationsPinpointAndroidPlatform initialPlatform = AmplifyNotificationsPinpointAndroidPlatform.instance;

  test('$MethodChannelAmplifyNotificationsPinpointAndroid is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAmplifyNotificationsPinpointAndroid>());
  });

  test('getPlatformVersion', () async {
    AmplifyNotificationsPinpointAndroid amplifyNotificationsPinpointAndroidPlugin = AmplifyNotificationsPinpointAndroid();
    MockAmplifyNotificationsPinpointAndroidPlatform fakePlatform = MockAmplifyNotificationsPinpointAndroidPlatform();
    AmplifyNotificationsPinpointAndroidPlatform.instance = fakePlatform;

    expect(await amplifyNotificationsPinpointAndroidPlugin.getPlatformVersion(), '42');
  });
}
