#import "WxpayPlugin.h"
#import "WXApi.h"

@interface WxpayPlugin ()<WXApiDelegate>

@end

@implementation WxpayPlugin{
    FlutterMethodChannel* _channel;
}

+ (WxpayPlugin *)defaultService {
    static WxpayPlugin* service = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if(service == nil){
            service = [[WxpayPlugin alloc] init];
        }
    });
    
    return service;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    FlutterMethodChannel* channel = [FlutterMethodChannel
                                     methodChannelWithName:@"wxpay"
                                     binaryMessenger:[registrar messenger]];
    [WxpayPlugin.defaultService setChannel:channel];
    [registrar addMethodCallDelegate:WxpayPlugin.defaultService channel:channel];
}


- (void)setChannel:(FlutterMethodChannel *)channel {
    _channel = channel;
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([@"wxpay" isEqualToString:call.method]) {
        NSString* universalLink = [call.arguments objectForKey:@"universalLink"];
        NSString* paymentString = [call.arguments objectForKey:@"paymentString"];
        NSData* jsonData = [paymentString dataUsingEncoding:NSUTF8StringEncoding];
        NSError* error = nil;
        NSDictionary* payInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        
        NSString* appid = [payInfo objectForKey:@"appid"];
        NSString* timestamp = [payInfo objectForKey:@"timestamp"];
        NSString* noncestr = [payInfo objectForKey:@"noncestr"];
        NSString* package = [payInfo objectForKey:@"package"];
        NSString* partnerid = [payInfo objectForKey:@"partnerid"];
        NSString* prepayid = [payInfo objectForKey:@"prepayid"];
        NSString* sign = [payInfo objectForKey:@"sign"];
        
        [WXApi registerApp:appid universalLink:universalLink];
        
        PayReq* request = [[PayReq alloc] init];
        request.partnerId = partnerid;
        request.prepayId = prepayid;
        request.package = package;
        request.nonceStr = noncestr;
        request.timeStamp = [timestamp intValue];
        request.sign = sign;
        [WXApi sendReq:request completion:^(BOOL success) {
            NSLog(@"sendReq to WeChat");
        }];
    } else {
        result(FlutterMethodNotImplemented);
    }
}

#pragma mark - AppDelegate

- (BOOL)application:(UIApplication *)application
      handleOpenURL:(NSURL *)url {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:
(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application
continueUserActivity:(NSUserActivity *)userActivity
 restorationHandler:(void (^)(NSArray *_Nonnull))restorationHandler {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}

- (BOOL)application:(UIApplication *)application
   openUserActivity:(NSUserActivity *)userActivity {
    return [WXApi handleOpenUniversalLink:userActivity delegate:self];
}


#pragma mark - WXApiDelegate

- (void)onResp:(BaseResp *)resp{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:[NSNumber numberWithInt:resp.errCode]
                  forKey:@"errorCode"];
    if (resp.errStr != nil) {
        [dictionary setValue:resp.errStr forKey:@"errorMsg"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        if (resp.errCode == WXSuccess) {
            PayResp* response = (PayResp*)resp;
            [dictionary setValue:response.returnKey forKey:@"returnKey"];
        }
    }

    [_channel invokeMethod:@"onResp" arguments:dictionary];
    
    for(NSString* key in [dictionary allKeys]){
        NSLog(@"pay result: %@ %@", key, [dictionary objectForKey:key]);
    }
}

@end
