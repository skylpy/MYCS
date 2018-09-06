//
//  OfficeModel.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/15.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "OfficeModel.h"
#import "SCBModel.h"


@implementation OfficeModel


+ (void)getOfficeListSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:REGOPTION_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"getOffice" forKey:@"action"];
    [params setObject:@"app" forKey:@"from"];
    
    [SCBModel BPOST:path parameters:params encrypt:NO success:^(SCBModel *model) {
        NSError *error;
        NSArray *modelList = [OfficeModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
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
