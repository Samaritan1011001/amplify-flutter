 import UIKit
 import amplify_push_notification_ios
 import Flutter

 @UIApplicationMain
 @objc class AppDelegate: FlutterAppDelegate {
     /// Registers all pubspec-referenced Flutter plugins in the given registry.
     static func registerPlugins(with registry: FlutterPluginRegistry) {
             GeneratedPluginRegistrant.register(with: registry)
        }
     override func application(
         _ application: UIApplication,
         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
     ) -> Bool {
         AppDelegate.registerPlugins(with: self) // Register the app's plugins in the context of a normal run
         SwiftAmplifyPushNotificationIosPlugin.setPluginRegistrantCallback{ registry in
             print("registerPlugins was run")
             // The following code will be called upon WorkmanagerPlugin's registration.
                         // Note : all of the app's plugins may not be required in this context ;
                         // instead of using GeneratedPluginRegistrant.register(with: registry),
                         // you may want to register only specific plugins.
                         AppDelegate.registerPlugins(with: registry)
            
         }
         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
     }
    
 }

//import UIKit
//import Flutter
//
//@UIApplicationMain
//@objc class AppDelegate: FlutterAppDelegate {
//  override func application(
//    _ application: UIApplication,
//    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//  ) -> Bool {
//    GeneratedPluginRegistrant.register(with: self)
//    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//  }
//}
