import 'dart:io' show Platform;

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_push_notifications_pinpoint/amplify_push_notifications_pinpoint.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'amplifyconfiguration.dart';

// @pragma('vm:entry-point')
// void globalBgCallback(RemotePushMessage remotePushMessage) async {
//   print("user Given callback called");
//   try {
//     // DartPluginRegistrant.ensureInitialized();
//     WidgetsFlutterBinding.ensureInitialized();

//     final prefs = await SharedPreferences.getInstance();

//     final int? globalBgCallbackCalled = prefs.getInt('globalBgCallbackCalled');

//     await prefs.setInt('globalBgCallbackCalled',
//         globalBgCallbackCalled != null ? (globalBgCallbackCalled + 1) : 0);
//   } catch (e) {
//     print("Error when post call $e");
//   }
// }

// @pragma('vm:entry-point')
// void globalOnNotificationOpenedCallback(
//     RemotePushMessage remotePushMessage) async {
//   print("globalOnNotificationOpenedCallback called");
//   try {
//     final prefs = await SharedPreferences.getInstance();

//     final int? globalBgCallbackCalled =
//         prefs.getInt('globalOnNotificationOpenedCallback');

//     await prefs.setInt('globalOnNotificationOpenedCallback',
//         globalBgCallbackCalled != null ? (globalBgCallbackCalled + 1) : 0);
//   } catch (e) {
//     print("Error when post call $e");
//   }
// }

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
  PushPermissionRequestStatus? pushPermissionRequestStatus;
  RemotePushMessage? foregroundMessage;
  RemotePushMessage? backgroundMessage;
  RemotePushMessage? notificationOpenedMessage;
  String? token;
  String globalBgCallbackKey = "globalBgCallbackCalled";
  String globalOnNotificationOpenedCallbackKey =
      "globalOnNotificationOpenedCallback";
  int globalBgCallbackCount = 0;
  int globalOnNotificationOpenedCallbackCount = 0;
  bool isConfigured = false;
  bool isForegroundListernerInitialized = false;
  bool isBackgroundListernerInitialized = false;
  bool isOnNotificationOpenedListernerInitialized = false;
  Map permissionOptionsMap = {"alert": true, "sound": true, "badge": true};
  @override
  void initState() {
    super.initState();

    // TODO: implement initState
    getAndUpdateCallbackCounts();
  }

  static void globalBgCallback(RemotePushMessage remotePushMessage) async {
    print("globalBgCallback called");
    try {
      // DartPluginRegistrant.ensureInitialized();
      WidgetsFlutterBinding.ensureInitialized();

      final prefs = await SharedPreferences.getInstance();

      final int? globalBgCallbackCalled =
          prefs.getInt('globalBgCallbackCalled');

      await prefs.setInt('globalBgCallbackCalled',
          globalBgCallbackCalled != null ? (globalBgCallbackCalled + 1) : 0);
    } catch (e) {
      print("Error when post call $e");
    }
  }

  static void globalOnNotificationOpenedCallback(
      RemotePushMessage remotePushMessage) async {
    print("globalOnNotificationOpenedCallback called");
    try {
      final prefs = await SharedPreferences.getInstance();

      final int? globalBgCallbackCalled =
          prefs.getInt('globalOnNotificationOpenedCallback');

      await prefs.setInt('globalOnNotificationOpenedCallback',
          globalBgCallbackCalled != null ? (globalBgCallbackCalled + 1) : 0);
    } catch (e) {
      print("Error when post call $e");
    }
  }

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

  void localOnNotificationOpenedCallback(
      RemotePushMessage remotePushMessage) async {
    print("localOnNotificationOpenedCallback called");
    try {
      setState(() {
        notificationOpenedMessage = remotePushMessage;
      });
    } catch (e) {
      print("Error when post call $e");
    }
  }

  void getAndUpdateCallbackCounts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.reload();
      setState(() {
        globalBgCallbackCount = prefs.getInt(globalBgCallbackKey) ?? -1;
        globalOnNotificationOpenedCallbackCount =
            prefs.getInt(globalOnNotificationOpenedCallbackKey) ?? -1;
      });
      print("globalBgCallbackCount -> $globalBgCallbackCount");
      print(
          "globalOnNotificationOpenedCallbackCount -> $globalOnNotificationOpenedCallbackCount");
    } catch (e) {
      print("Error when get call $e");
    }
  }

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
                if (Platform.isAndroid) ...[
                  ListTile(
                    title: Text(
                        "Background callback count: $globalBgCallbackCount"),
                  ),
                  ListTile(
                    title: Text(
                      "onNotification open callback count: $globalOnNotificationOpenedCallbackCount",
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        getAndUpdateCallbackCounts();
                      },
                      child: const Text("Update counter values"))
                ],

                // ElevatedButton(
                //   onPressed: () async {
                //     try {
                //       print("Save locally");

                //       final prefs = await SharedPreferences.getInstance();

                //       final int? val = prefs.getInt(key);

                //       await prefs.setInt(key, val != null ? (val + 1) : 0);
                //     } catch (e) {
                //       print("Error when post call $e");
                //     }
                //   },
                //   child: const Text('Save locally'),
                // ),
                const Divider(
                  height: 20,
                ),
                headerText('Configuration APIs'),

                ElevatedButton(
                  onPressed: () async {
                    _configureAmplify();
                  },
                  child: const Text('configure'),
                ),
                if (isConfigured)
                  const Text("Push notification plugin has been configured"),

                if (Platform.isIOS) ...[
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
                        pushPermissionRequestStatus = await Amplify
                            .Notifications.requestMessagingPermission(
                          alert: permissionOptionsMap['alert'],
                          sound: permissionOptionsMap['sound'],
                          badge: permissionOptionsMap['badge'],
                        );
                        setState(() {});
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    child: const Text('requestMessagingPermission'),
                  ),
                  if (pushPermissionRequestStatus != null)
                    Text(
                        "Permission grant status: $pushPermissionRequestStatus"),
                ],
                ElevatedButton(
                  onPressed: () async {
                    try {
                      pushPermissionRequestStatus = await Amplify.Notifications
                          .requestMessagingPermission(
                        alert: permissionOptionsMap['alert'],
                        sound: permissionOptionsMap['sound'],
                        badge: permissionOptionsMap['badge'],
                      );
                      setState(() {});
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: const Text('requestMessagingPermission'),
                ),
                // ElevatedButton(
                //   onPressed: () async {
                //     try {
                //       // await Amplify.Notifications.identifyUser();
                //     } catch (e) {
                //       print(e.toString());
                //     }
                //   },
                //   child: const Text('identifyUser'),
                // ),
                const Divider(
                  height: 20,
                ),
                headerText('Token Access APIs'),

                ElevatedButton(
                  onPressed: () async {
                    try {
                      token = await Amplify.Notifications.getToken();
                      if (token != null) setState(() {});
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: const Text('getToken'),
                ),
                Text(token == null ? "No token yet" : "Device token: $token"),

                // if (Platform.isAndroid)
                //   ElevatedButton(
                //     onPressed: () async {
                //       try {
                //         final onNewTokenStream =
                //             await Amplify.Notifications.onNewToken();
                //         onNewTokenStream.listen((event) {
                //           setState(() {
                //             token = event;
                //           });
                //         });
                //       } catch (e) {
                //         print(e.toString());
                //       }
                //     },
                //     child: const Text('onNewToken'),
                //   ),

                const Divider(
                  height: 20,
                ),
                headerText('Notification Handling APIs'),

                ElevatedButton(
                  onPressed: () async {
                    try {
                      final foregroundStream = Amplify.Notifications
                          .onForegroundNotificationReceived();
                      foregroundStream.listen((event) {
                        setState(() {
                          foregroundMessage = event;
                        });
                      });
                      setState(() {
                        isForegroundListernerInitialized = true;
                      });
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: const Text('onForegroundNotificationReceived'),
                ),
                if (isForegroundListernerInitialized)
                  const Text("Foreground event listener initialized!"),
                ListTile(
                  title: Text(
                    foregroundMessage == null
                        ? "No foreground message yet"
                        : "Title: ${foregroundMessage!.content?.title?.toString() ?? ""}",
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      Amplify.Notifications.onBackgroundNotificationReceived(
                        Platform.isIOS ? localBgCallback : globalBgCallback,
                      );
                      // Amplify.Notifications.onBackgroundNotificationReceived(
                      //   globalBgCallback,
                      // );
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
                if (Platform.isIOS)
                  ListTile(
                    title: Text(
                      backgroundMessage == null
                          ? "No background message yet"
                          : "Title: ${backgroundMessage!.content?.title?.toString() ?? ""}",
                    ),
                  ),

                ElevatedButton(
                  onPressed: () async {
                    try {
                      Amplify.Notifications.onNotificationOpenedApp(
                        Platform.isIOS
                            ? localOnNotificationOpenedCallback
                            : globalOnNotificationOpenedCallback,
                      );

                      setState(() {
                        isOnNotificationOpenedListernerInitialized = true;
                      });
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  child: const Text('onNotificationOpenedApp'),
                ),
                if (isOnNotificationOpenedListernerInitialized)
                  const ListTile(
                    title: Text(
                        "onNotificationOpened event listener initialized!"),
                  ),
                if (Platform.isIOS)
                  ListTile(
                    title: Text(
                      notificationOpenedMessage == null
                          ? "No notification opened message yet"
                          : "Title: ${notificationOpenedMessage!.content?.title?.toString() ?? ""}",
                    ),
                  ),
                // ElevatedButton(
                //   onPressed: () async {
                //     try {
                //       Amplify.Notifications.getInitialNotification();
                //     } catch (e) {
                //       print(e.toString());
                //     }
                //   },
                //   child: const Text('getInitialNotification'),
                // ),
                // const Text('Notification Customization APIs'),
                // ElevatedButton(
                //   onPressed: () async {
                //     try {
                //       await Amplify.Notifications.getBadgeCount();
                //     } catch (e) {
                //       print(e.toString());
                //     }
                //   },
                //   child: const Text('getBadgeCount'),
                // ),
                // ElevatedButton(
                //   onPressed: () async {
                //     try {
                //       await Amplify.Notifications.setBadgeCount(0);
                //     } catch (e) {
                //       print(e.toString());
                //     }
                //   },
                //   child: const Text('setBadgeCount'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
