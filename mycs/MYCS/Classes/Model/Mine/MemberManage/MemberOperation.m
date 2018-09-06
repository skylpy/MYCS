//
//  MemberOperation.m
//  SWWY
//
//  Created by GuoChenghao on 15/2/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "MemberOperation.h"
#import "SCBModel.h"

@implementation MemberOperation

+ (void)auditMemberWithUerId:(NSString*)userId userType:(NSString*)userType memberID:(NSString *)memberID audit:(NSString *)audit reason:(NSString *)reason success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    
    NSString *path = [HOST_URL stringByAppendingString:MEMBER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:@"audit" forKey:@"action"];
    [params setObjectNilToEmptyString:memberID forKey:@"id"];
    [params setObjectNilToEmptyString:audit forKey:@"audit"];
    [params setObjectNilToEmptyString:reason forKey:@"reason"];

    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)requestContactWithUserId:(NSString*)userId userType:(NSString*)userType success:(void (^)(NSString *contactName, NSString *phone))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:MEMBER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:@"apply" forKey:@"action"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        if (success) {
            success([model.data objectForKey:@"contact"], [model.data objectForKey:@"phone"]);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)submitWithUserId:(NSString*)userId userType:(NSString*)userType action:(NSString *)action gradeId:(NSString*)gradeId year:(NSString *)year staff:(NSString *)staff success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:MEMBER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:gradeId forKey:@"gradeId"];
    if (year) {
        [params setObjectNilToEmptyString:year forKey:@"year"];
    }
    if (staff) {
        [params setObjectNilToEmptyString:staff forKey:@"staff"];
    }
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
