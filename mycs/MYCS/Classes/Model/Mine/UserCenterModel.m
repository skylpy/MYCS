//
//  UserCenterModel.m
//  SWWY
//
//  Created by GuoChenghao on 15/1/22.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "UserCenterModel.h"
#import "SCBModel.h"
#import "AppManager.h"
#import "NSString+Util.h"
#import "MJExtension.h"
#import "SDWebImageManager.h"
#import "DataCacheTool.h"
#import "DeviceInfoTool.h"

@implementation UserCenterModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"position": @"position"}];

    
}
+ (void)requestUserCenterInformationWithUserID:(NSString *)userID userType:(NSString *)userType success:(void (^)(UserCenterModel *centerModel))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:USERCENTER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:@"userId"];
    [params setObject:userType forKey:@"userType"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        UserCenterModel *modelTemp = [[UserCenterModel alloc] initWithDictionary:model.data error:&error];
        
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(modelTemp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

    
    
}

+ (void)changeIntroWithUserID:(NSString *)userID userType:(NSString *)userType introduction:(NSString *)introduction success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:USERCENTER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:@"userId"];
    [params setObject:userType forKey:@"userType"];
    [params setObject:@"updateIntro" forKey:@"action"];
    [params setObject:introduction forKey:@"introduction"];
    
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


+ (void)changeManagerWithUserID:(NSString *)userID userType:(NSString *)userType contacts:(NSString *)contacts jobTitle:(NSString *)jobTitle position:(NSString *)position industryID:(NSString *)industryID success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:USERCENTER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:@"userId"];
    [params setObject:userType forKey:@"userType"];
    [params setObject:@"updateContacts" forKey:@"action"];
    [params setObject:contacts forKey:@"contacts"];
    [params setObject:jobTitle forKey:@"jobTitle"];
    [params setObject:position forKey:@"position"];
    [params setObject:industryID forKey:@"industryId"];
    
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

+ (void)changePasswordWithUserID:(NSString *)userID userType:(NSString *)userType oldPassword:(NSString *)oldPassword newPassword:(NSString *)passowrdNew success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:USERCENTER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:@"userId"];
    [params setObject:userType forKey:@"userType"];
    [params setObject:@"updatePassword" forKey:@"action"];
    
//    NSMutableString * oldkey = [NSMutableString stringWithString:oldPassword];
//    NSString * md5oldPWD = [oldkey MD5];
//    [params setObject:md5oldPWD forKey:@"oldPassword"];
    [params setObject:oldPassword forKey:@"oldPassword"];

    
    
//    NSMutableString * newkey = [NSMutableString stringWithString:passowrdNew];
//    NSString * md5newPWD = [newkey MD5];
//    [params setObject:md5newPWD forKey:@"newPassword"];
    [params setObject:passowrdNew forKey:@"newPassword"];

    
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

+ (void)forgetPasswordWithPhone:(NSString *)phone code:(NSString *)code newPassword:(NSString *)passowrdNew success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:USERCENTER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"updatePwd" forKey:@"action"];
//    NSMutableString * newkey = [NSMutableString stringWithString:passowrdNew];
//    NSString * md5newPWD = [newkey MD5];
//    [params setObject:md5newPWD forKey:@"newPwd"];
    [params setObject:passowrdNew forKey:@"newPwd"];

    [params setObject:phone forKey:@"mobile"];
    [params setObject:code forKey:@"code"];
    
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

+ (void)giveSuggestWithUserID:(NSString *)userID phoneNumber:(NSString *)phoneNumber suggestContent:(NSString *)content success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:SUGGEST_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:phoneNumber forKey:@"phone"];
    [params setObjectNilToEmptyString:content forKey:@"content"];

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

//userId        登录用户id
//userType      登录用户的类型
//authKey       参数加密验证码
//action        参数值固定为：updatePosition
//position      职位名

+ (void)editPositionWith:(NSString *)userId userType:(NSString *)userType positionName:(NSString *)position success:(void(^)(SCBModel *model))success filure:(void(^)(NSError *error))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"userId"] = userId;
    param[@"userType"] = userType;
    param[@"action"] = @"updatePosition";
    param[@"position"] = position;
    
    NSString *path = [HOST_URL stringByAppendingString:USERCENTER_PATH];
    
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


+ (void)changePlaceWithUserID:(NSString *)userID userType:(NSString *)userType areaId:(NSString *)areaId success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:USERCENTER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:@"userId"];
    [params setObject:userType forKey:@"userType"];
    [params setObject:@"updatePlace" forKey:@"action"];
    [params setObject:areaId forKey:@"areaId"];
    
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

+ (void)uploadPhotoDataWithuploadPhotoData:(NSString *)imageData success:(void (^)(NSString * str))success failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL stringByAppendingString:EDIT_IMAGE];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"userId"] = [AppManager sharedManager].user.uid;
    dict[@"uploadPhotoData"] = imageData;
    dict[@"type"] = @"avatar";

    [SCBModel BPOST:path parameters:dict encrypt:YES success:^(SCBModel *model) {
        
        success(model.data[@"userPic"]);
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

+(void)uploadTopPhotoDataWithuploadPhotoData:(NSString *)imageData success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
  
    NSString *path = [HOST_URL stringByAppendingString:UPLOADTOPPHOTO];
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"userId"] = [AppManager sharedManager].user.uid;
    dict[@"uploadPhotoData"] = imageData;
    dict[@"type"] = @"avatar";
    dict[@"userType"] = [NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType];
    dict[@"action"] = @"setCenterBanner";
    if ([AppManager sharedManager].user.isAdmin.intValue == 1)
    {
        [dict setObjectNilToEmptyString:@(1) forKey:@"staffAdmin"];
    }else
    {
      [dict setObjectNilToEmptyString:@(0) forKey:@"staffAdmin"];
    }
    
    [SCBModel BPOST:path parameters:dict encrypt:YES success:^(SCBModel *model) {
        
        success(model.data[@"picUrl"]);
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

+ (void)updateWorkTimeWithUserID:(NSString *)userID userType:(NSString *)userType startTime:(NSString *)startTime endTime:(NSString *)endTime success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{

    NSString *path = [HOST_URL stringByAppendingString:USERCENTER_PATH];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:@"userId"];
    [params setObject:userType forKey:@"userType"];
    [params setObject:@"updateWorkTime" forKey:@"action"];
    [params setObject:startTime forKey:@"wt_start"];
    [params setObject:endTime forKey:@"wt_end"];

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
+ (void)sendCodeInUserCenterWithPhone:(NSString *)phone validCode:(NSString *)validCode action:(NSString *)action success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:SENDSMS_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:action forKey:@"action"];
    [params setObject:phone forKey:@"phone"];
    [params setObject:validCode forKey:@"captchaCode"];
    
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

+ (void)updateSkillWithUserID:(NSString *)userID userType:(NSString *)userType skill:(NSString *)skill success:(void (^)(void))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:USERCENTER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:userID forKey:@"userId"];
    [params setObject:userType forKey:@"userType"];
    [params setObject:@"updateSkill" forKey:@"action"];
    [params setObject:skill forKey:@"skill"];

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

//action                send
//authKey            参数加密验证码
//captchaCode    图片验证码
//phone               手机
//device               机器码
+(void)sendPhoneCaptchaCode:(NSString *)captchaCode Phone:(NSString *)phone andAction:(NSString *)action uccess:(void (^)(void))success failure:(void (^)(NSError *))failure{
  
    NSString *path = [HOST_URL stringByAppendingString:SENDSMS_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:action forKey:@"action"];
    [params setObject:captchaCode forKey:@"captchaCode"];
    [params setObject:phone forKey:@"phone"];
  
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

+(void)changeBindPhoneWithMobile:(NSString *)mobile Code:(NSString *)code userId:(NSString *)userId userType:(NSString *)userType uccess:(void (^)(void))success failure:(void (^)(NSError *))failure{

    NSString *path = [HOST_URL stringByAppendingString:BINDPHONE_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"updateMobile" forKey:@"action"];
    [params setObject:mobile forKey:@"mobile"];
    [params setObject:code forKey:@"code"];
    [params setObject:userId forKey:@"userId"];
    [params setObject:userType forKey:@"userType"];
    
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
/**
 *  发送邮箱验证码
 *
 *  @param email   邮箱地址
 *  @param success 成功的返回
 *  @param failure 失败返回
 */
+ (void)sendCodeWithEmail:(NSString *)email andType:(NSString *)type success:(void (^)(void))success failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL stringByAppendingString:SENDEMAIL_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:email forKey:@"email"];
    [params setObject:type forKey:@"type"];
    
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


+(void)changeBindEmailWithEmail:(NSString *)email Code:(NSString *)code userId:(NSString *)userId userType:(NSString *)userType uccess:(void (^)(void))success failure:(void (^)(NSError *))failure{

    NSString *path = [HOST_URL stringByAppendingString:USERCENTER_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"updateEmail" forKey:@"action"];
    [params setObject:email forKey:@"email"];
    [params setObject:code forKey:@"code"];
    [params setObject:userId forKey:@"userId"];
    [params setObject:userType forKey:@"userType"];
    
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

@implementation ProfileFocus

+ (void)profileFocusListWithSuccess:(void (^)(NSArray *focusList))success failure:(void (^)(NSError *))failure {
    
    NSString *path = [HOST_URL stringByAppendingString:SETPAGE_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"index";
    
   params[@"version"] = [NSString stringWithFormat:@"v%@", [DeviceInfoTool appVersion]];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        ProfileFocus *focusModel = [ProfileFocus objectWithKeyValues:model.data];
        
        if (success)
        {
            success(focusModel.focus);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

+ (void)loadAdPic {
    
    NSString *path = [HOST_URL stringByAppendingString:SETPAGE_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    params[@"action"] = @"index";
    
    params[@"version"] = [NSString stringWithFormat:@"v%@", [DeviceInfoTool appVersion]];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        ProfileFocus *focusModel = [ProfileFocus objectWithKeyValues:model.data];
        
        if (focusModel.adPicture)
        {
            Adpicture *adPic = [focusModel.adPicture firstObject];
            if (!adPic.imageSrc)
            {
                [DataCacheTool clearAdpictureData];
                return;
            }
            //下载图片
            [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:adPic.imageSrc] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                //将image缓存到本地
                [[SDImageCache sharedImageCache] storeImage:image forKey:adPic.imageSrc];
            }];
            
            [DataCacheTool saveAdpictureDataWithModel:adPic.param AdImageURL:adPic.imageSrc];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

+ (NSDictionary *)objectClassInArray{
    return @{@"focus" : [Focus class], @"adPicture" : [Adpicture class]};
}

@end

@implementation UserBindModel


@end

@implementation Focus


@end


@implementation Adpicture

@end

@implementation Param


+ (void)InformationClickWithCheckUrl:(NSString *)url
                             success:(void (^)(Param *pama))success
                             failure:(void (^)(NSError *error))failure
{

    NSString *path = [HOST_URL stringByAppendingString:CLICKINFOMATION];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    params[@"action"] = @"index";
    
    [params setObjectNilToEmptyString:url forKey:@"url"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        Param *pama = [Param objectWithKeyValues:model.data];
        
        if (success)
        {
            success(pama);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }

        
    }];

}

@end









