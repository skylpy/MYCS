//
//  TaskDetailModel.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskDetailModel.h"
#import "SCBModel.h"
#import "MJExtension.h"

@implementation TaskDetailModel

+ (void)taskDetailWith:(NSString *)taskId memberTaskId:(NSString *)memberTaskId sort:(NSString *)sort success:(void (^)(TaskDetailModel *))success failure:(void (^)(NSError *))failure{
    
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"userDetail";
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"taskId"] = taskId;
    if (memberTaskId != nil)
    {
        params[@"memberTaskId"] = memberTaskId;
    }
    params[@"userType"] = @([AppManager sharedManager].user.userType);
    params[@"sort"] = sort;
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        TaskDetailModel *detailModel = [TaskDetailModel objectWithKeyValues:model.data];
        
        if (success) {
            success(detailModel);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end

@implementation Detail

+ (NSDictionary *)objectClassInArray{
    return @{@"chapters" : [Chapters class]};
}

@end


@implementation Chapters

@end


@implementation TaskJoinUser

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [TaskJoinUserModel class]};
}

@end


@implementation TaskJoinUserModel

+ (void)userJoinListWith:(NSString *)taskId Sort:(NSString *)sort page:(NSInteger)page requestType:(NSString *)type success:(void (^)(NSMutableArray *))success failure:(void (^)(NSError *))failure {
    
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"users";
    params[@"page"] = @(page);
    params[@"pageSize"] = @(15);
    params[@"taskId"] = taskId;
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"userType"] = @([AppManager sharedManager].user.userType);
    params[@"sort"] = sort;
    if (type) {
        params[@"passed"] = type;
    }
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
#pragma mark - 字典数组 -> 模型数组
        NSMutableArray *list = [TaskJoinUserModel objectArrayWithKeyValuesArray:model.data[@"list"]];
        
        if (success) {
            success(list);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end


@implementation TaskJoinHospitalModel

+(void)hospitalJoinListWith:(NSString *)taskId Sort:(NSString *)sort page:(NSInteger)page taskType:(NSString *)taskType success:(void (^)(NSMutableArray *))success failure:(void (^)(NSError *))failure{

    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"hosPants";
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"userType"] = @([AppManager sharedManager].user.userType);
    params[@"taskType"] = taskType;
    params[@"taskId"] = taskId;
    
//    params[@"page"] = @(page);
//    params[@"pageSize"] = @(15);
//    
//    params[@"sort"] = sort;
    
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
#pragma mark - 字典数组 -> 模型数组
        NSMutableArray *list = [TaskJoinHospitalModel objectArrayWithKeyValuesArray:model.data[@"list"]];
        
        if (success) {
            success(list);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end


