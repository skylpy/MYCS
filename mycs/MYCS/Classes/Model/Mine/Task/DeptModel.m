//
//  DeptModel.m
//  SWWY
//
//  Created by 黄希望 on 15-1-31.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "DeptModel.h"
#import "SCBModel.h"

@implementation MemModel


@end

@implementation DeptModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"parent_id": @"parentId",@"enterprise_uid": @"enterpriseUid",@"user_staff": @"userStaff"}];
}

+ (void)dataWithUserId:(NSString*)userId
              userType:(NSString*)userType
                action:(NSString*)action
               success:(void (^)(NSArray *list))success
               failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:POSTSYSTEM_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:@"sendtask" forKey:@"sort"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *modelList = [DeptModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
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

+(void)getMemberDetail:(NSString *)userID userType:(NSString *)userType action:(NSString *)action success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    paramDict[@"userId"] = userID;
    paramDict[@"userType"] = userType;
    paramDict[@"action"] = action;
    
    NSString *path = [HOST_URL stringByAppendingString:MEMBER_PATH];
    
    [SCBModel BPOST:path parameters:paramDict encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *modelList = [MemModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
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
