import 'dart:ui';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_push_notifications_pinpoint/amplify_push_notifications_pinpoint.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'amplifyconfiguration.dart';

@pragma('vm:entry-point')
void globalBgCallback(RemotePushMessage remotePushMessage) async {
  print("globalBgCallback called");
  try {
    DartPluginRegistrant.ensureInitialized();
    WidgetsFlutterBinding.ensureInitialized();
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final int? globalBgCallbackCalled = prefs.getInt('globalBgCallbackCalled');

    await prefs.setInt('globalBgCallbackCalled',
        globalBgCallbackCalled != null ? (globalBgCallbackCalled + 1) : -1);
  } catch (e) {
    print("Error when post call $e");
  }
}

void main() {
  AmplifyLogger().logLevel = LogLevel.info;
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  RemotePushMessage? backgroundMessage;

  String globalBgCallbackKey = "globalBgCallbackCalled";

  int globalBgCallbackCount = 0;

  bool isConfigured = false;

  bool isBackgroundListernerInitialized = false;
  Map permissionOptionsMap = {"alert": true, "sound": true, "badge": true};
  @override
  void initState() {
    super.initState();

    getAndUpdateCallbackCounts();
  }

  // static void globalBgCallback(RemotePushMessage remotePushMessage) async {
  //   print("globalBgCallback called");
  //   try {
  //     DartPluginRegistrant.ensureInitialized();
  //     WidgetsFlutterBinding.ensureInitialized();
  //     final prefs = await SharedPreferences.getInstance();
  //     await prefs.reload();
  //     final int? globalBgCallbackCalled =
  //         prefs.getInt('globalBgCallbackCalled');

  //     await prefs.setInt('globalBgCallbackCalled',
  //         globalBgCallbackCalled != null ? (globalBgCallbackCalled + 1) : 0);
  //   } catch (e) {
  //     print("Error when post call $e");
  //   }
  // }

  void localBgCallback(RemotePushMessage remotePushMessage) async {
    print("localBgCallback callback called");
    try {
      setState(() {
        backgroundMessage = remotePushMessage;
      });
    } catch (e) {
      print("Error when post call $e");
    }
  }

  void getAndUpdateCallbackCounts() async {
    try {
      if (!Amplify.isConfigured) await _configureAmplify();

      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      final newCount = prefs.getInt(globalBgCallbackKey) ?? -1;
      setState(() {
        globalBgCallbackCount = newCount;
      });
      print("globalBgCallbackCount -> $globalBgCallbackCount");
    } catch (e) {
      print("Error when get call $e");
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _configureAmplify() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    AmplifyPushNotificaitonsPinpoint notificationsPlugin =
        AmplifyPushNotificaitonsPinpoint();
    final authPlugin = AmplifyAuthCognito();

    await Amplify.addPlugins([authPlugin, notificationsPlugin]);
    setState(() {
      isConfigured = true;
    });
    try {
      await Amplify.configure(amplifyconfig);
    } catch (e) {
      print(e.toString());
    }
  }

  Widget headerText(String title) => Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Center(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                ListTile(
                  title:
                      Text("Background callback count: $globalBgCallbackCount"),
                ),
                TextButton(
                    onPressed: () {
                      getAndUpdateCallbackCounts();
                    },
                    child: const Text("Update counter values")),
                const Divider(
                  height: 20,
                ),
                headerText('Configuration APIs'),
                ElevatedButton(
                  onPressed: () async {
                    await _configureAmplify();
                  },
                  child: const Text('configure'),
                ),
                if (isConfigured)
                  const Text("Push notification plugin has been configured"),
                CheckboxListTile(
                  title: const Text("alert"),
                  value: permissionOptionsMap['alert'],
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (newValue) {
                    setState(() {
                      permissionOptionsMap['alert'] = newValue;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("sound"),
                  value: permissionOptionsMap['sound'],
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (newValue) {
                    setState(() {
                      permissionOptionsMap['sound'] = newValue;
                    });
                  },
                ),
                CheckboxListTile(
                  title: const Text("badge"),
                  value: permissionOptionsMap['badge'],
                  controlAffinity: ListTileControlAffinity.leading,
                  onChanged: (newValue) {
                    setState(() {
                      permissionOptionsMap['badge'] = newValue;
                    });
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await Amplify.Notifications.requestMessagingPermission(
                        alert: permissionOptionsMap['alert'],
                        sound: permissionOptionsMap['sound'],
                        badge: permissionOptionsMap['badge'],
                      );
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: const Text('requestMessagingPermission'),
                ),
                const Divider(
                  height: 20,
                ),
                headerText('Notification Handling APIs'),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      // Amplify.Notifications.onBackgroundNotificationReceived(
                      //   Platform.isIOS ? localBgCallback : globalBgCallback,
                      // );
                      Amplify.Notifications.onBackgroundNotificationReceived(
                        globalBgCallback,
                      );
                      setState(() {
                        isBackgroundListernerInitialized = true;
                      });
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: const Text('onBackgroundNotificationReceived'),
                ),
                if (isBackgroundListernerInitialized)
                  const ListTile(
                    title: Text("Background event listener initialized!"),
                  ),
                ListTile(
                  title: Text(
                    backgroundMessage == null
                        ? "No background message yet"
                        : "Title: ${backgroundMessage!.content?.title?.toString() ?? ""}",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
