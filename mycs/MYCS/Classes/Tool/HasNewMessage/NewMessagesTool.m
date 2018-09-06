//
//  NewMessagesTool.m
//  MYCS
//
//  Created by wzyswork on 16/3/16.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "NewMessagesTool.h"
#import "EvaluationModel.h"
#import <RongIMKit/RongIMKit.h>

@interface NewMessagesTool ()

@end

@implementation NewMessagesTool

singleton_implementation(NewMessagesTool)

- (instancetype)init {
    
    if ([super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusChange:) name:@"kReachabilityStatusChange" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];;
    }
    return self;
}

- (void)reachabilityStatusChange:(NSNotification *)noti {
    
    AFNetworkReachabilityStatus status = [noti.object intValue];
    
    //网络的情况下自动连接融云服务器
    if (status!=AFNetworkReachabilityStatusUnknown&&status!=AFNetworkReachabilityStatusNotReachable)
    {
        [self startCheck];
    }
    
}

- (void)applicationWillEnterForeground:(NSNotification *)noti {
    [self startCheck];
}

- (void)applicationDidEnterBackground:(NSNotification *)noti {
    [self stopChecking];
}


- (void)startCheck{
    
    [self checkNewMessage];
    
    if (self.timer)
    {
        [self.timer invalidate];
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(checkNewMessage) userInfo:nil repeats:YES];
    
}

- (void)stopChecking{
    
    [self.timer invalidate];
    self.timer = nil;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PROFILENOTI object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGENOTI object:nil];
}

- (void)checkNewMessage
{
    
    AFNetworkReachabilityStatus status = [AppManager sharedManager].status;
    BOOL hasNetWork = (status!=AFNetworkReachabilityStatusUnknown&&status!=AFNetworkReachabilityStatusNotReachable);
    
    //如果用户未登录或者没有网络，直接停止请求
    if (![AppManager hasLogin]||!hasNetWork)
    {
        [self stopChecking];
        return;
    }
    
    //请求信箱消息和任务消息数
    [NewMsgCountModel checkUpdateWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] Success:^(NewMsgCountModel *model) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:PROFILENOTI object:model];

    } failure:^(NSError *error) {
        
    }];
    
    //获取评价的个数
    [EvaluationModel getNotReadCommentCountSuccess:^(NSArray *list) {
        
        int totalEvaluationCount = 0;
        for (EvaluationCommentCountModel *model in list)
        {
            totalEvaluationCount += [model.count intValue];
        }
        
        NewMsgCountModel *model = [NewMsgCountModel new];
        
        //获取融云的未读消息数
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
        
        model.unreadCount = [NSString stringWithFormat:@"%d",unreadMsgCount];
        model.evaluationCount = [NSString stringWithFormat:@"%d",totalEvaluationCount];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MESSAGENOTI object:model];
        
    } Failure:^(NSError *error) {
        
    }];
    
}

@end








