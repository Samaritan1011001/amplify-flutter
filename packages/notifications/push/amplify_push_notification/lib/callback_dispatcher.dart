import 'dart:ui';

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// CallbackDispatcher is a standalone function that must reside in the gloabal scope with the vm:entry-point annotation. It has the following responsibilities,
/// 1. Initialize a background channel that is used to communicate with the Dart isolate
/// 2. Make sure Flutter Widget binding are available through WidgetsFlutterBinding.ensureInitialized()
@pragma('vm:entry-point')
void callbackDispatcher() {
  print("CallbackDispatcher was called");

  WidgetsFlutterBinding.ensureInitialized();
  const MethodChannel backgroundChannel = MethodChannel(
      'plugins.flutter.io/amplify_push_notification_plugin_background');
  backgroundChannel.setMethodCallHandler((MethodCall call) async {
    final List<dynamic> args = call.arguments;
    final Function? callback = PluginUtilities.getCallbackFromHandle(
        CallbackHandle.fromRawHandle(args[0]));
    assert(callback != null);

    // print("user callback is being invoked");
    // TODO: Pass along the notification from the broadcast receiver
    callback!(RemotePushMessage());
  });
  print("CallbackDispatcher was initialized");

  backgroundChannel
      .invokeMethod('PushNotificationBackgroundService.initialized');
}
