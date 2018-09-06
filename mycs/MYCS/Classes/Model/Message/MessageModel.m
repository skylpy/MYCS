//
//  MessageModel.m
//  SWWY
//
//  Created by GuoChenghao on 15/1/18.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "MessageModel.h"
#import "SCBModel.h"
#import "AppManager.h"

@implementation MailBoxTaskListModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation boxDetailTaskModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation InboxListItemModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"modelID"}];
}
@end

@implementation OutboxListItemModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"toUser": @"toUser"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation SenderDetailModel
@end

@implementation PostListItemModel
@end

@implementation AttachmentModel
@end

@implementation InboxDetailModel
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"modelID"}];
}
@end

@implementation OutboxDetailModel
+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"toUid": @"toUid"}];
}
@end

@implementation UnreadNumModel
@end


//====================================================================//
@implementation MessageModel

+ (void)requestInboxListWithUserID:(NSString *)userID userType:(NSString *)userType pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize keyword:(NSString *)keyword Success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:INBOXLIST_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:@"list" forKey:@"action"];
    [params setObjectNilToEmptyString:pageSize forKey:@"pageSize"];
    [params setObjectNilToEmptyString:pageNo forKey:@"page"];
    [params setObjectNilToEmptyString:keyword forKey:@"keyword"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *modelList = [InboxListItemModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(modelList);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)requestOutboxListWithUserID:(NSString *)userID userType:(NSString *)userType pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize keyword:(NSString *)keyword Success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:INBOXLIST_PATH];
    
    if (userID == nil) userID = @"";
    if (userType == nil) userType = @"";
    if (pageNo == nil) pageNo = @"";
    if (pageSize == nil) pageSize = @"";
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:@"sendList" forKey:@"action"];
    [params setObjectNilToEmptyString:pageSize forKey:@"pageSize"];
    [params setObjectNilToEmptyString:pageNo forKey:@"page"];
    [params setObjectNilToEmptyString:keyword forKey:@"keyword"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        NSArray *modelList = [OutboxListItemModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(modelList);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)requestInboxDetailWithUserID:(NSString *)userID userType:(NSString *)userType linkID:(NSString *)linkID Success:(void (^)(InboxDetailModel *inboxDetail))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:INBOXLIST_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:@"userId"];
    [params setObject:userType forKey:@"userType"];
    [params setObject:@"detail" forKey:@"action"];
    [params setObject:linkID forKey:@"linkId"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        InboxDetailModel *modelTemp = [[InboxDetailModel alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(modelTemp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)requestOutboxDetailWithUserID:(NSString *)userID userType:(NSString *)userType msgID:(NSString *)msgID Success:(void (^)(OutboxDetailModel *outboxDetail))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:INBOXLIST_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:@"userId"];
    [params setObject:userType forKey:@"userType"];
    [params setObject:@"sendDetail" forKey:@"action"];
    [params setObject:msgID forKey:@"msgId"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        OutboxDetailModel *modelTemp = [[OutboxDetailModel alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(modelTemp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)deleteMessageWithUserID:(NSString *)userID userType:(NSString *)userType linkIDs:(NSString *)linkIDs from:(NSString *)from success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:INBOXLIST_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (from != nil) [params setObject:from forKey:@"from"];
    [params setObject:userID forKey:@"userId"];
    [params setObject:userType forKey:@"userType"];
    [params setObject:@"delMsg" forKey:@"action"];
    [params setObject:linkIDs forKey:@"linkId"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)sendMessageWithUserID:(NSString *)userID userType:(NSString *)userType userIDs:(NSString *)userIDs departmentIDs:(NSString *)departmentIDs title:(NSString *)title content:(NSString *)content sendType:(int)sendType success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:INBOXLIST_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:@"send" forKey:@"action"];
    
    if ((sendType == 0 || sendType == 3) && ([userType isEqualToString:@"1"]||([userType isEqualToString:@"3"] && [AppManager sharedManager].user.isAdmin.intValue != 1)))
    {
        [params setObjectNilToEmptyString:userIDs forKey:@"username"];
    }else
    {
        
        [params setObjectNilToEmptyString:userIDs forKey:@"toUid"];
        
        if([userType isEqualToString:@"4"]&& sendType == 0)
        {
            [params setObjectNilToEmptyString:departmentIDs forKey:@"gradeId"];
        }else
        {
            [params setObjectNilToEmptyString:departmentIDs forKey:@"deptId"];
        }
    }
    [params setObjectNilToEmptyString:content forKey:@"content"];
    [params setObjectNilToEmptyString:title forKey:@"title"];
    
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)replyMessageWithUserID:(NSString *)userID userType:(NSString *)userType linkID:(NSString *)linkID toUid:(NSString *)toUid title:(NSString *)title content:(NSString *)content success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:INBOXLIST_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:@"userId"];
    [params setObject:userType forKey:@"userType"];
    [params setObject:@"reply" forKey:@"action"];
    [params setObject:linkID forKey:@"linkId"];
    [params setObject:toUid forKey:@"toUid"];
    [params setObject:content forKey:@"content"];
    [params setObject:title forKey:@"title"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)unReadMessageNumberWithUserID:(NSString *)userID userType:(NSString *)userType success:(void (^)(UnreadNumModel *unreadNum))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:UNREADNUMBER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:@"userId"];
    [params setObject:userType forKey:@"userType"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        UnreadNumModel *modelTemp = [[UnreadNumModel alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(modelTemp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


+ (void)MailBoxTaskListSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:INBOXLIST_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[AppManager sharedManager].user.uid forKey:@"userId"];
    [params setObject:[NSString stringWithFormat:@"%i",[AppManager sharedManager].user.userType] forKey:@"userType"];
    [params setObject:@"tipsData" forKey:@"action"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *modelList = [MailBoxTaskListModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(modelList);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
