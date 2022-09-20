import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:amplify_notifications_pinpoint/method_channel_amplify.dart';

void main() {
  MethodChannelAmplifyNotificationsPinpoint platform = MethodChannelAmplifyNotificationsPinpoint();
  const MethodChannel channel = MethodChannel('amplify_notifications_pinpoint');

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
