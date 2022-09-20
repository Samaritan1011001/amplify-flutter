#import "AmplifyNotificationsPinpointIosPlugin.h"
#if __has_include(<amplify_notifications_pinpoint_ios/amplify_notifications_pinpoint_ios-Swift.h>)
#import <amplify_notifications_pinpoint_ios/amplify_notifications_pinpoint_ios-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "amplify_notifications_pinpoint_ios-Swift.h"
#endif

@implementation AmplifyNotificationsPinpointIosPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAmplifyNotificationsPinpointIosPlugin registerWithRegistrar:registrar];
}
@end
