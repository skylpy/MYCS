//
//  StaffModel.m
//  SWWY
//
//  Created by 黄希望 on 15-1-31.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "StaffModel.h"
#import "SCBModel.h"

@implementation StaffModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (void)dataWithUserId:(NSString*)userId
              userType:(NSString*)userType
                action:(NSString*)action
               keyword:(NSString*)keyword
               success:(void (^)(NSArray *list))success
               failure:(void (^)(NSError *error))failure{
    
    NSString *path = [HOST_URL stringByAppendingString:POSTSYSTEM_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:keyword forKey:@"keyword"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *modelList = [StaffModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
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
