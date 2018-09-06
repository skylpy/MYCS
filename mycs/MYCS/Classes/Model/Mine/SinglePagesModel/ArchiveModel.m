//
//  ArchiveModel.m
//  SWWY
//
//  Created by GuoChenghao on 15/2/4.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "ArchiveModel.h"
#import "SCBModel.h"

@implementation ArchiveModel

+ (void)requestArchiveListWithUserID:(NSString *)userID page:(NSUInteger)pageNo pageSize:(NSString *)pageSize success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:ARCHIVELIST_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:pageSize forKey:@"pageSize"];
    [params setObjectNilToEmptyString:@(pageNo) forKey:@"page"];

    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *modelList = [ArchiveModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
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
