//
//  RongPushHelper.h
//  MYCS
//
//  Created by wzyswork on 16/3/24.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RongPushHelper : NSObject

+ (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

///获取devicetoken时调用
+ (void)registerDeviceToken:(NSData *)deviceToken;

///完全接收到通知时调用，iOS7以后才有completion，否则传nil
+ (void)handleRemoteNotifications:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion;


@end
