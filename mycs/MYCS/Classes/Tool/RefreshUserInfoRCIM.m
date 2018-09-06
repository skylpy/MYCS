//
//  RefreshUserInfoRCIM.m
//  MYCS
//  刷新融云会话列表
//  Created by yiqun on 16/3/24.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "RefreshUserInfoRCIM.h"
#import "FriendModel.h"
//#import <RCUserInfo.h>
#import <RongIMKit/RongIMKit.h>

@implementation RefreshUserInfoRCIM

+(void)refreshUserInfoCacheUserID:(NSString *)userID{

    RCUserInfo *user = [[RCUserInfo alloc]init];
    
    [FriendModel searchFriendWithKeyword:userID Searchtype:@"fanId" Success:^(NSMutableArray * list) {
        FriendModel * model = list[0];
        user.userId = model.friendId;
        user.name = model.name;
        user.portraitUri =model.pic_url;
        
        [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userID];
        
    } Failure:^(NSError *error) {
        
    }];
}

@end
