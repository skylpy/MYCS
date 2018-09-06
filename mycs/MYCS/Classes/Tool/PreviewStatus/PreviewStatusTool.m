//
//  PreviewStatusTool.m
//  MYCS
//
//  Created by AdminZhiHua on 16/3/23.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "PreviewStatusTool.h"
#import "AFNetworking.h"
#import "SCBModel.h"

@implementation PreviewStatusTool

+ (void)fectchStaticsIsOpenView:(void (^)(BOOL))block {
    NSString *urlStr = [HOST_URL stringByAppendingString:USERCENTER_PATH];
    
    User *user = [AppManager sharedManager].user;
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"]           = @"deviceStatus";
    params[@"userId"]           = user.uid;
    params[@"userType"]         = @(user.userType);
    params[@"staffAdmin"]       = user.isAdmin;
    
    [SCBModel BPOST:urlStr parameters:params encrypt:YES success:^(SCBModel *model) {
        
        BOOL isOpenView = [model.data[@"status"] boolValue];
        
        [[NSUserDefaults standardUserDefaults] setBool:isOpenView forKey:STATICSOPENVIEW];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (block)
        {
            block(isOpenView);
        }
        
    }failure:^(NSError *error){
        
    }];
    
}

@end
