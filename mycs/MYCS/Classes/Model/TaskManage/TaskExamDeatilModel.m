//
//  TaskExamDeatilModel.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/20.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskExamDeatilModel.h"
#import "SCBModel.h"
#import "MJExtension.h"

@implementation TaskExamDeatilModel

+ (void)employeeTestDetailWith:(NSString *)taskId taskType:(int)type employeeId:(NSString *)uid success:(void (^)(TaskExamDeatilModel *))success failure:(void (^)(NSError *))failure {
    
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"examineDetail";
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"userType"] = @([AppManager sharedManager].user.userType);
    params[@"taskId"] = taskId;
    params[@"taskType"] = @(type);
    params[@"uid"] = uid;
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        TaskExamDeatilModel *detailModel = [TaskExamDeatilModel objectWithKeyValues:model.data];
        
        if (success) success(detailModel);
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

+ (NSDictionary *)objectClassInArray{
    return @{@"courseList" : [TaskCourseList class]};
}
@end
@implementation Taskone

@end


@implementation SoptEmplate

@end


@implementation TaskCourseList

+ (NSDictionary *)objectClassInArray{
    return @{@"chapters" : [TaskChapters class]};
}

@end


@implementation TaskChapters

+ (NSDictionary *)objectClassInArray{
    return @{@"papers" : [TaskPapers class]};
}

@end


@implementation TaskPapers

+ (NSDictionary *)objectClassInArray{
    return @{@"items" : [TaskItems class]};
}

@end


@implementation TaskItems

+ (NSDictionary *)objectClassInArray{
    return @{@"option" : [TaskOption class]};
}

@end


@implementation TaskOption

@end


