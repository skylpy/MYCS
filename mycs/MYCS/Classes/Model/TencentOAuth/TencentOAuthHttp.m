//
//  TencentOAuthHttp.m
//  SWWY
//
//  Created by zhihua on 15/5/13.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "TencentOAuthHttp.h"
#import "AppManager.h"
#import "SCBModel.h"
#import "MJExtension.h"
#import "DeviceInfoTool.h"

@implementation OAuthResult


@end

@implementation TencentOAuthHttp


+ (void)thirPartBundlingWithUserID:(NSString *)userID QQopenID:(NSString *)openID accessToken:(NSString *)accessToken nickName:(NSString *)nickName bundingType:(NSString *)type success:(void(^)(SCBModel *model))success failure:(void(^)(NSError *error))failure{
    
    NSString *path = [HOST_URL stringByAppendingString:OAUTH_LOGIN_PATH];
    
    NSMutableDictionary *paramDict = [NSMutableDictionary dictionary];
    
    paramDict[@"device"] = @"4";
    paramDict[@"userId"] = userID;
    paramDict[@"openId"] = openID;
    paramDict[@"accessToken"] = accessToken;
    paramDict[@"loginType"] = type;
    paramDict[@"thusername"] = nickName;
    
    [SCBModel BPOST:path parameters:paramDict encrypt:YES success:^(SCBModel *model) {
        
        if (success) {
            success(model);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

+ (void)qqOAuthLogin:(NSString *)openId accessToken:(NSString *)accessToken nickName:(NSString *)nickName bundingType:(NSString *)type success:(void(^)(User *user))success failure:(void(^)(NSError *error))failure
{
    
    NSString *path = [HOST_URL stringByAppendingString:OAUTH_LOGIN_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"device"] = @"4";
    params[@"openId"] = openId;
    params[@"accessToken"] = accessToken;
    params[@"loginType"] = type;
    params[@"thusername"] = nickName;
    
    //收集设备信息
    params[@"cpuInfo"] = [DeviceInfoTool cpuModel];
    params[@"ramInfo"] = [DeviceInfoTool totalMemoryInfo];
    params[@"sysInfo"] = [DeviceInfoTool systemVersion];
    params[@"macInfo"] = [DeviceInfoTool macAddress];
    params[@"machineType"] = [DeviceInfoTool deviceVersion];
    params[@"appVern"] = [DeviceInfoTool appVersion];

    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        User *userModel = [[User alloc] initWithDictionary:model.data error:&error];
        
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(userModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//接口地址：  http://www.mswy.com/app/apps/AppthirdLogin.php
//请求方式：
//POST || GET
//参数：
//device 3 固定值 表示android客户端
//userId  用户id
//action unbind 解绑操作流程控制标识
//
//返回值：
//code : 1 表示成功 其他表示错误
+ (void)thirdPartUnBundlingWithUserID:(NSString *)userID bundType:(NSString *)type success:(void(^)(SCBModel *model))success failure:(void(^)(NSError *error))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"device"] = @"4";
    param[@"action"] = @"unbind";
    param[@"userId"] = userID;
    param[@"loginType"] = type;

    NSString *path = [HOST_URL stringByAppendingString:OAUTH_LOGIN_PATH];

    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        if (success) {
            success(model);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

@end
