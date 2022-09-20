import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_notifications_pinpoint/amplify_notifications_pinpoint.dart';
import 'package:amplify_notifications_pinpoint/amplify_notifications_pinpoint_platform_interface.dart';
import 'package:amplify_notifications_pinpoint/method_channel_amplify.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAmplifyNotificationsPinpointPlatform
    with MockPlatformInterfaceMixin
    implements AmplifyNotificationsPinpointPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AmplifyNotificationsPinpointPlatform initialPlatform = AmplifyNotificationsPinpointPlatform.instance;

  test('$MethodChannelAmplifyNotificationsPinpoint is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAmplifyNotificationsPinpoint>());
  });

  test('getPlatformVersion', () async {
    AmplifyNotificationsPinpoint amplifyNotificationsPinpointPlugin = AmplifyNotificationsPinpoint();
    MockAmplifyNotificationsPinpointPlatform fakePlatform = MockAmplifyNotificationsPinpointPlatform();
    AmplifyNotificationsPinpointPlatform.instance = fakePlatform;

    expect(await amplifyNotificationsPinpointPlugin.getPlatformVersion(), '42');
  });
}
