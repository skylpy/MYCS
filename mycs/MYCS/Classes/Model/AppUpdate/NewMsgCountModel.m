//
//  checkNewMsgAndTask.m
//  SWWY
//
//  Created by Yell on 15/5/21.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "NewMsgCountModel.h"
#import "SCBModel.h"

@interface NewMsgCountModel ()

@end

@implementation NewMsgCountModel

+(void)checkUpdateWithUserID:(NSString *)userID userType:(NSString *)userType  Success:(void (^)(NewMsgCountModel *model))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:VIDEOCLASSIFY_PATH];

    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"tips" forKey:@"action"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NewMsgCountModel *temp = [[NewMsgCountModel alloc] initWithDictionary:model.data error:&error];
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
