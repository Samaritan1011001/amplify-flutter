import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_push_notification_ios/amplify_push_notification_ios_method_channel.dart';

void main() {
  MethodChannelAmplifyPushNotificationIos platform = MethodChannelAmplifyPushNotificationIos();
  const MethodChannel channel = MethodChannel('amplify_push_notification_ios');

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
