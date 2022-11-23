import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_push_notification_android/amplify_push_notification_android_method_channel.dart';

void main() {
  MethodChannelAmplifyPushNotificationAndroid platform = MethodChannelAmplifyPushNotificationAndroid();
  const MethodChannel channel = MethodChannel('amplify_push_notification_android');

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
