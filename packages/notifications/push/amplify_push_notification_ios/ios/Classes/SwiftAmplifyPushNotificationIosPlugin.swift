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
    var _result:FlutterResult!
    
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
    static var bgUserCallback = "bg_user_callback_key"
    static var _launchNotification: String!
    
    
    public init(channel:FlutterMethodChannel) {
        self.channel = channel
    }
    
    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        let atomicResult = AtomicResult(result, call.method)
        
        innerHandle(method: call.method, callArgs: call.arguments as Any?, result: atomicResult)
        
    }
    
    public func innerHandle(method: String, callArgs: Any?, result: @escaping FlutterResult) {
        self._result = result
        let this = SwiftAmplifyPushNotificationIosPlugin.self
        switch method {
        case "getPermissionStatus": do {
            UNUserNotificationCenter.current().getNotificationSettings { notificaitonSettings in
                print("UNNotificationSettings.authorizationStatus \(notificaitonSettings.authorizationStatus == .notDetermined)")
                if notificaitonSettings.authorizationStatus == .authorized {
                    result("granted")

                }else if notificaitonSettings.authorizationStatus == .denied{
                    result("denied")

                }else if notificaitonSettings.authorizationStatus == .notDetermined{
                    result("undetermined")

                }else{
                    result("undetermined")

                }

            }
        }
        case "requestMessagingPermission": do {
            guard let args = callArgs as? String else {
                    result(FlutterError(code: "ERROR", message: "Invalid arguments", details: nil))
                    return
                }

            var options: UNAuthorizationOptions = []
                if let jsonData = args.data(using: .utf8),
                    let jsonObject = try? JSONSerialization.jsonObject(with: jsonData),
                    let json = jsonObject as? [String: Any] {
                    let soundSetting = json["sound"] as? Bool ?? true
                    let badgeSetting = json["badge"] as? Bool ?? true
                    let alertSetting = json["alert"] as? Bool ?? true
                    if soundSetting { options.insert(.sound) }
                    if badgeSetting { options.insert(.badge) }
                    if alertSetting { options.insert(.alert) }
                }
            
                UNUserNotificationCenter.current().requestAuthorization(options: options) { granted, error in
                    if granted {
                            result("granted")
                        } else {
                            if let error = error {
                                result(FlutterError(code: "ERROR", message: error.localizedDescription, details: nil))
                            } else {
                                result("denied")
                            }
                        }
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
        case "getLaunchNotification": do {
            print("Getting Launch Notification")
            if(this._launchNotification != nil){
                print("Launch Notification: \(String(describing: this._launchNotification))")

                result(this._launchNotification)
                this._launchNotification = nil
            }else{
                result(nil)
            }
        }
        case "initializeService": do{
            if let array = callArgs as? [Any] {
                assert(array.count == 1, "Invalid argument count for 'initializeService'")
                this.startPushNotificationService(handle: array[0] as! Int64)
                result(true)
            }
            
        }
        case "PushNotificationBackgroundService.initialized": do{
            print("Dispatch handler methodChannel called PushNotificationBackgroundService.initialized")
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
        case "registerBGUserGivenCallback": do {
            if let array = callArgs as? [Any] {
                assert(array.count == 1, "Invalid argument count for 'registerBGUserGivenCallback'")
                this.setCallbackhandleForKey(handle: array[0] as! Int64, key: this.bgUserCallback)
                result(true)
            }
        }
        default:
            result(FlutterMethodNotImplemented)
        }
    }
    
    
    // public static func setPluginRegistrantCallback(_ completion:  FlutterPluginRegistrantCallback) {
    //     registerPlugins = completion
    // }
    
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
        _callbackChannel = FlutterMethodChannel(name: "plugins.flutter.io/amplify_push_notification_plugin_background", binaryMessenger: _headlessRunner.binaryMessenger)
        

    }
    
    static func startPushNotificationService(handle: Int64)  {
//        print("startPushNotificationService is called")

        setCallbackhandleForKey(handle: handle, key: "callback_dispatch_handler")
        guard let info = FlutterCallbackCache.lookupCallbackInformation(handle) else {
            assertionFailure("failed to find callback")
            return
        }
       
        let entrypoint = info.callbackName
        let uri = info.callbackLibraryPath
        _ = _headlessRunner.run(withEntrypoint: entrypoint, libraryURI: uri)
//        assert(registerPlugins != nil, "failed to set registerPlugins")
        
        // TODO: registerPlugins has to be initialized in flutter app's appdelegate.m
        // Once our headless runner has been started, we need to register the application's plugins
        // with the runner in order for them to work on the background isolate. `registerPlugins` is
        // a callback set from AppDelegate.m in the main application. This callback should register
        // all relevant plugins (excluding those which require UI).
        if !_backgroundIsolateRun {
//            await registerPlugins()
//            print("registerPlugins registered headless runner \(_headlessRunner.isolateId ?? "isolateId is nil")")
            // registerPlugins(_headlessRunner)
           _headlessRunner.registrar(forPlugin: "SwiftAmplifyPushNotificationIosPlugin")!.addMethodCallDelegate(_instance, channel:_callbackChannel)
            
            //            print("callback channel is added to method call delegate")
            
        }
//        _registrar.addMethodCallDelegate(_instance, channel:_callbackChannel)
//        print("callback channel is added to method call delegate")
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
    
    
    
    static func sendNotificationEventToDispatcher() {
        let handle = getCallbackHandleForkey(key: bgUserCallback)
//        print("sendNotificationEventToDispatcher with _callbackChannel = \(_callbackChannel)")
        if handle != 0 && _callbackChannel != nil {
            print("Invoking callback dispatcher methodchannel")
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
        
        if(_result != nil ){
            _result(deviceTokenString);
        }
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

        print("didReceive called")
        let userInfo = response.notification.request.content.userInfo
        let remoteMessage:String
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userInfo)
            remoteMessage = String(data: jsonData, encoding: .utf8) ?? ""
        } catch {
            print("something went wrong with parsing json")
            return
        }
//        SwiftAmplifyPushNotificationIosPlugin._launchNotification = remoteMessage
//        print("received notificaiton on tap: \(SwiftAmplifyPushNotificationIosPlugin._launchNotification)")
        self.channel?.invokeMethod("NOTIFICATION_OPENED_APP", arguments: remoteMessage);

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
//                self.channel?.invokeMethod("BACKGROUND_MESSAGE_RECEIVED",arguments: remoteMessage);
                print("received notificaiton in background: \(userInfo)")
                SwiftAmplifyPushNotificationIosPlugin.sendNotificationEventToDispatcher()
            }
            
            completionHandler(.noData)
            return true
        }
    
}
