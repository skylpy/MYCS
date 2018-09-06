//
//  DoctorModel.m
//  SWWY
//
//  Created by Yell on 15/6/19.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "DoctorModel.h"
#import "SCBModel.h"

@implementation DoctorListModel


@end

@implementation DoctorVideoCenterModel


@end

@implementation DoctorModel

+ (void)doctorListsWithpage:(int)page pageSize:(int)pageSize UserID:(NSString *)userId keyWord:(NSString *)keyWord fromCache:(BOOL)isFromeCache success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure                  {
    
    NSString *path = [HOST_URL stringByAppendingString:DOCTOR_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObjectNilToEmptyString:[AppManager hasLogin] == YES ?[AppManager sharedManager].user.uid:@"" forKey:@"userId"];
    [params setObjectNilToEmptyString:keyWord forKey:@"keyword"];
    [params setObjectNilToEmptyString:@"list" forKey:@"action"];
    [params setObjectNilToEmptyString:@(page) forKey:@"page"];
    [params setObjectNilToEmptyString:@(pageSize) forKey:@"pageSize"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        
        NSArray *array = [DoctorListModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(array);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)RequestWithPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(NSArray *list))success
                failure:(void (^)(NSError *error))failure{
    
    
    
}

+ (void)doctorListsWithcheckID:(NSString *)checkID page:(int)page pageSize:(int)pageSize success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    NSString *path = [HOST_URL stringByAppendingString:OFFICEAPI_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"doctorList";
    params[@"checkUid"] = checkID;
    params[@"page"] = @(page);
    params[@"pageSize"] = @(pageSize);
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        
        NSArray *array = [DoctorListModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(array);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


+ (void)doctorVideoCenterWithDoctorUid:(NSString *)uid agroup_id:(NSString *)agroup_id success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    NSString *path = [HOST_URL stringByAppendingString:DOCTOR_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:@"videoCenter" forKey:@"action"];
    [params setObjectNilToEmptyString:uid forKey:@"doctorUid"];
    [params setObjectNilToEmptyString:agroup_id forKey:@"agroup_id"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        
        NSArray *array = [DoctorVideoCenterModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(array);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end
