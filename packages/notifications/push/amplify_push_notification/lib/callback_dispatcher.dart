import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  print("callbackDispatcher was called");

  WidgetsFlutterBinding.ensureInitialized();
  const MethodChannel backgroundChannel = MethodChannel(
      'plugins.flutter.io/amplify_push_notification_plugin_background');
  backgroundChannel.setMethodCallHandler((MethodCall call) async {
    final List<dynamic> args = call.arguments;
    final Function? callback = PluginUtilities.getCallbackFromHandle(
        CallbackHandle.fromRawHandle(args[0]));
    assert(callback != null);

    // TODO: Pass the notification from the broadcast receiver to here
    callback!();
  });
  print("callbackDispatcher was initialized");

  backgroundChannel
      .invokeMethod('PushNotificationBackgroundService.initialized');
}

// void userCallback() {
//   try {
//     print("User callback was called");

//     // var url = Uri.https('jsonplaceholder.typicode.com', '/posts');
//     // final response = await http.post(
//     //   url,
//     //   body: {
//     //     'title': 'created when app is killed by bg task',
//     //     'body': 'bar',
//     //     'userId': 1,
//     //   },
//     //   headers: {
//     //     'Content-type': 'application/json; charset=UTF-8',
//     //   },
//     // );
//   } catch (e) {
//     print("Error when post call $e");
//   }
// }
