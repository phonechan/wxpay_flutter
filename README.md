# wxpay

A flutter plugin for make payment with WeChat ( Android & iOS )

## iOS 配置

> 1、配置 URLTypes

info.plist
```
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLName</key>
        <string>weixin</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>wx0d48a98252a2fe7a</string> # 替换成你自己的 appid
        </array>
    </dict>
</array>

<key>LSApplicationQueriesSchemes</key>
<array>
    <string>weixin</string>
    <string>weixinULAPI</string>
</array>
```


> 2、微信 OpenSDK 相关配置

a> Objective-C 版本

AppDelegate.m
```
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:
(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    if ([url.host isEqualToString:@"pay"]) {
        return [WxpayPlugin.defaultService application:application
                                           openURL:url
                                           options:options];
    }
}
```

b> Swift 版本

Runner-Bridging-Header.h
```
#import <WxpayPlugin.h>
#import <UIKit/UIKit.h>
```

AppDelegate.swift
```
override func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool{
        if url.host == "pay" {
            WxpayPlugin.defaultService().application(app, open: url, options: options);
        }
        return true;
    }
```

参考链接：

1、https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=8_5

## Android 配置



