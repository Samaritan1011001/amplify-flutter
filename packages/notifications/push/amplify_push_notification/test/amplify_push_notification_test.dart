import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_push_notification/amplify_push_notification.dart';
import 'package:amplify_push_notification/amplify_push_notification_platform_interface.dart';
import 'package:amplify_push_notification/amplify_push_notification_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAmplifyPushNotificationPlatform
    with MockPlatformInterfaceMixin
    implements AmplifyPushNotificationPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AmplifyPushNotificationPlatform initialPlatform = AmplifyPushNotificationPlatform.instance;

  test('$MethodChannelAmplifyPushNotification is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAmplifyPushNotification>());
  });

  test('getPlatformVersion', () async {
    AmplifyPushNotification amplifyPushNotificationPlugin = AmplifyPushNotification();
    MockAmplifyPushNotificationPlatform fakePlatform = MockAmplifyPushNotificationPlatform();
    AmplifyPushNotificationPlatform.instance = fakePlatform;

    expect(await amplifyPushNotificationPlugin.getPlatformVersion(), '42');
  });
}
