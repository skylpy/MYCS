//
//  GeneralCommentModel.m
//  MYCS
//
//  Created by GuiHua on 16/7/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "GeneralCommentModel.h"

@implementation GeneralCommentModel

+(void)commentWithUserId:(NSString *)userId userType:(NSString *)userType action:(NSString *)action pageSize:(int)pageSize page:(int)page targetType:(int)targetType targetId:(NSString *)targetId success:(void (^)(NSArray *, NSString *))success failure:(void (^)(NSError *))failure
{

    NSString *path = [HOST_URL stringByAppendingString:GENERALCOMMENT_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
  
    [params setObjectNilToEmptyString:@(targetType) forKey:@"target_type"];
    [params setObjectNilToEmptyString:targetId forKey:@"target_id"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(page) forKey:@"page"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *list = [GeneralCommentModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        
        for (GeneralCommentModel *model in list)
        {
            NSArray *sonArr = [GeneralCommentModel arrayOfModelsFromDictionaries:model.son error:&error];
            model.sons = sonArr;
        }
        
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(list,[model.data objectForKey:@"total"]);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

+(void)addCmtWithUserId:(NSString *)userId userType:(NSString *)userType action:(NSString *)action targetType:(NSString *)targetType targetId:(NSString *)targetId content:(NSString *)content replyId:(NSString *)replyId toUid:(NSString *)toUid toEid:(NSString *)toEid success:(void (^)(SCBModel *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL stringByAppendingString:GENERALCOMMENT_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:targetType forKey:@"target_type"];
    [params setObjectNilToEmptyString:targetId forKey:@"target_id"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:replyId forKey:@"reply_id"];
    
    [params setObjectNilToEmptyString:content forKey:@"content"];
    [params setObjectNilToEmptyString:toUid forKey:@"toUid"];
    [params setObjectNilToEmptyString:toEid forKey:@"toEid"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        if (success)
        {
            success(model);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}


+(void)praiseOrCollectWithUserId:(NSString *)userId userType:(NSString *)userType action:(NSString *)action targetType:(NSString *)targetType targetId:(NSString *)targetId success:(void (^)(SCBModel *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL stringByAppendingString:GENERALCOMMENT_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:targetType forKey:@"target_type"];
    [params setObjectNilToEmptyString:targetId forKey:@"target_id"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        if (success)
        {
            success(model);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}
@end

















