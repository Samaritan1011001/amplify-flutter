import Flutter
import UIKit
import amplify_core

public class SwiftAmplifyPushNotificationsPinpointIosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.amazonaws.amplify/notifications_pinpoint", binaryMessenger: registrar.messenger())
    let instance = SwiftAmplifyPushNotificationsPinpointIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
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

                if let error = error {
                    // Handle the error here.
                }

                // Enable or disable features based on the authorization.
            }
        }

        default:
                   result(FlutterMethodNotImplemented)
               }
    }
}
