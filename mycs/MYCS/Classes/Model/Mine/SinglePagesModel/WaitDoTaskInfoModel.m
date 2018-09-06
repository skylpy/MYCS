//
//  WaitDoTaskInfoModel.m
//  SWWY
//
//  Created by GuoChenghao on 15/2/11.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "WaitDoTaskInfoModel.h"
#import "SCBModel.h"

@implementation WaitDoTaskInfoModel

+ (void)requestTaskInfoWithUserID:(NSString *)userID courseID:(NSString *)courseID taskID:(NSString *)taskID success:(void (^)(WaitDoTaskInfoModel *taskInfo))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:GETTASKINFO_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:courseID forKey:@"course_id"];
    [params setObjectNilToEmptyString:taskID forKey:@"task_id"];
    
    [SCBModel BPOST:path parameters:params encrypt:NO success:^(SCBModel *model) {
        
        NSError *error;
        WaitDoTaskInfoModel *modelTemp = [[WaitDoTaskInfoModel alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(modelTemp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
