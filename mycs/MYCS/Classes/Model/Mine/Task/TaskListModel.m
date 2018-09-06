//
//  TaskListModel.m
//  SWWY
//
//  Created by 黄希望 on 15-1-25.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "TaskListModel.h"
#import "SCBModel.h"

@implementation TaskListModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (void)listWithUserId:(NSString *)userId
              userType:(NSString *)userType
                action:(NSString *)action
                  type:(int)type
                  sort:(NSString*)sort
               keyword:(NSString *)keyword
              pageSize:(int)pageSize
                  page:(int)page
              taskSort: (NSString *)taskSort
               success:(void (^)(TaskListModel *taskListModel))success
               failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
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
    if (sort) {
        [params setObject:sort forKey:@"sort"];
    }
    if (taskSort) {
        [params setObject:taskSort forKey:@"taskSort"];
    }
    if (keyword) {
        [params setObject:keyword forKey:@"keyword"];
    }
    [params setObject:@(type) forKey:@"type"];
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(page) forKey:@"page"];
    
    
    if ([AppManager sharedManager].user.isAdmin.intValue == 1)
    {
        [params setObjectNilToEmptyString:@"1" forKey:@"staffAdmin"];
    }
    else
    {
        [params setObjectNilToEmptyString:@"0" forKey:@"staffAdmin"];
    }
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        TaskListModel *listModel = [[TaskListModel alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(listModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end
