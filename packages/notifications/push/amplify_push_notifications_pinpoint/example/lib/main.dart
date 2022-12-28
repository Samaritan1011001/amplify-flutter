import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_push_notifications_pinpoint/amplify_push_notifications_pinpoint.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'amplifyconfiguration.dart';

@pragma('vm:entry-point')
void userCallback() async {
  print("user Given callback called");
  try {
    final prefs = await SharedPreferences.getInstance();

    final int? userCallbackCalled = prefs.getInt('userCallbackCalled');

    await prefs.setInt('userCallbackCalled',
        userCallbackCalled != null ? (userCallbackCalled + 1) : 0);
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
  PushPermissionRequestStatus pushPermissionRequestStatus =
      PushPermissionRequestStatus.undetermined;
  RemotePushMessage? foregroundMessage;
  RemotePushMessage? backgroundMessage;
  RemotePushMessage? notificationOpenedMessage;
  String? token;

  // Platform messages are asynchronous, so we initialize in an async method.
  void _configureAmplify() async {
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    AmplifyPushNotificaitonsPinpoint notificationsPlugin =
        AmplifyPushNotificaitonsPinpoint();
    final authPlugin = AmplifyAuthCognito();

    await Amplify.addPlugins([authPlugin, notificationsPlugin]);

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
          child: ListView(
            children: [
              TextButton(
                onPressed: () async {
                  try {
                    final prefs = await SharedPreferences.getInstance();

                    final int? userCallbackCalled =
                        prefs.getInt('userCallbackCalled');

                    print(" user callback read count -> $userCallbackCalled");
                  } catch (e) {
                    print("Error when get call $e");
                  }
                },
                child: const Text('Check saved bool'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    print("User callback was called");

                    final prefs = await SharedPreferences.getInstance();

                    final int? userCallbackCalled =
                        prefs.getInt('userCallbackCalled');

                    await prefs.setInt(
                        'userCallbackCalled',
                        userCallbackCalled != null
                            ? (userCallbackCalled + 1)
                            : 0);
                  } catch (e) {
                    print("Error when post call $e");
                  }
                },
                child: const Text('Save locally'),
              ),
              const Text('Configuration APIs'),
              TextButton(
                onPressed: () async {
                  _configureAmplify();
                },
                child: const Text('configure'),
              ),
              // TextButton(
              //   onPressed: () async {
              //     try {
              //       await Amplify.Notifications
              //           .registerForRemoteNotifications();
              //     } catch (e) {
              //       print(e.toString());
              //     }
              //   },
              //   child: const Text('registerForRemoteNotifications'),
              // ),
              TextButton(
                onPressed: () async {
                  try {
                    setState(() async {
                      pushPermissionRequestStatus = await Amplify.Notifications
                          .requestMessagingPermission();
                    });
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('requestMessagingPermission'),
              ),
              Text("Permission grant status: $pushPermissionRequestStatus"),
              TextButton(
                onPressed: () async {
                  try {
                    // await Amplify.Notifications.identifyUser();
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('identifyUser'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await Amplify.Notifications
                        .unregisterForRemoteNotifications();
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('unregisterForRemoteNotifications'),
              ),
              const Text('Token Access APIs'),
              TextButton(
                onPressed: () async {
                  try {
                    final onNewTokenStream =
                        await Amplify.Notifications.onNewToken();
                    onNewTokenStream.listen((event) {
                      setState(() {
                        token = event;
                      });
                    });
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('onNewToken'),
              ),
              Text(token == null ? "No token yet" : token!),
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
              const Text('Notification Handling APIs'),
              TextButton(
                onPressed: () async {
                  try {
                    final foregroundStream = Amplify.Notifications
                        .onForegroundNotificationReceived();
                    foregroundStream.listen((event) {
                      setState(() {
                        foregroundMessage = event;
                      });
                    });
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('onForegroundNotificationReceived'),
              ),
              Text(foregroundMessage == null
                  ? "No foreground message yet"
                  : (foregroundMessage!.messageId ?? '')),
              TextButton(
                onPressed: () async {
                  try {
                    // final backgroundStream = Amplify.Notifications
                    //     .onBackgroundNotificationReceived();
                    // backgroundStream.listen((event) {
                    //   print("User listened background function called");
                    //   setState(() {
                    //     backgroundMessage = event;
                    //   });
                    // });
                    Amplify.Notifications.onBackgroundNotificationReceived(
                        userCallback);
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('onBackgroundNotificationReceived'),
              ),
              // Text(backgroundMessage == null
              //     ? "No background message yet"
              //     : (backgroundMessage!.messageId ?? "")),
              Text(backgroundMessage == null
                  ? "No background message yet"
                  : (backgroundMessage!.content.toString())),

              TextButton(
                onPressed: () async {
                  try {
                    Amplify.Notifications.onNotificationOpenedApp();
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('onNotificationOpenedApp'),
              ),
              Text(notificationOpenedMessage == null
                  ? "No notification opened message yet"
                  : (notificationOpenedMessage!.messageId ?? "")),
              TextButton(
                onPressed: () async {
                  try {
                    Amplify.Notifications.getInitialNotification();
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('getInitialNotification'),
              ),
              const Text('Notification Customization APIs'),
              TextButton(
                onPressed: () async {
                  try {
                    await Amplify.Notifications.getBadgeCount();
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('getBadgeCount'),
              ),
              TextButton(
                onPressed: () async {
                  try {
                    await Amplify.Notifications.setBadgeCount(0);
                  } catch (e) {
                    print(e.toString());
                  }
                },
                child: const Text('setBadgeCount'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
