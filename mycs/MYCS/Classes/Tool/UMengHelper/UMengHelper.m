//
//  UMengHelper.m
//  SWWY
//
//  Created by AdminZhiHua on 15/11/9.
//  Copyright © 2015年 GuoChenghao. All rights reserved.
//

#import "UMengHelper.h"

#import <UMengSocial/UMSocial.h>
#import <UMengSocial/UMSocialWechatHandler.h>
#import <UMengSocial/UMSocialQQHandler.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <WXApi.h>
#import "WeiboSDK.h"

@implementation UMengHelper

+ (void)load {
    //友盟分享
    NSString *urlStr = @"http://www.mycs.cn";

    [UMSocialData setAppKey:@"552e119cfd98c5008e0006c8"];

    [UMSocialWechatHandler setWXAppId:@"wxa66a8c1079d76ed3" appSecret:@"85c4402233ca341654a21efaa024b954" url:urlStr];

    [UMSocialQQHandler setQQWithAppId:@"1104824217" appKey:@"2mAImnJdCgIa9IxF" url:urlStr];
}

///处理程序跳转的URL
+ (BOOL)handleOpenURL:(NSURL *)url {
    return [UMSocialSnsService handleOpenURL:url];
}

+ (void)shareWith:(NSString *)title content:(NSString *)content shareUrl:(NSString *)url shareImage:(UIImage *)image viewController:(UIViewController<UMSocialUIDelegate> *)vc {
    if (!image)
    {
        image = [UIImage imageNamed:@"sharedefault"];
    }

    [self configureShareTitle:title shareContent:content shareImageUrl:nil shareUrl:url];

    [UMSocialSnsService presentSnsIconSheetView:vc appKey:@"552e119cfd98c5008e0006c8" shareText:title shareImage:image shareToSnsNames:[self getInstallPlatforms] delegate:vc];
}

+ (void)shareImageWith:(UIImage *)image title:(NSString *)title content:(NSString *)content shareType:(NSString *)type {
    [self configureShareTitle:nil shareContent:nil shareImageUrl:nil shareUrl:nil];

    [UMSocialData defaultData].extConfig.wxMessageType        = UMSocialWXMessageTypeImage;
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;

    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[ type ] content:content image:image location:nil urlResource:nil presentedController:nil completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess)
        {
            NSLog(@"分享成功！");
        }
    }];
}
+(void)shareUrlWith:(UIImage *)image title:(NSString *)title content:(NSString *)content Url:(NSString *)shareUrl shareType:(NSString *)type
{
    if (!image)
    {
        image = [UIImage imageNamed:@"sharedefault"];
    }
    [self configureShareTitle:title shareContent:content shareImageUrl:nil shareUrl:shareUrl];

    UMSocialUrlResource *resource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeDefault url:shareUrl];
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[ type ] content:content image:image location:nil urlResource:resource presentedController:nil completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess)
        {
            NSLog(@"分享成功！");
        }
    }];
}
///配置友盟分享的内容
+ (void)configureShareTitle:(NSString *)title shareContent:(NSString *)content shareImageUrl:(NSString *)imageUrl shareUrl:(NSString *)url {
    //标题的设置
    [UMSocialData defaultData].extConfig.qqData.title             = title;
    [UMSocialData defaultData].extConfig.wechatSessionData.title  = title;
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = title;
    [UMSocialData defaultData].extConfig.qzoneData.title          = title;

    //内容的设置
    [UMSocialData defaultData].extConfig.qqData.shareText             = content;
    [UMSocialData defaultData].extConfig.wechatSessionData.shareText  = content;
    [UMSocialData defaultData].extConfig.wechatTimelineData.shareText = content;
    [UMSocialData defaultData].extConfig.qzoneData.shareText          = content;

    //url的设置
    [UMSocialData defaultData].extConfig.wechatSessionData.url  = url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.qqData.url             = url;
    [UMSocialData defaultData].extConfig.qzoneData.url          = url;

    //分享类型的设置
    [UMSocialData defaultData].extConfig.wxMessageType        = UMSocialWXMessageTypeWeb;
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
}

///获取已经安装的第三方平台
+ (NSArray *)getInstallPlatforms {
    NSMutableArray *arr = [NSMutableArray array];

    if ([WXApi isWXAppInstalled])
    {
        [arr addObject:UMShareToWechatSession];
        [arr addObject:UMShareToWechatTimeline];
    }

    if ([TencentApiInterface isTencentAppInstall:kIphoneQQ])
    {
        [arr addObject:UMShareToQQ];
        [arr addObject:UMShareToQzone];
    }

    return arr;
}

///判断是否安装QQ
+ (BOOL)isInstallQQPlatform {
    return [TencentApiInterface isTencentAppInstall:kIphoneQQ];
}

+ (BOOL)isInstallWechatPlatform {
    return [WXApi isWXAppInstalled];
}

+ (BOOL)isInstallWeiBoPlatform {
    return [WeiboSDK isWeiboAppInstalled];
}

///使用友盟进行QQ登陆
+ (void)tencentLoginWith:(UIViewController *)loginVC successHandler:(void (^)(NSString *openId, NSString *token, NSString *nickName))handler {
    [self UMengLoginWith:loginVC snsType:UMSocialSnsTypeMobileQQ successHandler:handler];
}

+ (void)wechatLoginWith:(UIViewController *)loginVC successHandler:(void (^)(NSString *, NSString *, NSString *nickName))handler {
    [self UMengLoginWith:loginVC snsType:UMSocialSnsTypeWechatSession successHandler:handler];
}

+ (void)UMengLoginWith:(UIViewController *)loginVC snsType:(UMSocialSnsType)type successHandler:(void (^)(NSString *openId, NSString *token, NSString *nickName))handler {
    NSString *platformName = [UMSocialSnsPlatformManager getSnsPlatformString:type];

    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];

    snsPlatform.loginClickHandler(loginVC, [UMSocialControllerService defaultControllerService], YES, ^(UMSocialResponseEntity *response) {

        if (response.responseCode == UMSResponseCodeSuccess)
        {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];

            if (handler)
            {
                handler(snsAccount.usid, snsAccount.accessToken, snsAccount.userName);
            }
        }
    });
}


@end
