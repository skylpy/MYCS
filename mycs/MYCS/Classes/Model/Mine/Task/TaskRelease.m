//
//  TaskRelease.m
//  SWWY
//
//  Created by 黄希望 on 15-1-29.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "TaskRelease.h"
#import "SCBModel.h"
#import "TaskCourseReleaseController.h"

@implementation TaskRelease

#pragma mark - 企业与机构相同的接口
// 普通任务发布招聘
+ (void)commonReleaseWithUserId:(NSString*)userId
                       userType:(NSString*)userType
                         action:(NSString*)action
                       taskName:(NSString*)taskName
                       courseId:(NSString*)courseId
                     courseName:(NSString*)courseName
                      issueTime:(NSString*)issueTime
                        endTime:(NSString*)endTime
                       passRate:(int)passRate
                          scope:(NSString*)scope
                       password:(NSString*)password
                           note:(NSString*)note
                           type:(int)type
                        success:(void (^)(JSONModel *model))success
                        failure:(void (^)(NSError *error))failure {
    
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:taskName forKey:@"taskName"];
    [params setObjectNilToEmptyString:courseId forKey:@"course_id"];
    [params setObjectNilToEmptyString:courseName forKey:@"courseName"];
    [params setObjectNilToEmptyString:issueTime forKey:@"issueTime"];
    [params setObjectNilToEmptyString:endTime forKey:@"endTime"];
    [params setObjectNilToEmptyString:@(passRate) forKey:@"pass_rate"];
    [params setObjectNilToEmptyString:scope forKey:@"scope"];
    [params setObjectNilToEmptyString:password forKey:@"password"];
    [params setObjectNilToEmptyString:note forKey:@"note"];
    [params setObjectNilToEmptyString:@(type) forKey:@"type"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
//卫计委发布sop任务
+ (void)commissionSopReleaseWithUserId:(NSString*)userId
                              userType:(NSString*)userType
                                action:(NSString*)action
                              taskName:(NSString*)taskName
                                 sopId:(NSString*)sopId
                               sopName:(NSString*)sopName
                             issueTime:(NSString*)issueTime
                              usedTime:(NSString*)usedTime
                                deptId:(NSString*)deptId
                              staffUid:(NSString*)staffUid
                               hospUid:(NSString*)hospUid
                                  note:(NSString*)note
                                  type:(int)type
                               success:(void (^)(JSONModel *model))success
                               failure:(void (^)(NSError *error))failure{

    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:taskName forKey:@"taskName"];
    
    [params setObjectNilToEmptyString:sopName forKey:@"sopName"];
    [params setObjectNilToEmptyString:issueTime forKey:@"issueTime"];
    [params setObjectNilToEmptyString:usedTime forKey:@"usedTime"];
    [params setObjectNilToEmptyString:deptId forKey:@"deptId"];
    
    [params setObjectNilToEmptyString:note forKey:@"note"];
    [params setObjectNilToEmptyString:@(type) forKey:@"type"];
    [params setObjectNilToEmptyString:hospUid forKey:@"hospUid"];
    [params setObjectNilToEmptyString:sopId forKey:@"sop_id"];
    [params setObjectNilToEmptyString:staffUid forKey:@"staffUid"];
    
    [params setObjectNilToEmptyString:[AppManager sharedManager].user.username forKey:@"username"];
    
    //base基地传6，gov可不传或者滞空
    if ([AppManager sharedManager].user.agroup_id.intValue == 10) {
        
        NSInteger taskType = 6;
        [params setObjectNilToEmptyString:@(taskType) forKey:@"taskType"];
    }
    
    if ([AppManager sharedManager].user.isAdmin.intValue == 1)
    {
        [params setObjectNilToEmptyString:@"1" forKey:@"staffAdmin"];
    }
    else
    {
        [params setObjectNilToEmptyString:@"0" forKey:@"staffAdmin"];
    }
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
//卫计委发布普通任务
+ (void)commissionReleaseWithUserId:(NSString*)userId
                       userType:(NSString*)userType
                         action:(NSString*)action
                       taskName:(NSString*)taskName
                       courseId:(NSString*)courseId
                     courseName:(NSString*)courseName
                      issueTime:(NSString*)issueTime
                        endTime:(NSString*)endTime
                        hospUid:(NSString*)hospUid
                       passRate:(int)passRate
                         deptId:(NSString*)deptId
                       staffUid:(NSString*)staffUid
                           note:(NSString*)note
                           type:(int)type
                        success:(void (^)(JSONModel *model))success
                        failure:(void (^)(NSError *error))failure{

    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:taskName forKey:@"taskName"];
    [params setObjectNilToEmptyString:courseId forKey:@"course_id"];
    [params setObjectNilToEmptyString:courseName forKey:@"courseName"];
    [params setObjectNilToEmptyString:issueTime forKey:@"issueTime"];
    [params setObjectNilToEmptyString:endTime forKey:@"endTime"];
    [params setObjectNilToEmptyString:@(passRate) forKey:@"pass_rate"];
    
    [params setObjectNilToEmptyString:deptId forKey:@"deptId"];
    [params setObjectNilToEmptyString:note forKey:@"note"];
    [params setObjectNilToEmptyString:@(type) forKey:@"type"];
    [params setObjectNilToEmptyString:hospUid forKey:@"hospUid"];
    [params setObjectNilToEmptyString:staffUid forKey:@"staffUid"];
    
    //base基地传6，gov可不传或者滞空
    if ([AppManager sharedManager].user.agroup_id.intValue == 10) {
        
        NSInteger taskType = 6;
        [params setObjectNilToEmptyString:@(taskType) forKey:@"taskType"];
    }
    
    if ([AppManager sharedManager].user.isAdmin.intValue == 1)
    {
        [params setObjectNilToEmptyString:@"1" forKey:@"staffAdmin"];
    }
    else
    {
        [params setObjectNilToEmptyString:@"0" forKey:@"staffAdmin"];
    }
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
// 普通任务发布内训
+ (void)commonReleaseWithUserId:(NSString*)userId
                       userType:(NSString*)userType
                         action:(NSString*)action
                       taskName:(NSString*)taskName
                       courseId:(NSString*)courseId
                     courseName:(NSString*)courseName
                      issueTime:(NSString*)issueTime
                        endTime:(NSString*)endTime
                       passRate:(int)passRate
                         deptId:(NSString*)deptId
                       staffUid:(NSString*)staffUid
                           note:(NSString*)note
                           type:(int)type
                        success:(void (^)(JSONModel *model))success
                        failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:taskName forKey:@"taskName"];
    [params setObjectNilToEmptyString:courseId forKey:@"course_id"];
    [params setObjectNilToEmptyString:courseName forKey:@"courseName"];
    [params setObjectNilToEmptyString:issueTime forKey:@"issueTime"];
    [params setObjectNilToEmptyString:endTime forKey:@"endTime"];
    [params setObjectNilToEmptyString:@(passRate) forKey:@"pass_rate"];
    
    [params setObjectNilToEmptyString:deptId forKey:@"deptId"];
    [params setObjectNilToEmptyString:note forKey:@"note"];
    [params setObjectNilToEmptyString:@(type) forKey:@"type"];

    if ([AppManager sharedManager].user.agroup_id.integerValue == 9) {
        
        [params setObjectNilToEmptyString:deptId forKey:@"hospUid"];
        [params setObjectNilToEmptyString:staffUid forKey:@"staffUid"];
        
    }else{
        [params setObjectNilToEmptyString:staffUid forKey:@"staffUid"];
        
    }
    
    if ([AppManager sharedManager].user.isAdmin.intValue == 1)
    {
        [params setObjectNilToEmptyString:@"1" forKey:@"staffAdmin"];
    }
    else
    {
        [params setObjectNilToEmptyString:@"0" forKey:@"staffAdmin"];
    }
    NSString * urls = [NSString stringWithFormat:@"%@%@",path,params];
    NSLog(@"%@",urls);
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// sop任务发布招聘
+ (void)sopReleaseWithUserId:(NSString*)userId
                    userType:(NSString*)userType
                      action:(NSString*)action
                    taskName:(NSString*)taskName
                       sopId:(NSString*)sopId
                     sopName:(NSString*)sopName
                   issueTime:(NSString*)issueTime
                    usedTime:(NSString*)usedTime
                       scope:(NSString*)scope
                    password:(NSString*)password
                        note:(NSString*)note
                        type:(int)type
                     success:(void (^)(JSONModel *model))success
                     failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:taskName forKey:@"taskName"];
    [params setObjectNilToEmptyString:sopId forKey:@"sopId"];
    [params setObjectNilToEmptyString:sopName forKey:@"sopName"];
    [params setObjectNilToEmptyString:issueTime forKey:@"issueTime"];
    [params setObjectNilToEmptyString:usedTime forKey:@"usedTime"];
    [params setObjectNilToEmptyString:scope forKey:@"scope"];
    [params setObjectNilToEmptyString:password forKey:@"password"];
    [params setObjectNilToEmptyString:note forKey:@"note"];
    [params setObjectNilToEmptyString:@(type) forKey:@"type"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

// sop任务发布内训
+ (void)sopReleaseWithUserId:(NSString*)userId
                    userType:(NSString*)userType
                      action:(NSString*)action
                    taskName:(NSString*)taskName
                       sopId:(NSString*)sopId
                     sopName:(NSString*)sopName
                   issueTime:(NSString*)issueTime
                    usedTime:(NSString*)usedTime
                      deptId:(NSString*)deptId
                    staffUid:(NSString*)staffUid
                        note:(NSString*)note
                        type:(int)type
                     success:(void (^)(JSONModel *model))success
                     failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:taskName forKey:@"taskName"];
    
    [params setObjectNilToEmptyString:sopName forKey:@"sopName"];
    [params setObjectNilToEmptyString:issueTime forKey:@"issueTime"];
    [params setObjectNilToEmptyString:usedTime forKey:@"usedTime"];
    [params setObjectNilToEmptyString:deptId forKey:@"deptId"];
    
    [params setObjectNilToEmptyString:note forKey:@"note"];
    [params setObjectNilToEmptyString:@(type) forKey:@"type"];
    if ([AppManager sharedManager].user.agroup_id.integerValue == 9) {
        [params setObjectNilToEmptyString:deptId forKey:@"hospUid"];
        [params setObjectNilToEmptyString:sopId forKey:@"sop_id"];
    }else{
        [params setObjectNilToEmptyString:staffUid forKey:@"staffUid"];
        [params setObjectNilToEmptyString:sopId forKey:@"sopId"];
    }
    
    
    
    if ([AppManager sharedManager].user.isAdmin.intValue == 1)
    {
        [params setObjectNilToEmptyString:@"1" forKey:@"staffAdmin"];
    }
    else
    {
        [params setObjectNilToEmptyString:@"0" forKey:@"staffAdmin"];
    }
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 机构独有接口
// ===【 普通任务 -- 发布会员任务】===
+ (void)commonMemberReleaseWithUserId:(NSString*)userId
                             userType:(NSString*)userType
                               action:(NSString*)action
                             taskName:(NSString*)taskName
                             courseId:(NSString*)courseId
                           courseName:(NSString*)courseName
                            issueTime:(NSString*)issueTime
                              endTime:(NSString*)endTime
                             passRate:(int)passRate
                              gradeId:(NSString*)gradeId
                             staffUid:(NSString*)staffUid
                                 note:(NSString*)note
                                 type:(int)type
                              success:(void (^)(JSONModel *model))success
                              failure:(void (^)(NSError *error))failure{
    
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:taskName forKey:@"taskName"];
    [params setObjectNilToEmptyString:courseId forKey:@"course_id"];
    [params setObjectNilToEmptyString:courseName forKey:@"courseName"];
    [params setObjectNilToEmptyString:issueTime forKey:@"issueTime"];
    [params setObjectNilToEmptyString:endTime forKey:@"endTime"];
    [params setObjectNilToEmptyString:@(passRate) forKey:@"pass_rate"];
    [params setObjectNilToEmptyString:gradeId forKey:@"gradeId"];
    [params setObjectNilToEmptyString:staffUid forKey:@"staffUid"];
    [params setObjectNilToEmptyString:note forKey:@"note"];
    [params setObjectNilToEmptyString:@(type) forKey:@"type"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// ===【 SOP任务 -- 发布会员任务 】===
+ (void)sopMemberReleaseWithUserId:(NSString*)userId
                    userType:(NSString*)userType
                      action:(NSString*)action
                    taskName:(NSString*)taskName
                       sopId:(NSString*)sopId
                     sopName:(NSString*)sopName
                   issueTime:(NSString*)issueTime
                    usedTime:(NSString*)usedTime
                      gradeId:(NSString*)gradeId
                    staffUid:(NSString*)staffUid
                        note:(NSString*)note
                     success:(void (^)(JSONModel *model))success
                     failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:taskName forKey:@"taskName"];
    [params setObjectNilToEmptyString:sopId forKey:@"sopId"];
    [params setObjectNilToEmptyString:sopName forKey:@"sopName"];
    [params setObjectNilToEmptyString:issueTime forKey:@"issueTime"];
    [params setObjectNilToEmptyString:usedTime forKey:@"usedTime"];
    [params setObjectNilToEmptyString:gradeId forKey:@"gradeId"];
    [params setObjectNilToEmptyString:staffUid forKey:@"staffUid"];
    [params setObjectNilToEmptyString:note forKey:@"note"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 企业独有接口
// ==【 企业 -- 确定发布会员任务 】==
+ (void)memberReleaseWithUserId:(NSString*)userId
                       userType:(NSString*)userType
                         action:(NSString*)action
                   memberTaskId:(NSString*)memberTaskId
                           sort:(NSString*)sort
                         deptId:(NSString*)deptId
                       staffUid:(NSString*)staffUid
                        success:(void (^)(JSONModel *model))success
                        failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:memberTaskId forKey:@"memberTaskId"];
    [params setObjectNilToEmptyString:sort forKey:@"sort"];
    [params setObjectNilToEmptyString:deptId forKey:@"deptId"];
    [params setObjectNilToEmptyString:staffUid forKey:@"staffUid"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)releaseSOPTaskWith:(TaskReleaseParamModel *)paramModel success:(void (^)(JSONModel *model))success failure:(void (^)(NSError *error))failure {
    
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"sendTask";
    params[@"courseName"] = paramModel.course;
    params[@"course_id"] = paramModel.courseId;
    params[@"deptId"] = paramModel.depId;
    params[@"usedTime"] = paramModel.dayCount;
    params[@"issueTime"] = paramModel.startTime;
    params[@"note"] = paramModel.desc;
    params[@"pass_rate"] = paramModel.passRate;
    params[@"staffUid"] = paramModel.employeeId;
    params[@"taskName"] = paramModel.title;
    params[@"type"] = @(1);
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"userType"] = @([AppManager sharedManager].user.userType);
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
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

@implementation M_taskModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (void)memberTaskListWithUserId:(NSString*)userId
                        userType:(NSString*)userType
                          action:(NSString*)action
                    memberTaskId:(NSString*)memberTaskId
                            sort:(NSString*)sort
                         success:(void (^)(M_taskModel *model))success
                         failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:memberTaskId forKey:@"memberTaskId"];
    [params setObjectNilToEmptyString:sort forKey:@"sort"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        M_taskModel *m_taskModel = [[M_taskModel alloc] initWithDictionary:model.data error:&error];
        if (success) {
            success(m_taskModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
