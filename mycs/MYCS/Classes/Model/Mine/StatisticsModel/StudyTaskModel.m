//
//  StudyTaskModel.m
//  SWWY
//
//  Created by GuoChenghao on 15/2/9.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "StudyTaskModel.h"
#import "SCBModel.h"

@implementation StudyTaskModel

+ (void)requestStudyTaskListWithUserID:(NSString *)userID userType:(NSString *)userType month:(NSString *)month page:(NSUInteger)page pageSize:(NSString *)pageSize success:(void (^)(NSArray *studyTaskList))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:STATISTICS_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:month forKey:@"month"];
    [params setObjectNilToEmptyString:@"studyTaskLog" forKey:@"action"];
    [params setObjectNilToEmptyString:@(page) forKey:@"page"];
    [params setObjectNilToEmptyString:pageSize forKey:@"pageSize"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *list = [StudyTaskModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(list);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end
