//
//  MainTabBarController.m
//  MYCS
//
//  Created by AdminZhiHua on 15/12/28.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "MainTabBarController.h"
#import "Animating.h"
#import "UserCenterModel.h"
#import "SDWebImageManager.h"
#import "DeviceInfoTool.h"
#import "VideoCacheDownloadManager.h"
#import "NewMessagesTool.h"
#import "UpdateModel.h"
#import "UIAlertView+Block.h"
#import "UpdateAppAlertView.h"
#import "DataCacheTool.h"
#import "ProfileView.h"

@interface MainTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, strong) UITabBarItem *messageItem;
@property (nonatomic, strong) UITabBarItem *profileItem;

@end

@implementation MainTabBarController

#pragma mark - *** 类的创建init ***
+ (void)load {
    [[UITabBar appearance] setTintColor:HEXRGB(0x47c1a9)];
}

#pragma mark - *** UIView的生命周期 ***
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = YES;
    
    [[AppDelegate sharedAppDelegate].rootNavi class];
    
    [AppDelegate sharedAppDelegate].mainTabBarController = self;
    
    self.delegate = self;
    
    //显示广告
    [self showADView];
    
    //监听未读消息
    [[NewMessagesTool sharedNewMessagesTool] startCheck];
    
    [self installNotitications];
}

#pragma mark - 注册&移除通知
- (void)installNotitications {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkMsgItemCount:) name:MESSAGENOTI object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkProfileItemCount:) name:PROFILENOTI object:nil];
}

- (void)removeNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MESSAGENOTI object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PROFILENOTI object:nil];
}

//点击启动图片响应
-(void)pushControllerView:(UIButton *)button
{
    [UMAnalyticsHelper eventLogClick:@"event_start_page_banner"];
    Param * param = [DataCacheTool getAdpictureModel];
    [ProfileView profileWtihParam:param];
    [button removeFromSuperview];
}

#pragma mark - *** Action ***
//显示广告View
- (void)showADView {
    //新版本时不显示广告图页面
    if ([self hasNewFeature]) return;
    
    NSString *imageURL = [DataCacheTool getAdpictureAdImageURL];
    
    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:imageURL];
    
    if (!image)
    {
        image = [self LaunchImage];
    }
    //创建imageview
    
    UIButton * adView = [UIButton buttonWithType:UIButtonTypeCustom];
    adView.frame = [UIScreen mainScreen].bounds;
    adView.userInteractionEnabled = [DataCacheTool getAdpictureModel]?YES:NO;
    [adView setBackgroundImage:image forState:UIControlStateNormal];
    [adView addTarget:self action:@selector(pushControllerView:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:adView];
    
    
    //停留等待
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //消失的动画
        [UIView animateWithDuration:2.0f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            
            adView.alpha           = 0.0f;
            adView.layer.transform = CATransform3DScale(CATransform3DIdentity, 1.2, 1.2, 1);
            
        } completion:^(BOOL finished) {
            [self checkVersion];//版本更新提示
            [adView removeFromSuperview];
            
            //重新请求获取广告图
            [ProfileFocus loadAdPic];
        }];
        
    });

}

-(void)checkVersion
{
    [UpdateModel checkUpdateInServerSuccess:^(UpdateModel *model) {
        
        if ([model.match isEqualToString:@"min"])
        {
            if (model.force.integerValue == 0)
            {
                [[[UpdateAppAlertView alloc] initWithTitle:@"版本提示" message:@"检测到新版本"cancelButtonTitle:@"取消" otherButtonTitle:@"更新"] showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 1)
                    {
                        NSURL *iTunesURL = [NSURL URLWithString:model.url];
                        [[UIApplication sharedApplication] openURL:iTunesURL];
                    }
                    
                }];
            }
            else
            {
                [[[UpdateAppAlertView alloc] initWithTitle:@"版本提示" message:@"检测到新版本"cancelButtonTitle:nil otherButtonTitle:@"更新"] showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    
                    if (buttonIndex == 0)
                    {
                        NSURL *iTunesURL = [NSURL URLWithString:model.url];
                        [[UIApplication sharedApplication] openURL:iTunesURL];
                    }
                    
                }];
            }
        }
        
    } failure:^(NSError *error) {
        
    }];
}

///  获取启动图片
- (UIImage *)LaunchImage {
    CGSize viewSize           = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";
    NSString *launchImage     = nil;
    
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    
    for (NSDictionary *dict in imagesDict)
    {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        
        if (CGSizeEqualToSize(imageSize, viewSize) && [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]])
        {
            launchImage = dict[@"UILaunchImageName"];
        }
    }
    
    return [UIImage imageNamed:launchImage];
}


- (BOOL)hasNewFeature {
    //系统版本号
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
    //本地版本号
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"version"];
    
    //首次安装
    if (!lastVersion)
    {
        //收集激活信息
        [DeviceInfoTool postActiveInfo];
    }
    
    //有新版本
    if (![currentVersion isEqualToString:lastVersion])
    {
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"version"];
        return YES;
    }
    
    return NO;
}

#pragma mark - 未读消息的通知
- (void)checkMsgItemCount:(NSNotification *)noti {
    NewMsgCountModel *model = noti.object;
    
    [self setBadgeValueWith:self.messageItem newMsgCountModel:model];
}

- (void)checkProfileItemCount:(NSNotification *)noti {
    NewMsgCountModel *model = noti.object;
    
    [self setBadgeValueWith:self.profileItem newMsgCountModel:model];
}

//给UITabBarItem设置badgeValue
- (void)setBadgeValueWith:(UITabBarItem *)barItem newMsgCountModel:(NewMsgCountModel *)model {
    if (!model || ![AppManager hasLogin])
    {
        barItem.badgeValue = nil;
        return;
    }
    
    int totalCount;
    if (model.msgCount || model.taskCount)
    {
        totalCount = [model.msgCount intValue] + [model.taskCount intValue];
    }
    else
    {
        totalCount = [model.unreadCount intValue] + [model.evaluationCount intValue];
    }
    
    
    NSString *badgeValue;
    
    if (totalCount == 0)
    {
        badgeValue = nil;
    }
    else if (totalCount > 99)
    {
        badgeValue = [NSString stringWithFormat:@"99+"];
    }
    else
    {
        badgeValue = [NSString stringWithFormat:@"%d", totalCount];
    }
    
    barItem.badgeValue = badgeValue;
}

#pragma mark - *** 代理 *** 没登录状态下选择“消息”和“我的”弹出登录界面

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    UITabBarItem *item = [self.tabBar selectedItem];
    
    if ([item isEqual:self.messageItem])
    {
        BOOL hasLogin = [AppManager checkLogin];
        
        if (hasLogin)
        {
            //点击的时候清空BadgeValue
//            [self setBadgeValueWith:self.messageItem newMsgCountModel:nil];
        }
        
        return hasLogin;
    }
//    else if ([item isEqual:self.profileItem])
//    {
//        BOOL hasLogin = [AppManager checkLogin];
//        
//        if (hasLogin)
//        {
//            //点击的时候清空BadgeValue
////            [self setBadgeValueWith:self.profileItem newMsgCountModel:nil];
//        }
//        
//        return hasLogin;
//    }
    
    return YES;
}

- (void)dealloc {
    [self removeNotifications];
}

#pragma mark - *** 懒加载 ***
- (UITabBarItem *)messageItem {
    if (!_messageItem)
    {
        for (UITabBarItem *item in self.tabBar.items)
        {
            if ([item.title isEqualToString:@"消息"])
            {
                _messageItem = item;
            }
        }
    }
    return _messageItem;
}

- (UITabBarItem *)profileItem {
    if (!_profileItem)
    {
        for (UITabBarItem *item in self.tabBar.items)
        {
            if ([item.title isEqualToString:@"我的"])
            {
                _profileItem = item;
            }
        }
    }
    return _profileItem;
}

@end
