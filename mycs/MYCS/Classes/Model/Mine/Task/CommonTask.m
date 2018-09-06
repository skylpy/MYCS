//
//  CommonTask.m
//  SWWY
//
//  Created by 黄希望 on 15-1-25.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "CommonTask.h"
#import "SCBModel.h"

@implementation CommonTask

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"pass_rate":@"passRate"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (void)taskWithUserId:(NSString *)userId
              userType:(NSString *)userType
                action:(NSString *)action
                  sort:(NSString *)sort
                    Id:(NSString *)Id
               success:(void (^)(CommonTask *commonTask))success
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
    if (Id) {
        [params setObject:Id forKey:@"id"];
    }
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        
        CommonTask *detailModel = [[CommonTask alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(detailModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
