//
//  JPushHelper.m
//  MYCS
//
//  Created by AdminZhiHua on 15/10/30.
//  Copyright © 2015年 GuoChenghao. All rights reserved.
//

#import "JPushHelper.h"
#import "PushControllerView.h"

@interface JPushHelper ()<UIAlertViewDelegate>

@end

@implementation JPushHelper

+ (void)setupWithOptions:(NSDictionary *)launchOptions {

    // Required
    if (iS_IOS8LATER)
    {
        NSUInteger notiType = UIUserNotificationTypeBadge |UIUserNotificationTypeSound|UIUserNotificationTypeAlert;
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:notiType
                                              categories:nil];
    }
    else
    {
        NSUInteger notiType = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert;
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:notiType
                                              categories:nil];
    }
    
    // Required
    [JPUSHService setupWithOption:launchOptions appKey:@"aee4b30c43335282abfb6ec9" channel:@"Publish channel" apsForProduction:NO];
    
    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (remoteNotif && !remoteNotif[@"rc"])//不是融云的推送
    {
        [self handleRemoteNotification:remoteNotif completion:nil];
    }
    
    [JPUSHService removeNotification:nil];
    return;
}

+ (void)registerDeviceToken:(NSData *)deviceToken {
    
    [JPUSHService registerDeviceToken:deviceToken];

    [JPUSHService setAlias:[AppManager sharedManager].user.uid callbackSelector:nil object:nil];
}

+ (void)handleRemoteNotification:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion {
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    if (completion)
    {
        // IOS 7 Support Required
        completion(UIBackgroundFetchResultNewData);
    }
    
    UIApplication * application = [UIApplication sharedApplication];
    if (application.applicationState != UIApplicationStateActive)
    {
        [PushControllerView showDetailCotrollerViewInForegroundWithUserInfo:userInfo];
    }
    else
    {
       [PushControllerView showDetailCotrollerViewInBackgroundWithUserInfo:userInfo];
    }
}
+ (void)handleRemoteNotificationWithIOS10:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion {
    
    [JPUSHService handleRemoteNotification:userInfo];
    
    if (completion)
    {
        // IOS 7 Support Required
        completion(UIBackgroundFetchResultNewData);
    }
    [PushControllerView showDetailCotrollerViewInForegroundWithUserInfo:userInfo];
    
}
+ (void)setTag:(NSString *)tag alias:(NSString *)alias{
    if(tag){
        NSSet* tags = [NSSet setWithObject:tag];
        [JPUSHService setTags:tags alias:alias callbackSelector:nil object:nil];
    }else{
        [JPUSHService setAlias:alias callbackSelector:nil object:nil];
    }
}

+ (void)clearTagAndAlias{
    [JPUSHService setTags:[NSSet setWithObject:@"NULL"] alias:@"NULL" callbackSelector:nil object:nil];
}

+ (void)clearBadge {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService setBadge:0];
    
}


@end
