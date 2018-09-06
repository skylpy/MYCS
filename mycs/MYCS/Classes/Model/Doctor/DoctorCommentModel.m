//
//  DoctorCommentModel.m
//  SWWY
//
//  Created by zhihua on 15/6/29.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "DoctorCommentModel.h"
#import "SCBModel.h"
#import "MJExtension.h"

@implementation DoctorComment


@end


@implementation DoctorCommentModel

+ (void)commentListsWithUserId:(NSString *)userid
                       checkID:(NSString *)checkUid
                          page:(int)page
                      pageSize:(int)pageSize
                       success:(void (^)(DoctorCommentModel *commentListModel))success
                       failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"checkUid"] = checkUid;
    dict[@"action"] = @"list";
    dict[@"page"] = @(page);
    dict[@"pageSize"] = @(pageSize);
    dict[@"userId"] = userid;
    
    NSString *path = [HOST_URL stringByAppendingString:DOCTORCOMMENT];
    
    [SCBModel BPOST:path parameters:dict encrypt:YES success:^(SCBModel *model) {
        
        DoctorCommentModel *commentListModel = [DoctorCommentModel objectWithKeyValues:model.data];
        
        NSMutableArray *list = [NSMutableArray array];
        for (NSDictionary *dict in model.data[@"list"]) {
            DoctorComment *comment = [DoctorComment objectWithKeyValues:dict];
            [list addObject:comment];
        }
        
        commentListModel.list = list;
        
        if (success) {
            success(commentListModel);
        }
        
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

+ (void)commitCommentWithUserId:(NSString *)userid toUid:(NSString *)toUid content:(NSString *)content score:(int)score success:(void (^)(SCBModel *model))success failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = userid;
    param[@"action"] = @"add";
    param[@"toUid"] = toUid;
    param[@"content"] = content;
    param[@"score"] = @(score);
    
    NSString *path = [HOST_URL stringByAppendingString:DOCTORCOMMENT];

    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


@end
