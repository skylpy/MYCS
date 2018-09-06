//
//  PraiseModel.m
//  SWWY
//
//  Created by zhihua on 15/7/3.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "PraiseModel.h"
#import "SCBModel.h"

@implementation PraiseModel


+ (void)praiseWithUseID:(NSString *)userID
            target_type:(int)target_type
              target_id:(NSString *)target_id
                success:(void (^)(void))success
    failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"changePraise";
    param[@"userId"] = userID;
    param[@"target_type"] = @(target_type);
    param[@"target_id"] = target_id;
    
    NSString *path = [HOST_URL stringByAppendingString:ACADEMICEXCHANGE];
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        if ([model.code intValue] == 1) {
            if (success) {
                success();
            }
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

@end
