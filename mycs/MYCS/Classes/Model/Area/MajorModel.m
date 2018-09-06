//
//  MajorModel.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/16.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "MajorModel.h"
#import "SCBModel.h"

@implementation MajorModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"key": @"modelID"}];
}

+ (void)requestMajorSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:MAJOR_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"getAll" forKey:@"action"];
    [params setObject:@"app" forKey:@"from"];
    
    [SCBModel BPOST:path parameters:params encrypt:NO success:^(SCBModel *model) {
        NSError *error;
        NSArray *modelList = [MajorModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
                
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(modelList);
        }
    } failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
        if (failure) {
            failure(error);
        }
    }];
}

@end
