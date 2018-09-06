//
//  ServiceModel.m
//  SWWY
//
//  Created by 黄希望 on 15-2-10.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "ServiceModel.h"
#import "SCBModel.h"

@implementation ServiceModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"ID"}];
}

+ (void)listWithUserId:(NSString*)userId
              userType:(NSString*)userType
                action:(NSString*)action
               success:(void (^)(NSArray *list))success
               failure:(void (^)(NSError *error))failur{
    NSString *path = [HOST_URL stringByAppendingString:MEMBER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId) {
        [params setObject:userId forKey:@"userId"];
    }
    if (action) {
        [params setObject:action forKey:@"action"];
    }
    if (userType) {
        [params setObject:userType forKey:@"userType"];
    }
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *list = [ServiceModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failur) {
            failur(error);
        } else if (success) {
            success(list);
        }
    } failure:^(NSError *error) {
        if (failur) {
            failur(error);
        }
    }];
}

@end

@implementation Mem

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"uid":@"ID"}];
}

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+ (void)listWithUserId:(NSString*)userId
              userType:(NSString*)userType
                action:(NSString*)action
               keyword:(NSString*)keyword
               success:(void (^)(NSArray *list))success
               failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:MEMBER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId) {
        [params setObject:userId forKey:@"userId"];
    }
    if (action) {
        [params setObject:action forKey:@"action"];
    }
    if (userType) {
        [params setObject:userType forKey:@"userType"];
    }
    [params setObject:keyword.length>0 ? keyword : @"" forKey:@"keyword"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *list = [Mem arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
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
