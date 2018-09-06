//
//  MemberDetail.m
//  SWWY
//
//  Created by GuoChenghao on 15/2/13.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "MemberInfo.h"
#import "SCBModel.h"

@implementation MemberInfo

+ (void)requestMemberDetailWithUerId:(NSString*)userId userType:(NSString*)userType memberUID:(NSString *)memberUID success:(void (^)(MemberInfo *memberDetail))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:MEMBER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:@"memberInfo" forKey:@"action"];
    [params setObjectNilToEmptyString:memberUID forKey:@"uid"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        MemberInfo *temp = [[MemberInfo alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(temp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)requestPersonalMemberDetailWithUerId:(NSString*)userId userType:(NSString*)userType agencyID:(NSString *)agencyID success:(void (^)(MemberInfo *memberDetail))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:MEMBER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:@"detail" forKey:@"action"];
    [params setObjectNilToEmptyString:agencyID forKey:@"agencyId"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        MemberInfo *temp = [[MemberInfo alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(temp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
