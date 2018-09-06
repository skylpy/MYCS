//
//  VideoSpaceModel.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "VideoSpaceModel.h"
#import "SCBModel.h"
#import "MJExtension.h"
#import "TaskObject.h"

@implementation VideoSpaceModel


+ (void)videoListWith:(NSString *)urlPath Id:(NSString *)idstr vipId:(NSString *)vipIdStr keyword:(NSString *)keyword action:(NSString *)action page:(NSInteger)page Success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    NSString *path = [HOST_URL stringByAppendingString:urlPath];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"staffAdmin"] = [AppManager sharedManager].user.isAdmin;
    params[@"agroup_id"] = [AppManager sharedManager].user.agroup_id;
    NSLog(@"%@",params[@"agroup_id"]);
    params[@"Id"] = idstr;
    params[@"action"] = action;
    params[@"pageSize"] = @(10);
    params[@"page"] = @(page);
    params[@"userType"] = @([AppManager sharedManager].user.userType);
    params[@"vipId"] = vipIdStr;
//    params[@"cateId"] = idstr;
    if (keyword) {
        [params setObject:keyword forKey:@"keyword"];
    }
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSArray *arr = [VideoSpaceModel objectArrayWithKeyValuesArray:model.data[@"list"]];
        
        if (success)
        {
            success(arr);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (NSDictionary *)objectClassInArray{
    return @{@"children" : [ClassModel class]};
}

@end

@implementation ClassModel

+ (void)classListCategoryWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    NSString *path = [HOST_URL stringByAppendingString:CATEGORY_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"userType"] = @([AppManager sharedManager].user.userType);
    params[@"action"] = @"getCategorys";
    
    [SCBModel BGET:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSArray *arr = [ClassModel objectArrayWithKeyValuesArray:model.data[@"list"]];
        
        if (success)
        {
            success(arr);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


+ (void)classListWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    NSString *path = [HOST_URL_NOIOS stringByAppendingString:CUSTOM_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"userType"] = @([AppManager sharedManager].user.userType);
//    params[@"action"] = @"getCategorys";
    params[@"action"] = @"menuList";
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSArray *firstArr = [ClassModel objectArrayWithKeyValuesArray:model.data[@"firstMenu"]];
        NSArray *secondArr = [ClassModel objectArrayWithKeyValuesArray:model.data[@"secondMenu"]];
        
        NSMutableArray * arr = [NSMutableArray array];
        if (firstArr.count == 0) {
            
            [arr addObject:secondArr];
        }else{
        
            [arr addObject:firstArr];
            [arr addObject:secondArr];
        }

        if (success)
        {
            success(arr);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+(void)classOfficeListWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL_NOIOS stringByAppendingString:CUSTOM_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"userType"] = @([AppManager sharedManager].user.userType);
    params[@"action"] = @"menuList";
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSArray *secondArr = [ClassModel objectArrayWithKeyValuesArray:model.data[@"secondMenu"]];
        
        if (success)
        {
            success(secondArr);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

@end


@implementation SourceModel

+ (NSDictionary *)objectClassInArray{
    return @{@"children" : [SourceChildren class]};
}

+ (void)sourceListWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    
    NSString *path = [HOST_URL stringByAppendingString:POSTSYSTEM_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userId"] = [AppManager sharedManager].user.uid;
    
    params[@"action"] = @"getDept";
    params[@"userType"] = @([AppManager sharedManager].user.userType);
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
//        NSArray *arr = [SourceModel objectArrayWithKeyValuesArray:model.data[@"list"]];
        NSArray<TaskObject *> *arr = [TaskObject objectArrayWithKeyValuesArray:model.data[@"list"]];
        if (success)
        {
            success(arr);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end


@implementation SourceChildren

@end


