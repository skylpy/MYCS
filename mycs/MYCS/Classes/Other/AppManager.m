//
//  AppManager.m
//  SWWY
//
//  Created by GuoChenghao on 15/1/8.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "AppManager.h"
#import "ConstKeys.h"
#import "JPushHelper.h"
#import "AppDelegate.h"
#import "SDImageCache.h"
#import "ConstKeys.h"
#import "NewMessagesTool.h"
#import "VideoCacheDownloadManager.h"

@interface AppManager ()

@property (nonatomic,strong) AFNetworkReachabilityManager *reachabilityManager;

@end

@implementation AppManager

+ (instancetype)sharedManager {
    static AppManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AppManager alloc] initManager];
    });
    return sharedManager;
}

- (id)initManager
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.WWLANDownImageOff = [self boolForKey:kWWLANDownImageOff];
        self.WWLANPlayVideoOff = [self boolForKey:kWWLANPlayVideoOff];
    }
    return self;
}

//根据Key获取BOOL值
- (BOOL)boolForKey:(NSString *)key {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
}


///检查是否更新
+ (BOOL)isNewUpdate {
    
    ///当前版本
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    double currentVersion = [infoDict[@"CFBundleShortVersionString"] doubleValue];
    
    ///沙盒版本
    NSString *kSandBoxVersion = @"kSandBoxVersion";
    double localVersion = [[NSUserDefaults standardUserDefaults] doubleForKey:kSandBoxVersion];
    
    ///将当前版本同步到沙盒中
    [[NSUserDefaults standardUserDefaults] setObject:@(currentVersion) forKey:kSandBoxVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return currentVersion>localVersion;
    
}

///归档用户信息
+ (void)saveUserCount:(User *)user {
    
    ///给极光推送设置tag和别名
    [JPushHelper setTag:user.envTag alias:user.uid];

    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"UserAccount.data"];
    
    [NSKeyedArchiver archiveRootObject:user toFile:filePath];
    
    [AppManager sharedManager].user = user;
    
    //开始监听未读消息数
    [[NewMessagesTool sharedNewMessagesTool] startCheck];
    
    [AppManager sharedManager].isKickOut = NO;
}

///判断用户是否登陆过
+ (BOOL)hasLogin {
    
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString *filePath = [docPath stringByAppendingPathComponent:@"UserAccount.data"];
    
    User *user = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    
    [AppManager sharedManager].user = user;
    
    return user?YES:NO;
}

///退出登录
+ (void)loginOut {
    
    //取消当前下载
    [VideoCacheDownloadManager cancelCurrentDownload];
    
    NSString *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [docPath stringByAppendingPathComponent:@"UserAccount.data"];
    
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
    
      NSString *key = [NSString stringWithFormat:@"%@?imageView2/0/w/%d/h/%d/format/jpg/q/100",[AppManager sharedManager].userCenterModel.topPic,(int)ScreenW*2,(int)ScreenW / 2 * 2];
      NSString *key1 = [NSString stringWithFormat:@"%@?imageView2/0/w/%d/h/%d/format/jpg/q/100",[AppManager sharedManager].user.userPic,60*2,60* 2];
    
    [[SDImageCache sharedImageCache] removeImageForKey:key];
    [[SDImageCache sharedImageCache] removeImageForKey:key1];
    
    [AppManager sharedManager].user = nil;
    
    [AppManager sharedManager].userCenterModel = nil;
    
    [AppManager sharedManager].selectQuit = YES;
    
    ///取消极光的tag和别名设置
    [JPushHelper clearTagAndAlias];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LOGINOUT object:nil];
    
    //停止监听未读消息
    [[NewMessagesTool sharedNewMessagesTool] stopChecking];
}

///检查用户是否登陆，没有登陆则弹出登陆界面
+ (BOOL)checkLogin {
    
    BOOL hasLogin = [AppManager hasLogin];
    
    if (!hasLogin) {
        
        UINavigationController *rootNav = [AppDelegate sharedAppDelegate].rootNavi;
        
        UIStoryboard *loginSB = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
        UIViewController *loginVC = [loginSB instantiateInitialViewController];
        
        [rootNav presentViewController:loginVC animated:YES completion:nil];
        
    }
    
    return hasLogin;
    
}

- (void)startMonitorReachability {
    
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    self.reachabilityManager = manager;
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        self.status = status;
        
        NSNotificationCenter *notiCenter = [NSNotificationCenter defaultCenter];
        
        [notiCenter postNotificationName:@"kReachabilityStatusChange" object:@(status)];
        
    }];
    
    [manager startMonitoring];
    
}

- (void)stopMonitorReachability {
    
    [self.reachabilityManager stopMonitoring];
    
    self.reachabilityManager = nil;
}

-(void)setSelectQuit:(BOOL)selectQuit
{
    _selectQuit = selectQuit;
}
@end
