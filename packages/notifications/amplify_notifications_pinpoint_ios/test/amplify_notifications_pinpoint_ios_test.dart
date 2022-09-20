import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_notifications_pinpoint_ios/amplify_notifications_pinpoint_ios.dart';
import 'package:amplify_notifications_pinpoint_ios/amplify_notifications_pinpoint_ios_platform_interface.dart';
import 'package:amplify_notifications_pinpoint_ios/amplify_notifications_pinpoint_ios_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAmplifyNotificationsPinpointIosPlatform
    with MockPlatformInterfaceMixin
    implements AmplifyNotificationsPinpointIosPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AmplifyNotificationsPinpointIosPlatform initialPlatform = AmplifyNotificationsPinpointIosPlatform.instance;

  test('$MethodChannelAmplifyNotificationsPinpointIos is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAmplifyNotificationsPinpointIos>());
  });

  test('getPlatformVersion', () async {
    AmplifyNotificationsPinpointIos amplifyNotificationsPinpointIosPlugin = AmplifyNotificationsPinpointIos();
    MockAmplifyNotificationsPinpointIosPlatform fakePlatform = MockAmplifyNotificationsPinpointIosPlatform();
    AmplifyNotificationsPinpointIosPlatform.instance = fakePlatform;

    expect(await amplifyNotificationsPinpointIosPlugin.getPlatformVersion(), '42');
  });
}
