import Flutter
import UIKit

public class SwiftAmplifyPushNotificationsPinpointIosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "amplify_push_notifications_pinpoint_ios", binaryMessenger: registrar.messenger())
    let instance = SwiftAmplifyPushNotificationsPinpointIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
