//
//  RongPushHelper.m
//  MYCS
//
//  Created by wzyswork on 16/3/24.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "RongPushHelper.h"
#import <RongIMKit/RongIMKit.h>
#import "FriendModel.h"
#import "AppDelegate.h"
#import "AppManager.h"
#import "FriendChatViewController.h"
#import "DataCacheTool.h"
#import <UserNotifications/UserNotifications.h>

@implementation RongPushHelper

+ (void)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if (iS_IOS10)
    {
        //iOS 10
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
            }
        }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.authorizationStatus == UNAuthorizationStatusAuthorized) {
                [AppManager sharedManager].canNotification = YES;
            }
        }];
        
    }else
    {
        
        if ([application
             respondsToSelector:@selector(registerUserNotificationSettings:)])
        {
            //注册推送, 用于iOS8以及iOS8之后的系统
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert) categories:nil];
            
            [application registerUserNotificationSettings:settings];
        }
        else
        {
            //注册推送，用于iOS8之前的系统
            UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |UIRemoteNotificationTypeAlert |UIRemoteNotificationTypeSound;
            
            [application registerForRemoteNotificationTypes:myTypes];
        }
    }
    
    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    
    if (remoteNotif[@"rc"])
    {
        [self handleRemoteNotifications:remoteNotif completion:nil];
    }

}


+(void)registerDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]stringByReplacingOccurrencesOfString:@">" withString:@""]
                       stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
    
}

+(void)handleRemoteNotifications:(NSDictionary *)userInfo completion:(void (^)(UIBackgroundFetchResult))completion
{
    
    if (![AppManager hasLogin])
    {
        return;
    }
    if (completion)
    {
        // IOS 7 Support Required
        completion(UIBackgroundFetchResultNewData);
    }
    
    UIApplication * application = [UIApplication sharedApplication];
    if (application.applicationState != UIApplicationStateActive)
    {
        UIViewController * vc = [[AppDelegate sharedAppDelegate].rootNavi.childViewControllers lastObject];
        
        [vc dismissLoadingHUD];
        
        [vc dismissViewControllerAnimated:NO completion:nil];
        [vc.navigationController popToRootViewControllerAnimated:NO];
        
        //跳转到消息界面
        [AppDelegate sharedAppDelegate].mainTabBarController.selectedIndex = 2;
        
    }
    
    
}
@end






