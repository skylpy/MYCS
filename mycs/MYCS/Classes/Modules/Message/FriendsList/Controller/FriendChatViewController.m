//
//  FriendChatViewController.m
//  MYCS
//  聊天界面（继承融云界面）
//  Created by Yell on 16/1/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "FriendChatViewController.h"
#import "PersonalInformationViewController.h"
#import "IQKeyboardManager.h"
#import "RefreshUserInfoRCIM.h"

@interface FriendChatViewController ()

@end

@implementation FriendChatViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.tabBarController.tabBar.hidden = YES;
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = NO;
    manager.enable = NO;
    
    //刷新好友信息
    [RefreshUserInfoRCIM refreshUserInfoCacheUserID:self.model.friendId];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = YES;
    manager.enable = YES;
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.title = self.model.name;
    [self.navigationController setNavigationBarHidden:NO];
    self.enableUnreadMessageIcon = YES;
    self.enableNewComingMessageIcon = YES;
    
    //刷新好友信息
    [RefreshUserInfoRCIM refreshUserInfoCacheUserID:self.model.friendId];
    //刷新融云聊天的自己头像
    [RefreshUserInfoRCIM refreshUserInfoCacheUserID:[AppManager sharedManager].user.uid];
    //帐号登录异常通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountLoginError) name:ACCOUNTLOGINERROR object:nil];
}

-(void)accountLoginError
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ACCOUNTLOGINERROR object:nil];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didTapCellPortrait:(NSString *)userId
{
    if ([userId isEqualToString:[AppManager sharedManager].user.uid])return;
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"FriendsList" bundle:nil];
    PersonalInformationViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"PersonalInformationViewController"];
    controller.isComeFromChatView = YES;
    controller.model = self.model;
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
    
}

@end
