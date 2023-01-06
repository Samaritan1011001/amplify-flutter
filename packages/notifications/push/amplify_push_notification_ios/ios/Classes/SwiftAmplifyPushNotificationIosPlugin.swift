import Flutter
import UIKit
import Amplify
import amplify_flutter_ios
import Foundation
import AmplifyUtilsNotifications

extension Data {
    var hexString: String {
        let hexString = map { String(format: "%02.2hhx", $0) }.joined()
        return hexString
    }
}


public class SwiftAmplifyPushNotificationIosPlugin: NSObject, FlutterPlugin {
    
    let channel:FlutterMethodChannel?;
    var result:FlutterResult!;
    
    static var _headlessRunner: FlutterEngine!
    static var _callbackChannel: FlutterMethodChannel!
    static var _mainChannel: FlutterMethodChannel!
    static var _registrar: FlutterPluginRegistrar!
    static var _persistentState: UserDefaults!
    static var _eventQueue: NSMutableArray!
    static var _instance: SwiftAmplifyPushNotificationIosPlugin!
    static var _backgroundIsolateRun = false
    static var registerPlugins: FlutterPluginRegistrantCallback!
    static var _callDispatcherInitialized = false
    
    
    
    
    public init(channel:FlutterMethodChannel) {
        self.channel = channel
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let result = AtomicResult(result, call.method)
        
        innerHandle(method: call.method, callArgs: call.arguments as Any?, result: result)
        
    }
    
    public func innerHandle(method: String, callArgs: Any?, result: @escaping FlutterResult) {
        self.result = result
        let this = SwiftAmplifyPushNotificationIosPlugin.self
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
            
        }
        case "onNewToken": do {
            UIApplication.shared.registerForRemoteNotifications()
            
        }
        case "getToken": do {
            UIApplication.shared.registerForRemoteNotifications()
        }
        case "initializeService": do{
            if let array = callArgs as? [Any] {
                assert(array.count == 1, "Invalid argument count for 'GeofencingPlugin.initializeService'")
                this.startPushNotificationService(handle: array[0] as! Int64)
                result(true)
            }
            
        }
        case "PushNotificationBackgroundService.initialized": do{
            this._callDispatcherInitialized = true
            // TODO: Send the geofence events that occurred while the background isolate was initializing.
            //            objc_sync_enter(self)
            //            initialized = true
            //            while this._eventQueue.count > 0 {
            //                let event = this._eventQueue[0]
            //                this._eventQueue.remove(at: 0)
            //                let region = event[kRegionKey] as! CLRegion
            //                let type = event[kEventType] as! Int
            //                sendLocationEvent(region, eventType: type)
            //            }
            //            objc_sync_exit(self)
            result(nil)
        }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    public static func setPluginRegistrantCallback(registerPlugin: FlutterPluginRegistrantCallback) {
        registerPlugins = registerPlugin
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        print("register is called: \(registrar)")
        // 1. Create the method channel used by the Dart interface to invoke
        // methods and register to listen for method calls.
        let channel = FlutterMethodChannel(name: "com.amazonaws.amplify/push_notification_plugin", binaryMessenger: registrar.messenger())
        _instance = SwiftAmplifyPushNotificationIosPlugin(channel:channel)
        registrar.addMethodCallDelegate(_instance, channel: channel)
        registrar.addApplicationDelegate(_instance)
        
        // 2. Retrieve NSUserDefaults which will be used to store callback handles
        // between launches.
        _persistentState = UserDefaults.standard
        _eventQueue = NSMutableArray()
        
        
        // 3. Initialize the Dart runner which will be used to run the callback
        // dispatcher.
        _headlessRunner = FlutterEngine(name: "AmpifyPushIsolate", project: nil, allowHeadlessExecution: true)
        _registrar = registrar
        
        
        // 4. Create a second method channel to be used to communicate with the
        // callback dispatcher. This channel will be registered to listen for
        // method calls once the callback dispatcher is started.
        _callbackChannel = FlutterMethodChannel(name: "plugins.flutter.io/push_notification_plugin_background", binaryMessenger: _headlessRunner.binaryMessenger)
        
    }
    
    static func startPushNotificationService(handle: Int64) {
        print("startPushNotificationService is called")

        setCallbackhandleForKey(handle: handle, key: "callback_dispatch_handler")
        guard let info = FlutterCallbackCache.lookupCallbackInformation(handle) else {
            assertionFailure("failed to find callback")
            return
        }
        let entrypoint = info.callbackName
        let uri = info.callbackLibraryPath
        let result = _headlessRunner.run(withEntrypoint: entrypoint, libraryURI: uri)
        print("result \(result)")
        assert(registerPlugins != nil, "failed to set registerPlugins")
        assert(result == false, "headless runner still not ready")

        // TODO: registerPlugins has to be initialized in flutter app's appdelegate.m
        // Once our headless runner has been started, we need to register the application's plugins
        // with the runner in order for them to work on the background isolate. `registerPlugins` is
        // a callback set from AppDelegate.m in the main application. This callback should register
        // all relevant plugins (excluding those which require UI).
        if !_backgroundIsolateRun {
            registerPlugins?(_headlessRunner)
        }
        _registrar.addMethodCallDelegate(_instance, channel:_callbackChannel)
        _registrar.addApplicationDelegate(_instance)

        print("callback channel is added to method call delegate")
        _backgroundIsolateRun = true
    }
    
    static func getCallbackHandleForkey(key: String) -> Int64 {
        if let handle = _persistentState.object(forKey: key) as? NSNumber {
            return handle.int64Value
        }
        return 0
    }
    
    static func setCallbackhandleForKey(handle: Int64, key: String) {
        _persistentState.set(NSNumber(value: handle), forKey: key)
    }
    
    
    static func registerGeofence(arguments: [Any]) {
        print("RegisterGeofence: \(arguments)")
        let callbackHandle = arguments[0] as! Int64
        setCallbackhandleForKey(handle: callbackHandle, key: "callback_handle")
    }
    
    static func sendNotificationEventToDispatcher() {
        let handle = getCallbackHandleForkey(key: "callback_dispatch_handler")
        if handle != 0 && _callbackChannel != nil {
            _callbackChannel.invokeMethod("", arguments: [
                handle
            ])
        }
    }
    
    public func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken
                            deviceToken: Data) {
        let deviceTokenString = deviceToken.hexString
        print("deviceToken : \(deviceTokenString)")
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
        self.channel?.invokeMethod("NOTIFICATION_OPENED_APP",arguments: "notification");
        
        
        completionHandler()
    }
    
    
    
    public func application(
        _ application: UIApplication,
        didReceiveRemoteNotification userInfo: [AnyHashable : Any],
        fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) -> Bool {
            let remoteMessage:String
            do {
                let jsonData = try JSONSerialization.data(withJSONObject: userInfo)
                remoteMessage = String(data: jsonData, encoding: .utf8) ?? ""
            } catch {
                print("something went wrong with parsing json")
                return false
            }
            if UIApplication.shared.applicationState == .active  {
                self.channel?.invokeMethod("FOREGROUND_MESSAGE_RECEIVED",arguments: remoteMessage);
                // Go do some UI stuff
            }else{
                self.channel?.invokeMethod("BACKGROUND_MESSAGE_RECEIVED",arguments: remoteMessage);
                print("received notificaiton in background: \(userInfo)")
//                SwiftAmplifyPushNotificationIosPlugin.sendNotificationEventToDispatcher()
            }
            
            completionHandler(.noData)
            return true
        }
    
}
