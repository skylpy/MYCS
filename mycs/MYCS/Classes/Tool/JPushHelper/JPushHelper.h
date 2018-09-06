//
//  JPushHelper.h
//  MYCS
//
//  Created by AdminZhiHua on 15/10/30.
//  Copyright © 2015年 GuoChenghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPUSHService.h"

///极光推送相关API封装
@interface JPushHelper : NSObject

///启动的时候调用
+ (void)setupWithOptions:(NSDictionary *)launchOptions;

///获取devicetoken时调用
+ (void)registerDeviceToken:(NSData *)deviceToken;

///完全接收到通知时调用，iOS7以后才有completion，否则传nil
+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion;
//iOS10
+ (void)handleRemoteNotificationWithIOS10:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion;
///设置tag和别名
+ (void)setTag:(NSString *)tags alias:(NSString *)alias;

///清除tag和别名
+ (void)clearTagAndAlias;

///清空badge
+ (void)clearBadge;

@end
