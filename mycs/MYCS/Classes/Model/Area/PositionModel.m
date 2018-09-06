//
//  PositionModel.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/16.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "PositionModel.h"
#import "SCBModel.h"

@implementation PositionModel


+ (void)requestPositionSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:REGOPTION_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"getHosPos" forKey:@"action"];
    [params setObject:@"app" forKey:@"from"];
    
    [SCBModel BPOST:path parameters:params encrypt:NO success:^(SCBModel *model) {
        NSError *error;
        NSArray *modelList = [PositionModel arrayOfModelsFromDictionaries:model.data[@"list"] error:&error];
        if (success) {
            success(modelList);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
