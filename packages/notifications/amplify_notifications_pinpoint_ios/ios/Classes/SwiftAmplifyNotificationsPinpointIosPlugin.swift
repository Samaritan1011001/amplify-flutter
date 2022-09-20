import Flutter
import UIKit

public class SwiftAmplifyNotificationsPinpointIosPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "amplify_notifications_pinpoint_ios", binaryMessenger: registrar.messenger())
    let instance = SwiftAmplifyNotificationsPinpointIosPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
