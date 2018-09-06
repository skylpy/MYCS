//
//  AppDelegate.m
//  MYCS
//
//  Created by AdminZhiHua on 15/12/28.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "AppDelegate.h"
#import <RongIMKit/RongIMKit.h>
#import "FriendModel.h"
#import "ConstKeys.h"
#import "iRate.h"
#import "JPushHelper.h"
#import "UMengHelper.h"
#import "PortratNaviController.h"
#import "UIAlertView+Block.h"
#import "DataCacheTool.h"
#import "RongPushHelper.h"
#import "SDImageCache.h"
#import "NewMessagesTool.h"
#import <UserNotifications/UserNotifications.h>

#import <AudioToolbox/AudioToolbox.h>

@interface AppDelegate () <RCIMUserInfoDataSource,RCIMReceiveMessageDelegate,JPUSHRegisterDelegate>

@end

@implementation AppDelegate
singleton_implementation(AppDelegate)

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    //设置本地最大缓存的大小
    imageCache.maxCacheSize = 1024 * 1024 *100;
    
    [self configStatusBar];
    //设置评分提示
    [self settingiRate];

    //其他通知配置
    [RongPushHelper application:application didFinishLaunchingWithOptions:launchOptions];
    //极光推送配置
    if (iS_IOS10)
    {
        JPUSHRegisterEntity * entity  = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
        // Required
        [JPUSHService setupWithOption:launchOptions appKey:@"aee4b30c43335282abfb6ec9" channel:@"Publish channel" apsForProduction:NO];
        
        
    }else
    {
        [JPushHelper setupWithOptions:launchOptions];
    }

    //友盟统计
    [UMAnalyticsHelper UMAnalyticStart];

    [self showNewFeature];

    [self configureRCIM];

    [self.window makeKeyAndVisible];

    //本地聊天消息通知
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(didReceiveMessageNotifications:)
               name:RCKitDispatchMessageNotification
             object:nil];

    return YES;
}

- (void)configStatusBar {
    //设置状态栏高亮
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

#pragma mark - NewFeature
- (void)showNewFeature {
    //系统版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    //本地版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];

    //有新版本
    if (![currentVersion isEqualToString:lastVersion])
    {
        [AppManager sharedManager].isFirstInstall = YES;
        
        UIStoryboard *newFeatueSb = [UIStoryboard storyboardWithName:@"NewFeature" bundle:nil];

        UIViewController *newFeatureVC = [newFeatueSb instantiateInitialViewController];

        self.window.rootViewController = newFeatureVC;
    }
}

#pragma mark - RongIM
- (void)configureRCIM {
    [[AppManager sharedManager] startMonitorReachability];

    //开启监控网络状况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusChange:) name:@"kReachabilityStatusChange" object:nil];

    //登录成功自动连接融云服务器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectIMServer) name:LoginSuccess object:nil];
    //退出登录，取消连接融云服务器
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logOutIMServer) name:LOGINOUT object:nil];

    //融云开发环境appKey
    //    NSString * RCAppKey = @"c9kqb3rdkur6j";

    //融云生产环境appKey
    NSString *RCAppKey = @"6tnym1brnabh7";

    [[RCIM sharedRCIM] initWithAppKey:RCAppKey];
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
}

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion {
    FriendModel *model = [DataCacheTool getFriendDataWithfriendId:userId];
    RCUserInfo *user   = [[RCUserInfo alloc] init];
    if (model)
    {
        user.userId      = model.friendId;
        user.name        = model.name;
        user.portraitUri = model.pic_url;
        completion(user);

        return;
    }

    [FriendModel searchFriendWithKeyword:userId Searchtype:@"fanId" Success:^(NSMutableArray *list) {
        FriendModel *model = list[0];
        user.userId        = model.friendId;
        user.name          = model.name;
        user.portraitUri   = model.pic_url;
        completion(user);

    }
        Failure:^(NSError *error) {
            completion(nil);
        }];
}

- (void)connectIMServer {
    [FriendModel getTokenSuccess:^(NSString *token) {

        [[RCIM sharedRCIM] connectWithToken:token success:^(NSString *userId) {

            NSLog(@"登陆成功。当前登录的用户ID：%@", userId);

            [[NSNotificationCenter defaultCenter] postNotificationName:ConnectIMSeverSuccess object:nil];

        }
            error:^(RCConnectErrorCode status) {


            }
            tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            }];
    }
        Failure:^(NSError *error){

        }];
}
-(void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left
{
    if ([AppManager hasLogin])
    {
        //监听未读消息
        [[NewMessagesTool sharedNewMessagesTool] startCheck];
    }
}

- (void)reachabilityStatusChange:(NSNotification *)noti {
    AFNetworkReachabilityStatus status = [noti.object intValue];

    //网络的情况下自动连接融云服务器
    if (status != AFNetworkReachabilityStatusUnknown && status != AFNetworkReachabilityStatusNotReachable)
    {
        if ([AppManager hasLogin]) [self connectIMServer];
    }
}

- (void)logOutIMServer {
    [[RCIM sharedRCIM] logout];
}

#pragma mark - iRate
- (void)settingiRate {
    [iRate sharedInstance].onlyPromptIfLatestVersion = NO;
    //enable preview mode
    [iRate sharedInstance].previewMode = NO;
}

- (BOOL)iRateShouldPromptForRating {
    if (!self.alertView)
    {
        self.alertView = [[UIAlertView alloc] initWithTitle:@"名医传世" message:@"送人玫瑰，手留余香，您的好评是我们前进的动力，么么哒^_^" delegate:self cancelButtonTitle:@"残忍拒绝" otherButtonTitles:@"赏你好评", nil];

        [self.alertView show];
    }

    return NO;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == alertView.cancelButtonIndex)
    {
        //ignore this version
        [iRate sharedInstance].declinedThisVersion = YES;
    }
    else if (buttonIndex == 1) // rate now
    {
        //mark as rated
        [iRate sharedInstance].ratedThisVersion = YES;
        //launch app store
        [[iRate sharedInstance] openRatingsPageInAppStore];
    }

    self.alertView = nil;
}

#pragma mark - JPush
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPushHelper registerDeviceToken:deviceToken];

    [RongPushHelper registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (userInfo[@"rc"])
    {
        [RongPushHelper handleRemoteNotifications:userInfo completion:nil];
    }
    else
    {
        [JPushHelper handleRemoteNotification:userInfo completion:nil];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (userInfo[@"rc"])
    {
        [RongPushHelper handleRemoteNotifications:userInfo completion:completionHandler];
    }
    else
    {
        [JPushHelper handleRemoteNotification:userInfo completion:completionHandler];
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSDictionary *userDic = notification.userInfo;

    if (userDic[@"rc"])
    {
        [RongPushHelper handleRemoteNotifications:userDic completion:nil];
    }
}
#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler
{
    AudioServicesPlaySystemSound(1007);
    // Required
//    NSDictionary * userInfo = notification.request.content.userInfo;
//    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
//    {
////        [JPushHelper handleRemoteNotification:userInfo completion:nil];
//    }
    completionHandler(UNNotificationPresentationOptionAlert); // Badge Sound Alert
}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler
{
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]])
    {
        if (userInfo[@"rc"])
        {
            [RongPushHelper handleRemoteNotifications:userInfo completion:nil];
        }else
        {
            
            [JPushHelper handleRemoteNotificationWithIOS10:userInfo completion:nil];
        }
        
    }else
    {
        if (userInfo[@"rc"])
        {
            [RongPushHelper handleRemoteNotifications:userInfo completion:nil];
        }
    }
    completionHandler();
}

//注册用户通知设置
- (void)application:(UIApplication *)application
    didRegisterUserNotificationSettings:
        (UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
    
}
//本地聊天消息通知
- (void)didReceiveMessageNotifications:(NSNotification *)notification {
    RCMessage *message = notification.object;

    if (message.messageDirection == MessageDirection_RECEIVE)
    {
        [UIApplication sharedApplication].applicationIconBadgeNumber += 1;
        //        [JPUSHService setBadge:[UIApplication sharedApplication].applicationIconBadgeNumber];
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    application.applicationIconBadgeNumber = 0;

    [JPushHelper clearBadge];
}

#pragma mark - UMengShare
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    [UMengHelper handleOpenURL:url];

    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    [UMengHelper handleOpenURL:url];

    return YES;
}

#pragma mark - getter and setter
- (UINavigationController *)rootNavi {
    if (!_rootNavi)
    {
        UIViewController *rootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
        if ([rootVC isKindOfClass:[PortratNaviController class]])
        {
            _rootNavi = (UINavigationController *)rootVC;
        }
    }
    return _rootNavi;
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter]
        removeObserver:self
                  name:RCKitDispatchMessageNotification
                object:nil];
}
@end
