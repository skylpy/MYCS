//
//  MembershipServiceDetail.m
//  SWWY
//
//  Created by GuoChenghao on 15/2/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "MembershipServiceDetail.h"
#import "SCBModel.h"

@implementation MembershipServiceDetail

+ (void)requestMembershipServiceDetailWithUerId:(NSString*)userId userType:(NSString*)userType memberID:(NSString *)memberID success:(void (^)(MembershipServiceDetail *memberDetail))success failure:(void (^)(NSError *error))failure
{
    
    NSString *path = [HOST_URL stringByAppendingString:MEMBER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:@"detail" forKey:@"action"];
    [params setObjectNilToEmptyString:memberID forKey:@"id"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        MembershipServiceDetail *temp = [[MembershipServiceDetail alloc] initWithDictionary:model.data error:&error];
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
