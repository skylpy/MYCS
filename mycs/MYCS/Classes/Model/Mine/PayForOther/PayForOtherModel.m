//
//  PayForOtherModel.m
//  SWWY
//
//  Created by GuoChenghao on 15/1/29.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "PayForOtherModel.h"
#import "SCBModel.h"

@implementation PayForOtherModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"modelID"}];
}

+ (void)requestPayForOtherWithUserID:(NSString *)userID userType:(NSString *)userType sort:(NSString *)sort status:(NSString *)status pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize Success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:PAYFOROTHER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:@"list" forKey:@"action"];
    [params setObjectNilToEmptyString:sort forKey:@"sort"];
    [params setObjectNilToEmptyString:status forKey:@"status"];
    [params setObjectNilToEmptyString:pageSize forKey:@"pageSize"];
    [params setObjectNilToEmptyString:pageNo forKey:@"page"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *modelList = [PayForOtherModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
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

+ (void)rejectPayForOtherWithUserID:(NSString *)userID userType:(NSString *)userType listID:(NSString *)listID reason:(NSString *)reason success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:PAYFOROTHER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:@"refuse" forKey:@"action"];
    [params setObjectNilToEmptyString:listID forKey:@"id"];
    [params setObjectNilToEmptyString:reason forKey:@"reason"];
    
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

@end
