//
//  SettingViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SettingViewController.h"
#import "ConstKeys.h"
#import "JPushHelper.h"
#import "DataCacheTool.h"
#import "VideoCacheDownloadManager.h"
#import "UIAlertView+Block.h"
#import "SDImageCache.h"
#import <UserNotifications/UserNotifications.h>
@interface SettingViewController ()

@property (weak, nonatomic) IBOutlet UILabel *cacheSizeLabel;

@property (weak, nonatomic) IBOutlet UISwitch *msgNotiSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *downloadImageSwithch;
@property (weak, nonatomic) IBOutlet UISwitch *playVideoSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *autoCacheSwitch;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"设置";
    
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:247.0/255.0 green:247.0/255.0 blue:247.0/255.0 alpha:1];
    
    //配置设置的开关
    [self configSetting];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //重新判断推送通知是否开启
    self.msgNotiSwitch.on = [self isAllowedNotification];

}

- (void)configSetting {
    
    self.downloadImageSwithch.on = ![self boolForKey:kWWLANDownImageOff];
    self.playVideoSwitch.on = ![self boolForKey:kWWLANPlayVideoOff];
    self.autoCacheSwitch.on = ![self boolForKey:kWWLANCacheVideoOff];
    
    [self setCacheSize];
}

- (void)setCacheSize {
    //获取缓存的大小
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *sizeStr = [self formatByteCount:[self sizeWithFile:cachePath]];
    self.cacheSizeLabel.text = sizeStr;
}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 1)
    {//清除缓存
        if (indexPath.row == 0) {
            [self showAlert];
        }
        
    }
}

- (void)showAlert {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定清除全部缓存?" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    
    [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex==1)
        {
            [self clearCache];
            [self setCacheSize];
        }
        
    }];
    
}

#pragma mark - Private

- (void)clearCache {
    
    [[SDImageCache sharedImageCache] clearMemory];
    [[SDImageCache sharedImageCache] cleanDisk];
    [DataCacheTool clearAllTableRecord];
    [VideoCacheDownloadManager clearAllTableRecord];
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    [self removeFile:cachePath];
    
}

//判断用户是否开启推送通知
- (BOOL)isAllowedNotification
{
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
            }else
            {
                [AppManager sharedManager].canNotification = NO;
            }
        }];
        return [AppManager sharedManager].canNotification;
        
    }else
    {
        if (iS_IOS8LATER)
        {// system is iOS8
            UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
            
            if (UIUserNotificationTypeNone != setting.types)
            {
                return YES;
            }
            
        }
        else
        {//iOS7
            UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
            
            if(UIRemoteNotificationTypeNone != type)
                
                return YES;
        }
    }
    return NO;
}

#pragma mark - Action
- (IBAction)switchAction:(UISwitch *)sender {
    
    if (sender.tag == 0)//消息提醒
    {
        [self setNotificationWith:sender.on];
    }
    else if (sender.tag == 1)//非WIFI环境下下载图片
    {
        [self setBoolforkey:kWWLANDownImageOff];
        [AppManager sharedManager].WWLANDownImageOff = !sender.on;
    }
    else if (sender.tag == 2)//非WIFI环境下播放视频
    {
        [self setBoolforkey:kWWLANPlayVideoOff];
        [AppManager sharedManager].WWLANPlayVideoOff = !sender.on;
    }
    else if (sender.tag == 3)//WIFI环境下自动缓存视频
    {
        [self setBoolforkey:kWWLANCacheVideoOff];
    }

}

- (void)setBoolforkey:(NSString *)key {
    
    BOOL on = [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
    [[NSUserDefaults standardUserDefaults] setBool:!on forKey:key];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//根据Key获取BOOL值
- (BOOL)boolForKey:(NSString *)key {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
}

- (void)setNotificationWith:(BOOL)on {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    
//    NSURL *url = [NSURL URLWithString:@"prefs:root=NOTIFICATIONS_ID"];
//    [[UIApplication sharedApplication] openURL:url];

}

/**
 *  计算文件或者文件的大小
 *
 *  @param filePath 文件路劲
 *
 *  @return 文件的大小
 */
- (CGFloat)sizeWithFile:(NSString *)filePath
{
    CGFloat totalSize = 0;
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL isDirectory;
    BOOL isExists = [mgr fileExistsAtPath:filePath isDirectory:&isDirectory];
    if (isExists) {
        
        if (isDirectory) {
            
            NSArray *subPaths =  [mgr subpathsAtPath:filePath];
            
            for (NSString *subPath in subPaths) {
                NSString *fullPath = [filePath stringByAppendingPathComponent:subPath];
                
                BOOL isDirectory;
                [mgr fileExistsAtPath:fullPath isDirectory:&isDirectory];
                
                if (!isDirectory) { // 计算文件尺寸
                    NSDictionary *dict =  [mgr attributesOfItemAtPath:fullPath error:nil];
                    
                    totalSize += [dict[NSFileSize] floatValue];;
                }
            }
            
            
        }else{
            
            NSDictionary *dict =  [mgr attributesOfItemAtPath:filePath error:nil];
            totalSize =  [dict[NSFileSize] floatValue];
            
        }
        
    }
    return totalSize;
}


/**
 *  遍历文件夹下的所有文件并删除
 *
 *  @param filePath 文件路劲
 */
- (void)removeFile:(NSString *)filePath
{
    
    BOOL isDirectory;
    BOOL isExits = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    if (isExits) {
        
        if (isDirectory) {
            
            NSArray *contentFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
            
            for (NSString *subFile in contentFiles) {
                
                NSString *file = [filePath stringByAppendingPathComponent:subFile];
                
                [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
            }
            
        }else{
            
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            
        }
        
    }
    
    return;
    
}

//容量格式化输出
- (NSString *)formatByteCount:(long long)size
{
    return [NSByteCountFormatter stringFromByteCount:size countStyle:NSByteCountFormatterCountStyleFile];
}

@end
