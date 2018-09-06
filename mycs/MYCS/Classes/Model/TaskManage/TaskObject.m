//
//  TaskObject.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/22.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskObject.h"
#import "MJExtension.h"

@implementation TaskObject

+ (void)taskDepartmentDevelopmentCommissionConcatWithGovType:(NSString *)govType Success:(void (^)(NSArray *TaskObjectList))success failure:(void (^)(NSError *))failure
{
    
    NSString *path = [HOST_URL stringByAppendingString:POSTSYSTEM_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"userType"] = [NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType];
    
    params[@"action"] = @"getDept";
    params[@"sort"] = @"sendtask";
    params[@"govType"] = govType;
    
    //BGET
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSArray<TaskObject *> *arr = [TaskObject objectArrayWithKeyValuesArray:model.data[@"list"]];
        
        if (success) {
            success(arr);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

+(void)taskDepartmentConcatWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL stringByAppendingString:POSTSYSTEM_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"userType"] = [NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType];
    
    params[@"action"] = @"getDept";
    params[@"sort"] = @"sendtask";
    if ([AppManager sharedManager].user.agroup_id.integerValue == 9 ||[AppManager sharedManager].user.agroup_id.integerValue == 10) {
        
        params[@"agroup_id"] = [AppManager sharedManager].user.agroup_id;
    }
    
    //BGET
    [SCBModel BGET:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSArray<TaskObject *> *arr = [TaskObject objectArrayWithKeyValuesArray:model.data[@"list"]];
        
        if (success) {
            success(arr);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

+ (void)departmentConcatWithSuccess:(void (^)(NSArray *TaskObjectList))success failure:(void (^)(NSError *))failure {
    
    NSString *path = [HOST_URL stringByAppendingString:POSTSYSTEM_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"userType"] = [NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType];
    
    params[@"action"] = @"getDept";
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSArray<TaskObject *> *arr = [TaskObject objectArrayWithKeyValuesArray:model.data[@"list"]];
        
        if (success) {
            success(arr);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}


+ (NSDictionary *)objectClassInArray{
    return @{@"children" : [TaskObject class]};
}

@end

