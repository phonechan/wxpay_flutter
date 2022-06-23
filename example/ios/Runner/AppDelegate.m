#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "WxpayPlugin.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [GeneratedPluginRegistrant registerWithRegistry:self];
    // Override point for customization after application launch.
    return [super application:application didFinishLaunchingWithOptions:launchOptions];
}



- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:
(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    
    return [WxpayPlugin.defaultService application:application
                                           openURL:url
                                           options:options];
}


@end
