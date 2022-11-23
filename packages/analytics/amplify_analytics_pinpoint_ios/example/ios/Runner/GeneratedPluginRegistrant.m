//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<amplify_analytics_pinpoint_ios/AnalyticsPinpoint.h>)
#import <amplify_analytics_pinpoint_ios/AnalyticsPinpoint.h>
#else
@import amplify_analytics_pinpoint_ios;
#endif

#if __has_include(<amplify_flutter_ios/Amplify.h>)
#import <amplify_flutter_ios/Amplify.h>
#else
@import amplify_flutter_ios;
#endif

#if __has_include(<amplify_secure_storage/AmplifySecureStoragePlugin.h>)
#import <amplify_secure_storage/AmplifySecureStoragePlugin.h>
#else
@import amplify_secure_storage;
#endif

#if __has_include(<path_provider_ios/FLTPathProviderPlugin.h>)
#import <path_provider_ios/FLTPathProviderPlugin.h>
#else
@import path_provider_ios;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [AnalyticsPinpoint registerWithRegistrar:[registry registrarForPlugin:@"AnalyticsPinpoint"]];
  [Amplify registerWithRegistrar:[registry registrarForPlugin:@"Amplify"]];
  [AmplifySecureStoragePlugin registerWithRegistrar:[registry registrarForPlugin:@"AmplifySecureStoragePlugin"]];
  [FLTPathProviderPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTPathProviderPlugin"]];
}

@end
