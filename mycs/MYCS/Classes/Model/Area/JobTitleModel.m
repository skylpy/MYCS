//
//  JobTitleModel.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/16.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "JobTitleModel.h"
#import "SCBModel.h"

@implementation JobTitleModel

+ (void)requestJobsTitleSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:REGOPTION_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"getJobTitle" forKey:@"action"];
    [params setObject:@"app" forKey:@"from"];
    
    [SCBModel BPOST:path parameters:params encrypt:NO success:^(SCBModel *model) {
        NSError *error;
        NSArray *modelList = [JobTitleModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(modelList);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
