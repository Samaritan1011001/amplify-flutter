import Flutter
import UIKit
import Amplify
import amplify_flutter_ios
import Foundation

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}

public class SwiftAmplifyPushNotificationIosPlugin: NSObject, FlutterPlugin {
 
    let channel:FlutterMethodChannel?;
    var result:FlutterResult!;

    public init(channel:FlutterMethodChannel) {
        self.channel = channel
    }
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.amazonaws.amplify/notifications_pinpoint", binaryMessenger: registrar.messenger())
//      let newTokenChannel = FlutterEventChannel(name: "com.amazonaws.amplify/event_channel/notifications_pinpoint", binaryMessenger: registrar.messenger())
      let instance = SwiftAmplifyPushNotificationsPinpointIosPlugin(channel:channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
//      registrar.addMethodCallDelegate(instance, channel: newTokenChannel)
    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      let result = AtomicResult(result, call.method)

      innerHandle(method: call.method, callArgs: call.arguments as Any?, result: result)

  }
    public func innerHandle(method: String, callArgs: Any?, result: @escaping FlutterResult) {
        self.result = result
        switch method {
        case "requestMessagingPermission": do {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in

//                if let error = error {
//                    // Handle the error here.
//                }
                result(granted)
                // Enable or disable features based on the authorization.
            }
        }
        case "registerForRemoteNotifications": do {
            UIApplication.shared.registerForRemoteNotifications()
            UNUserNotificationCenter.current().delegate = self

//            result(true)
        }
        case "onNewToken": do {
               UIApplication.shared.registerForRemoteNotifications()
                
        }
        case "getToken": do {
               UIApplication.shared.registerForRemoteNotifications()
        }
        default:
                   result(FlutterMethodNotImplemented)
               }
    }
  
    
    //    TODO: Not working, debug
//    public func application(_ application: UIApplication,
//               didFinishLaunchingWithOptions launchOptions:
//                            [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//       // Override point for customization after application launch.you’re
//        print("didFinishLaunchingWithOptions ")
//
//       UIApplication.shared.registerForRemoteNotifications()
//        print("didFinishLaunchingWithOptions done")
//
//       return true
//    }

    public func application(_ application: UIApplication,
                didRegisterForRemoteNotificationsWithDeviceToken
                    deviceToken: Data) {
        let deviceTokenString = deviceToken.hexString
        print("deviceToken : \(deviceTokenString)")
//        self.channel?.invokeMethod("getToken",arguments: deviceTokenString);
        result(deviceTokenString);
    }

    public func application(_ application: UIApplication,
                didFailToRegisterForRemoteNotificationsWithError
                    error: Error) {
        print("error getting token : \(error)")
    }
    
    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                didReceive response: UNNotificationResponse,
                withCompletionHandler completionHandler:
                   @escaping () -> Void) {
        
        print("received notificaiton on tap: \(response)")
        self.channel?.invokeMethod("onNotificationOpenedApp",arguments: "notification");


    completionHandler()
    }
    
//    public func userNotificationCenter(_ center: UNUserNotificationCenter,
//             willPresent notification: UNNotification,
//             withCompletionHandler completionHandler:
//                @escaping (UNNotificationPresentationOptions) -> Void) {
//        print("received notificaiton in foreground: \(notification)")
//        self.channel?.invokeMethod("onForegroundNotificationReceived",arguments: "notification");
//
//        // Don't alert the user for other types.
//           completionHandler(UNNotificationPresentationOptions(rawValue: 0))
//    }
    
    public func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
            if UIApplication.shared.applicationState == .active  {
                self.channel?.invokeMethod("onForegroundNotificationReceived",arguments: "notification");
    // Go do some UI stuff
            }else{
                self.channel?.invokeMethod("onBackgroundNotificationReceived",arguments: "notification");

            }
        print("received notificaiton in background: \(userInfo)")

        completionHandler(.noData)
        return true
    }


    
    
}
