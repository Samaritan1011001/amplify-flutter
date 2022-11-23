import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_push_notification_ios/amplify_push_notification_ios.dart';
import 'package:amplify_push_notification_ios/amplify_push_notification_ios_platform_interface.dart';
import 'package:amplify_push_notification_ios/amplify_push_notification_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAmplifyPushNotificationIosPlatform
    with MockPlatformInterfaceMixin
    implements AmplifyPushNotificationIosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AmplifyPushNotificationIosPlatform initialPlatform = AmplifyPushNotificationIosPlatform.instance;

  test('$MethodChannelAmplifyPushNotificationIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAmplifyPushNotificationIos>());
  });

  test('getPlatformVersion', () async {
    AmplifyPushNotificationIos amplifyPushNotificationIosPlugin = AmplifyPushNotificationIos();
    MockAmplifyPushNotificationIosPlatform fakePlatform = MockAmplifyPushNotificationIosPlatform();
    AmplifyPushNotificationIosPlatform.instance = fakePlatform;

    expect(await amplifyPushNotificationIosPlugin.getPlatformVersion(), '42');
  });
}
