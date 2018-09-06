//
//  AskingEmployeeModel.m
//  SWWY
//
//  Created by GuoChenghao on 15/1/30.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "AskingEmployeeModel.h"
#import "SCBModel.h"

@implementation AskingEmployeeModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"modelID"}];
}

+ (void)requestAskingEmployeeListWithUserID:(NSString *)userID userType:(NSString *)userType listID:(NSString *)listID pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize Success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:PAYFOROTHER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:@"applyList" forKey:@"action"];
    [params setObjectNilToEmptyString:listID forKey:@"id"];
    [params setObjectNilToEmptyString:pageSize forKey:@"pageSize"];
    [params setObjectNilToEmptyString:pageNo forKey:@"page"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *modelList = [AskingEmployeeModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
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
