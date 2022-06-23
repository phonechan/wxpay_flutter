#import <Flutter/Flutter.h>

@interface WxpayPlugin : NSObject<FlutterPlugin>

+ (WxpayPlugin *)defaultService;

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:
(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options;
@end
