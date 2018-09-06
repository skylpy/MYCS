//
//  CommentModel.m
//  SWWY
//
//  Created by 黄希望 on 15-1-25.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "CommentModel.h"
#import "AppManager.h"

@implementation commentReplyListModel

@end

@implementation commentListModel

@end

@implementation CommentSendModel

@end

@implementation CommentModel

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"commentId"}];
}

+ (void)commentWithUserId:(NSString *)userId
                 userType:(NSString *)userType
                   action:(NSString *)action
                 pageSize:(int)pageSize
                     page:(int)page
              commentType:(int)commentType
               commentCId:(NSString*)commentCId
                  success:(void (^)(NSArray *list))success
                  failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:COMMENT_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId) {
        [params setObject:userId forKey:@"userId"];
    }
    if (action) {
        [params setObject:action forKey:@"action"];
    }
    if (userType) {
        [params setObject:userType forKey:@"userType"];
    }
    if (commentCId) {
        [params setObject:commentCId forKey:@"comment_cid"];
    }
    [params setObject:@(commentType) forKey:@"comment_type"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(page) forKey:@"page"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *list = [CommentModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(list);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)addCmtWithUserId:(NSString*)userId
                userType:(NSString*)userType
                  action:(NSString*)action
                cmt_type:(NSString*)cmt_type
                 cmt_cid:(NSString*)cmt_cid
                 content:(NSString*)content
                 replyId:(NSString*)replyId
                 success:(void (^)(CommentModel *model))success
                 failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:COMMENT_PATH];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId) {
        [params setObject:userId forKey:@"userId"];
    }
    if (action) {
        [params setObject:action forKey:@"action"];
    }
    if (userType) {
        [params setObject:userType forKey:@"userType"];
    }
    if (cmt_type) {
        [params setObject:cmt_type forKey:@"comment_type"];
    }
    if (cmt_cid) {
        [params setObject:cmt_cid forKey:@"comment_cid"];
    }
    if (content) {
        [params setObject:content forKey:@"content"];
    }
    if (replyId) {
        [params setObject:replyId forKey:@"replyId"];
    }
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        
        CommentModel *cmt = [[CommentModel alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(cmt);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}




#pragma mark -新接口

+ (void)addCmtWithcmt_type:(NSString*)cmt_type
                   cmt_cid:(NSString*)cmt_cid
                   content:(NSString*)content
                   toEid:(NSString*)toEid
                   toUid:(NSString*)toUid
                   success:(void (^)(SCBModel *model))success
                   failure:(void (^)(NSError *error))failure{
    
    NSString *path = [HOST_URL stringByAppendingString:ACADEMICEXCHANGE];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:@"add" forKey:@"action"];
    [params setObject:[AppManager sharedManager].user.uid forKey:@"userId"];
    [params setObject:content forKey:@"content"];
    [params setObjectNilToEmptyString:toEid forKey:@"toEid"];
    [params setObjectNilToEmptyString:toUid forKey:@"toUid"];
    [params setObject:cmt_type forKey:@"target_type"];
    [params setObject:cmt_cid forKey:@"target_id"];

//    [params setObject:cmt_type forKey:@"comment_type"];
//    [params setObject:cmt_cid forKey:@"comment_cid"];
//    [params setObjectNilToEmptyString:replyId forKey:@"replyId"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        


        if (error && failure) {
            failure(error);
        } else if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getCommentWithcmt_type:(NSString*)cmt_type
                   cmt_cid:(NSString*)cmt_cid
                   page:(NSString*)page
                   replyId:(NSString *)replyId
                   success:(void (^)(NSArray *listArr))success
                   failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:ACADEMICEXCHANGE];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];

    [params setObject:@"list" forKey:@"action"];
    [params setObject:cmt_type forKey:@"target_type"];
    [params setObjectNilToEmptyString:cmt_cid forKey:@"target_id"];
    [params setObject:page forKey:@"page"];
    [params setObject:@"10" forKey:@"pageSize"];
    [params setObjectNilToEmptyString:replyId forKey:@"replyId"];

    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *modelList = [commentListModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
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

+ (void)praiseChangeWithcmt_type:(NSString*)cmt_type
                       cmt_cid:(NSString*)cmt_cid
                       success:(void (^)(SCBModel *model))success
                       failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:ACADEMICEXCHANGE];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:[AppManager sharedManager].user.uid forKey:@"userId"];
    [params setObject:@"changePraise" forKey:@"action"];
    [params setObject:cmt_type forKey:@"target_type"];
    [params setObject:cmt_cid forKey:@"target_id"];
    
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
