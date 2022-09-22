import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_push_notifications_pinpoint_ios/amplify_push_notifications_pinpoint_ios.dart';
import 'package:amplify_push_notifications_pinpoint_ios/amplify_push_notifications_pinpoint_ios_platform_interface.dart';
import 'package:amplify_push_notifications_pinpoint_ios/amplify_push_notifications_pinpoint_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAmplifyPushNotificationsPinpointIosPlatform
    with MockPlatformInterfaceMixin
    implements AmplifyPushNotificationsPinpointIosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AmplifyPushNotificationsPinpointIosPlatform initialPlatform = AmplifyPushNotificationsPinpointIosPlatform.instance;

  test('$MethodChannelAmplifyPushNotificationsPinpointIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAmplifyPushNotificationsPinpointIos>());
  });

  test('getPlatformVersion', () async {
    AmplifyPushNotificationsPinpointIos amplifyPushNotificationsPinpointIosPlugin = AmplifyPushNotificationsPinpointIos();
    MockAmplifyPushNotificationsPinpointIosPlatform fakePlatform = MockAmplifyPushNotificationsPinpointIosPlatform();
    AmplifyPushNotificationsPinpointIosPlatform.instance = fakePlatform;

    expect(await amplifyPushNotificationsPinpointIosPlugin.getPlatformVersion(), '42');
  });
}
