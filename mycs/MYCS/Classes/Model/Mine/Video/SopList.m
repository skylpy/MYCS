//
//  SopList.m
//  SWWY
//
//  Created by 黄希望 on 15-1-14.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "SopList.h"
#import "SCBModel.h"

@implementation Sop
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"sopId"}];
}

@end

@implementation SopList

+ (void)sopListWithUserId:(NSString *)userId
                 userType:(NSString *)userType
                   action:(NSString *)action
                   keyword:(NSString *)keyword
                    vipId:(NSString *)vipIdStr
                   cateId:(NSString *)cateIdStr
                 pageSize:(int)pageSize
                     page:(int)page
                fromCache:(BOOL)isFromCache
                  success:(void (^)(SopList *sopList))success
                  failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
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
    //新增分类参数
    if (vipIdStr) {
        [params setObject:vipIdStr forKey:@"vipId"];
    }
    if (cateIdStr) {
        [params setObject:cateIdStr forKey:@"cateId"];
    }
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(page) forKey:@"page"];
    if (keyword) {
        
        [params setObject:keyword forKey:@"keyword"];
    }
    if ([AppManager sharedManager].user.isAdmin.intValue == 1)
    {
        [params setObject:@"1" forKey:@"staffAdmin"];
    }
    else
    {
        [params setObject:@"0" forKey:@"staffAdmin"];
    }
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        SopList *sopModel = [[SopList alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(sopModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end
