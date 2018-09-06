//
//  PersonalMemberModel.m
//  SWWY
//
//  Created by GuoChenghao on 15/2/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "PersonalMemberModel.h"
#import "SCBModel.h"

@implementation PersonalMemberModel

+ (void)listWithUerId:(NSString*)userId
             userType:(NSString*)userType
               action:(NSString*)action
                 page:(int)page
             pageSize:(int)pageSize
              keyword:(NSString*)keyword // 个人 企业 搜机构时传
              success:(void (^)(NSArray *list))success
              failure:(void (^)(NSError *error))failure{
    
    NSString *path = [HOST_URL stringByAppendingString:MEMBER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userId forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:action forKey:@"action"];
    [params setObjectNilToEmptyString:@(page) forKey:@"page"];
    [params setObjectNilToEmptyString:@(pageSize) forKey:@"pageSize"];
    [params setObjectNilToEmptyString:keyword forKey:@"keyword"];

    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *array = [PersonalMemberModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
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
