import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_push_notifications_pinpoint_ios/amplify_push_notifications_pinpoint_ios_method_channel.dart';

void main() {
  MethodChannelAmplifyPushNotificationsPinpointIos platform = MethodChannelAmplifyPushNotificationsPinpointIos();
  const MethodChannel channel = MethodChannel('amplify_push_notifications_pinpoint_ios');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
