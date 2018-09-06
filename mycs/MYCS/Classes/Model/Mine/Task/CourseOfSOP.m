//
//  CourseOfSOP.m
//  SWWY
//
//  Created by 黄希望 on 15-2-1.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "CourseOfSOP.h"
#import "SCBModel.h"

@implementation CourseOfSOP

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (void)dataWithUserId:(NSString*)userId
              userType:(NSString*)userType
                action:(NSString*)action
                 sopId:(NSString*)sopId
               success:(void (^)(NSArray *list))success
               failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:SOP_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:sopId forKey:@"id"];
    
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *list = [CourseOfSOP arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
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
