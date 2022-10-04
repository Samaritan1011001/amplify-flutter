import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:amplify_push_notifications_pinpoint/amplify_push_notifications_pinpoint.dart';
import 'amplifyconfiguration.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  void _configureAmplify() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    // Configure analytics plugin
    AmplifyPushNotificaitonsPinpoint notificationsPlugin =
        AmplifyPushNotificaitonsPinpoint();

    Amplify.addPlugins([notificationsPlugin]);

    try {
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              const Text('Configuration APIs'),
              TextButton(
                onPressed: () async {
                  try {
                    await Amplify.Notifications.requestMessagingPermission();
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('Request for permission'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await Amplify.Notifications.onNewToken();
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('onNewToken'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await Amplify.Notifications.getToken();
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('getToken'),
              ),
              const Text('Configuration APIs'),
              TextButton(
                onPressed: () async {
                  try {
                    await Amplify.Notifications.getToken();
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('Get Token'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
