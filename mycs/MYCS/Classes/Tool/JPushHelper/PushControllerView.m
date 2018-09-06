//
//  PushControllerView.m
//  MYCS
//
//  Created by wzyswork on 16/1/25.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "PushControllerView.h"

#import "TrainCourseDetailController.h"
#import "TrainSopDetailController.h"
#import "WebViewDetailController.h"
#import "VCSDetailViewController.h"
#import "MailBoxDetailViewController.h"
#import "NewFriendListViewController.h"
#import "FriendsListViewController.h"
#import "EvaluationListViewController.h"
#import "ActivityDetailController.h"
#import "ClassDetailViewController.h"

#import "UIAlertView+Block.h"
#import "PushModel.h"
#import "PushBarView.h"
#import "JPushHelper.h"
#import "OnLiveViewController.h"
#import "LiveNaviViewController.h"
@implementation PushControllerView


//关联数据类型,0--消息，1--普通任务，2--sop任务,3--视频推送，4--教程推送，5--SOP推送，6--资讯推送，7--登录通知推送,8--请求好友,9--接受好友,10--学术交流,11--视频空间 ,12--案例中心，13-业界评价，14 -- 活动推送 ，15 -- 课程推送
//videoLink： 视频地址【数组】(或type为6时的资讯详情页访问链接【字符串】)
//增加返回参数taskResId：当接收到任务推送（type为1或2时），该参数返回课程或SOP的id

+ (void)showDetailCotrollerViewInForegroundWithUserInfo:(NSDictionary *)userInfo {
    int type            = [userInfo[@"type"] intValue];
    NSString *link_id   = userInfo[@"link_id"];
    NSString *taskResId = userInfo[@"taskResId"];
    NSString *newsLinkUrl;
    
    if (type == 6 || type == 14 || type == 15)
    {
        newsLinkUrl = userInfo[@"videoLink"];
    }
    else
    {
        if (type != 3)
        {
            if (![AppManager hasLogin]) return;
        }
    }
    
    if (type == 6)
    { //资讯推送
        
        [self showDetailInformactionCotrollerViewWithLinkUrl:newsLinkUrl];
    }
    else if (type == 3 || type == 4 || type == 5)
    {
        [self showDetailVideoCotrollerViewWithLink:link_id andType:type-2];
    }
    else if (type == 0)
    {
        [self showDetailMailBoxCotrollerViewWithMessageID:link_id];
    }
    else if (type == 1 || type == 2)
    {
        [self showDetailTrainAssessCotrollerViewWithLinkID:link_id andTaskResId:taskResId andType:type];
    }
    else if (type == 7)
    {
        [self showOtherPlaceloginCurrentUserCode];
    }
    else if (type == 8)
    {
        [self showNewFriendCotrollerView];
    }
    else if (type == 9)
    {
        [self showFriendCotrollerView];
    }
    else if (type == 10 || type == 11 || type == 12)
    {
        EvaluationTargetType VcType;
        switch (type)
        {
            case 10:
                VcType = EvaluationTargetTypeExchange;
                break;
            case 11:
                VcType = EvaluationTargetTypeVideo;
                break;
            case 12:
                VcType = EvaluationTargetTypeCase;
                break;
            default:
                break;
        }
        [self showEvaluationListVcWithType:VcType];
    }
    else if (type == 13)
    {
        [self showEvaluationListVcWithType:EvaluationTargetTypeInsiders];
    }else if (type == 14)
    {
        //活动推送
        
        [self showDetailActivityCotrollerViewWithLinkUrl:newsLinkUrl];
        
    }else if (type == 15)
    {
        //课程推送
        [self pushCoursePackDetailWithURL:newsLinkUrl];
        //        [self showDetailVideoCotrollerViewWithLink:link_id andType:VCSDetailTypeCourse];
    }else if (type == 16)
    {
        //直播间推送
        
        [self pushLiveRoom:link_id];
    }
}

+ (void)showDetailCotrollerViewInBackgroundWithUserInfo:(NSDictionary *)userInfo {
    if (iS_IOS10) {
        return;
    }
    int type            = [userInfo[@"type"] intValue];
    NSString *link_id   = userInfo[@"link_id"];
    NSString *taskResId = userInfo[@"taskResId"];
    NSString *newsLinkUrl;
    
    NSString *alertTitle;
    
    if (type == 6)
    {
        alertTitle  = @"名医传世-名医资讯通知";
        newsLinkUrl = userInfo[@"videoLink"];
    }
    else if(type == 14){
        
        alertTitle = @"名医传世-活动通知";
        newsLinkUrl = userInfo[@"videoLink"];
    }else if(type == 15)
    {
        alertTitle = @"名医传世-课程通知";
        newsLinkUrl = userInfo[@"videoLink"];
    }
    else
    {
        if (type != 3)
        {
            if (![AppManager checkLogin]) return;
        }
    }
    
    if (type == 0)
        alertTitle = @"名医传世-邮件通知";
    else if (type == 1)
        alertTitle = @"名医传世-普通任务通知";
    else if (type == 2)
        alertTitle = @"名医传世-SOP任务通知";
    else if (type == 3)
        alertTitle = @"名医传世-视频通知";
    else if (type == 4)
        alertTitle = @"名医传世-教程通知";
    else if (type == 5)
        alertTitle = @"名医传世-SOP通知";
    
    else if (type == 8)
        alertTitle = @"名医传世-请求好友通知";
    else if (type == 9)
        alertTitle = @"名医传世-接受好友通知";
    else if (type == 10)
        alertTitle = @"名医传世-学术交流通知";
    else if (type == 11)
        alertTitle = @"名医传世-视频空间通知";
    else if (type == 12)
        alertTitle = @"名医传世-案例中心通知";
    else if (type == 13)
        alertTitle = @"名医传世-业界评价通知";
    else if (type == 16)
        alertTitle = @"名医传世-直播通知";
    
    
    PushModel *model  = [[PushModel alloc] init];
    model.title       = alertTitle;
    model.type        = type;
    model.link_id     = link_id;
    model.taskResId   = taskResId;
    model.newsLinkUrl = newsLinkUrl;
    model.details     = userInfo[@"aps"][@"alert"];
    
    UIWindow *window        = [UIApplication sharedApplication].keyWindow;
    PushBarView *oldPushBar = [window viewWithTag:979797];
    
    [oldPushBar removeFromSuperview];
    
    PushBarView *pushBar = [[PushBarView alloc] init];
    pushBar.tag          = 979797;
    [window addSubview:pushBar];
    [pushBar showWithModel:model DismissAfter:8];
    [pushBar handleClickAction:^(PushBarView *pushBar, PushModel *model) {
        
        pushBar.userInteractionEnabled = NO;
        [pushBar removeFromSuperview];
        
        if (model.type == 6)
        { //资讯推送
            
            [self showDetailInformactionCotrollerViewWithLinkUrl:model.newsLinkUrl];
        }
        else if (model.type == 3 || model.type == 4 || model.type == 5)
        {
            [self showDetailVideoCotrollerViewWithLink:model.link_id andType:model.type-2];
        }
        else if (model.type == 0)
        {
            [self showDetailMailBoxCotrollerViewWithMessageID:model.link_id];
        }
        else if (model.type == 1 || model.type == 2)
        {
            [self showDetailTrainAssessCotrollerViewWithLinkID:model.link_id andTaskResId:model.taskResId andType:model.type];
        }
        else if (model.type == 8)
        {
            [self showNewFriendCotrollerView];
        }
        else if (model.type == 9)
        {
            [self showFriendCotrollerView];
        }
        else if (model.type == 10 || model.type == 11 || model.type == 12)
        {
            EvaluationTargetType VcType;
            switch (model.type)
            {
                case 10:
                    VcType = EvaluationTargetTypeExchange;
                    break;
                case 11:
                    VcType = EvaluationTargetTypeVideo;
                    break;
                case 12:
                    VcType = EvaluationTargetTypeCase;
                    break;
                default:
                    break;
            }
            [self showEvaluationListVcWithType:VcType];
        }
        else if (model.type == 13)
        {
            [self showEvaluationListVcWithType:EvaluationTargetTypeInsiders];
        }
        else if (type == 14)
        {
            //活动推送
            [self showDetailActivityCotrollerViewWithLinkUrl:newsLinkUrl];
            
        }else if (type == 15)
        {
            //课程推送
            
            [self pushCoursePackDetailWithURL:newsLinkUrl];
            //            [self showDetailVideoCotrollerViewWithLink:link_id andType:VCSDetailTypeCourse];
        }else if (type == 16)
        {
            //直播间推送
            
            [self pushLiveRoom:link_id];
        }
        
    }];
}


+ (void)showDetailTrainAssessCotrollerViewWithLinkID:(NSString *)link_id andTaskResId:(NSString *)taskResId andType:(int)type {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"TrainAssess" bundle:nil];
    
    if (type == 1)
    {
        TrainCourseDetailController *courseVC = [storyBoard instantiateViewControllerWithIdentifier:@"CourseTaskDetail"];
        
        courseVC.courseId = taskResId;
        courseVC.taskId   = link_id;
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:courseVC animated:YES];
    }
    else if (type == 2)
    {
        TrainSopDetailController *sopVC = [storyBoard instantiateViewControllerWithIdentifier:@"SOPTaskDetail"];
        
        sopVC.SOPId  = taskResId;
        sopVC.taskId = link_id;
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:sopVC animated:YES];
    }
}

+ (void)showDetailVideoCotrollerViewWithLink:(NSString *)Link andType:(int)type {
    VCSDetailViewController *vcsVC = [[UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil] instantiateViewControllerWithIdentifier:@"VCSDetailViewController"];
    
    vcsVC.videoId = Link;
    vcsVC.type    = type;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vcsVC animated:YES];
}

+ (void)showNewFriendCotrollerView {
    NewFriendListViewController *controller = [[UIStoryboard storyboardWithName:@"FriendsList" bundle:nil] instantiateViewControllerWithIdentifier:@"NewFriendListViewController"];
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
}

+ (void)showFriendCotrollerView {
    FriendsListViewController *controller = [[UIStoryboard storyboardWithName:@"FriendsList" bundle:nil] instantiateViewControllerWithIdentifier:@"FriendsListViewController"];
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
}

+ (void)showEvaluationListVcWithType:(EvaluationTargetType)type {
    EvaluationListViewController *Vc = [[UIStoryboard storyboardWithName:@"Message" bundle:nil] instantiateViewControllerWithIdentifier:@"EvaluationListViewController"];
    
    Vc.targetType = type;
    if (type == EvaluationTargetTypeInsiders)
    {
        Vc.ViewType = EvalutaionTableViewTypeInsiders;
    }
    else
    {
        Vc.ViewType = EvalutaionTableViewTypeOther;
    }
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:Vc animated:YES];
}

//课程推送
+(void)pushCoursePackDetailWithURL:(NSString *)url
{
    NSArray *infoArr = [url componentsSeparatedByString:@"id="];
    
    ClassDetailViewController * classVC = [[ClassDetailViewController alloc] init];
    
    classVC.shareURL = url;
    
    classVC.coursePackId = infoArr[1];
    
    NSString *systemVersion;
    if (iS_IOS7)
    {
        systemVersion = @"ios7";
    }
    else
    {
        systemVersion = @"ios8Later";
    }
    
    NSString *urlStr;
    
    if ([AppManager hasLogin])
    {
        User *user = [AppManager sharedManager].user;
        urlStr = [NSString stringWithFormat:@"&userId=%@&userType=%@&staffAdmin=%@&device=%@", user.uid, @(user.userType), user.isAdmin,systemVersion];
    }else
    {
        urlStr = [NSString stringWithFormat:@"&userId=&userType=&staffAdmin=&device=%@",systemVersion];
    }
    
    urlStr = [url stringByAppendingString:urlStr];
    
    [classVC loadRequestWithURL:urlStr showProgressView:YES];
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:classVC animated:YES];
}


//活动推送
+(void)showDetailActivityCotrollerViewWithLinkUrl:(NSString *)url{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ActivityDetailController *activityVC = [storyboard instantiateViewControllerWithIdentifier:@"ActivityDetailController"];
    
    NSString *urlString;
    if ([AppManager hasLogin]) {
        
        User *user = [AppManager sharedManager].user;
        
        urlString= [NSString stringWithFormat:@"%@&action=detailApp&userId=%@&userType=%d&backButton=hide", url, user.uid, user.userType];
    }
    else{
        
        urlString= [NSString stringWithFormat:@"%@&action=detailApp&userId=&userType=&backButton=hide", url];
    }
    
    NSArray *infoArr = [url componentsSeparatedByString:@"id="];
    
    activityVC.activityId = infoArr[1];
    
    [activityVC loadRequestWithURL:urlString showProgressView:YES];
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:activityVC animated:YES];
}

+ (void)showDetailInformactionCotrollerViewWithLinkUrl:(NSString *)url {
    
    WebViewDetailController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewDetailController"];
    
    webVC.urlStr = url;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:webVC animated:YES];
}

+ (void)showDetailMailBoxCotrollerViewWithMessageID:(NSString *)messageID {
    MailBoxDetailViewController *detailVC = [[UIStoryboard storyboardWithName:@"Mailbox" bundle:nil] instantiateViewControllerWithIdentifier:@"MailBoxDetailViewController"];
    
    detailVC.type        = 0;
    detailVC.inMessageID = messageID;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:detailVC animated:YES];
}
+(void)pushLiveRoom:(NSString *)roomID
{
    OnLiveViewController *watchVC = [OnLiveViewController new];
    watchVC.IsHorizontal = YES;
    watchVC.roomId = roomID;
    watchVC.listModel = nil;
    LiveNaviViewController *naviVC = [[LiveNaviViewController alloc] initWithRootViewController:watchVC];
    [[AppDelegate sharedAppDelegate].rootNavi presentViewController:naviVC animated:YES completion:nil];
}
+ (void)showOtherPlaceloginCurrentUserCode {
    if (![AppManager hasLogin])
    {
        return;
    }
    [AppManager sharedManager].isKickOut = YES;
    ///取消极光的tag和别名设置
    [JPushHelper clearTagAndAlias];
    
    //发送帐号登录异常通知
    [[NSNotificationCenter defaultCenter] postNotificationName:ACCOUNTLOGINERROR object:nil];
    
    UIViewController *vc = [[AppDelegate sharedAppDelegate].rootNavi.childViewControllers lastObject];
    
    [vc dismissLoadingHUD];
    
    [vc dismissViewControllerAnimated:NO completion:nil];
    [vc.navigationController popToRootViewControllerAnimated:NO];
    
    [AppManager loginOut];
    
    //跳转到首页
    [AppDelegate sharedAppDelegate].mainTabBarController.selectedIndex = 0;
    
    [[[UIAlertView alloc] initWithTitle:@"名医传世-账号登陆提示" message:@"你的账号在其他手机设备登陆了"cancelButtonTitle:nil otherButtonTitle:@"确定"] showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex == 0)
        {
            UIStoryboard *loginSB     = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
            UIViewController *loginVC = [loginSB instantiateInitialViewController];
            
            [[AppDelegate sharedAppDelegate].rootNavi presentViewController:loginVC animated:YES completion:nil];
        }
        
    }];
}

@end
