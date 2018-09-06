//
//  ActivityModel.m
//  MYCS
//
//  Created by AdminZhiHua on 15/9/25.
//  Copyright © 2015年 GuoChenghao. All rights reserved.
//

#import "ActivityModel.h"
#import "SCBModel.h"


@implementation ActivityModel

+ (void)joinActivityWith:(NSString *)userId activityId:(NSString *)activityId success:(void(^)())success failure:(void (^)(NSError *error))failure{
    
    NSString *path = [HOST_URL stringByAppendingString:ACTIVITY_PATH];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"join";
    param[@"activityId"] = activityId;
    param[@"userId"] = userId;
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        
        if (error) {
            failure(error);
        }
        
    }];
    
}

+ (void)shareCompleteWith:(NSString *)userId activityId:(NSString *)activityId success:(void(^)())success failure:(void (^)(NSError *error))failure {
    
    NSString *path = [HOST_URL stringByAppendingString:ACTIVITY_PATH];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"share";
    param[@"activityId"] = activityId;
    param[@"userId"] = userId;
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        
        if (error) {
            failure(error);
        }
        
    }];

}

@end


@implementation ActivityParamModel



@end

