import Flutter
import UIKit
import amplify_core
import Foundation

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}
public class SwiftAmplifyPushNotificationsPinpointIosPlugin: NSObject, FlutterPlugin {

    let channel:FlutterMethodChannel?;
    public init(channel:FlutterMethodChannel) {
        self.channel = channel
    }
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.amazonaws.amplify/notifications_pinpoint", binaryMessenger: registrar.messenger())
      let instance = SwiftAmplifyPushNotificationsPinpointIosPlugin(channel:channel)
    registrar.addMethodCallDelegate(instance, channel: channel)
    registrar.addApplicationDelegate(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      let result = AtomicResult(result, call.method)

      innerHandle(method: call.method, callArgs: call.arguments as Any?, result: result)

  }
    public func innerHandle(method: String, callArgs: Any?, result: @escaping FlutterResult) {
        switch method {
        case "requestMessagingPermission": do {
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in

//                if let error = error {
//                    // Handle the error here.
//                }

                // Enable or disable features based on the authorization.
            }
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
        self.channel?.invokeMethod("getToken",arguments: deviceTokenString);
//       self.sendDeviceTokenToServer(data: deviceToken)
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
        
        print("received notificaiton : \(response)")

    completionHandler()
    }
    
    
}
