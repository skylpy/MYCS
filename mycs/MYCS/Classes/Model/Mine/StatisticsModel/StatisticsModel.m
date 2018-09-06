//
//  StatisticsModel.m
//  SWWY
//
//  Created by GuoChenghao on 15/2/4.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "StatisticsModel.h"
#import "SCBModel.h"

@implementation StatisticsModel

+ (void)requestStatisticsWithUserID:(NSString *)userID userType:(NSString *)userType month:(NSString *)month action:(NSString *)action success:(void (^)(StatisticsModel *statistics))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:STATISTICS_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:month forKey:@"month"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        StatisticsModel *modelTemp = [[StatisticsModel alloc] initWithDictionary:model.data error:&error];
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
