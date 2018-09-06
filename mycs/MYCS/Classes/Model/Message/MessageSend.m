//
//  MessageSend.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MessageSend.h"
#import "SCBModel.h"

@implementation MessageSend

+ (void)messageSendWith:(NSString *)title content:(NSString *)content toUID:(NSString *)toUId Success:(void (^)(void))success failure:(void (^)(NSError *))failure {
    
    NSString *path = [HOST_URL stringByAppendingString:INBOXLIST_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"send";
    params[@"content"] = content;
    params[@"deptId"] = @"";
    params[@"title"] = title;
    params[@"toUid"] = toUId;
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"userType"] = @([AppManager sharedManager].user.userType);
    params[@"toUid"] = toUId;

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
