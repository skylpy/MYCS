//
//  UMengHelper.h
//  SWWY
//
//  Created by AdminZhiHua on 15/11/9.
//  Copyright © 2015年 GuoChenghao. All rights reserved.
//

#import <UIKit/UIKit.h>

///ThirdPartService是对第三方框架的封装
@interface UMengHelper : NSObject

///处理程序跳转的URL
+ (BOOL)handleOpenURL:(NSURL *)url;

///分享--image参数可以是UIImage类型，也可以是NSString类型的URL-传nil显示默认logo
+ (void)shareWith:(NSString *)title content:(NSString *)content shareUrl:(NSString *)url shareImage:(UIImage *)image viewController:(UIViewController *)vc;

+ (void)shareImageWith:(UIImage *)image title:(NSString *)title content:(NSString *)content shareType:(NSString *)type;

+ (void)shareUrlWith:(UIImage *)image title:(NSString *)title content:(NSString *)content Url:(NSString *)shareUrl shareType:(NSString *)type;

///判断是否安装QQ
+ (BOOL)isInstallQQPlatform;

///判断是否安装微信
+ (BOOL)isInstallWechatPlatform;

+ (BOOL)isInstallWeiBoPlatform;

///QQ登陆
+ (void)tencentLoginWith:(UIViewController *)loginVC successHandler:(void (^)(NSString *openId, NSString *token, NSString *nickName))handler;

///微信登录
+ (void)wechatLoginWith:(UIViewController *)loginVC successHandler:(void (^)(NSString *openId, NSString *token, NSString *nickName))handler;

@end
