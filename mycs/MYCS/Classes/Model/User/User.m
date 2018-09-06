//
//  User.m
//  SWWY
//
//  Created by GuoChenghao on 15/1/8.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "User.h"
#import "SCBModel.h"
#import "MJExtension.h"
#import "NSString+Util.h"
#import "DeviceInfoTool.h"

@implementation User

MJCodingImplementation

+ (void)loginWithUserName:(NSString *)userName password:(NSString *)password success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:LOGIN_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
// MD5加密后的密码
//    NSMutableString * key = [NSMutableString stringWithString:password];
//    NSString * md5key = [key MD5];
//    [params setObject:md5key forKey:@"password"];
    params[@"username"] = userName;
    params[@"password"] = password;
    
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

+ (void)registWithUserInformation:(NSDictionary *)userInformation success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:REGIST_PATH];
    
    [SCBModel BPOST:path parameters:userInformation encrypt:YES success:^(SCBModel *model) {
        
        User *userModel = [[User alloc] initWithDictionary:model.data error:nil];
        
        success(userModel);
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)sendMobileSmsWithPhone:(NSString *)phone action:(NSString *)action success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:SENDSMS_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:phone forKey:@"phone"];
    [params setObject:action forKey:@"action"];
    
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

+ (void)uploadIdentityCardAndMaterial:(NSString *)imageDataStr success:(void (^)(NSString *tmpId))success failure:(void(^)(NSError *error))failure {
    
    NSString *path = [HOST_URL stringByAppendingString:UPLOADTOPPHOTO];
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"uploadPicture";
    param[@"uploadPhotoData"] = imageDataStr;
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        NSString *tempId = model.data[@"tmpId"];
        if (success)
        {
            success(tempId);
        }
        
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    
}

@end













