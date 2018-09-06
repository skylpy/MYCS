//
//  TencentOAuthHttp.h
//  SWWY
//
//  Created by zhihua on 15/5/13.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OAuthResult : NSObject

@property (nonatomic,copy) NSString *lgid;

@property (nonatomic,copy) NSString *uid;

@property (nonatomic,copy) NSString *username;

@property (nonatomic,copy) NSString *thusername;

@property (nonatomic,copy) NSString *type;

@property (nonatomic,copy) NSString *ctime;

@property (nonatomic,copy) NSString *token;

@property (nonatomic,copy) NSString *openid;

@end

@class User,SCBModel;

@interface TencentOAuthHttp : NSObject

/**
 *  QQ绑定
 *
 *  @param userID      <#userID description#>
 *  @param openID      <#openID description#>
 *  @param accessToken <#accessToken description#>
 *  @param success     <#success description#>
 *  @param failure     <#failure description#>
 */
+ (void)thirPartBundlingWithUserID:(NSString *)userID QQopenID:(NSString *)openID accessToken:(NSString *)accessToken nickName:(NSString *)nickName bundingType:(NSString *)type success:(void(^)(SCBModel *model))success failure:(void(^)(NSError *error))failure;

/**
 *  第三方授权登录
 *
 *  @param openId      用户开放id
 *  @param accessToken 第三方用户令牌
 *  @param success     授权成功的回调
 *  @param failure     授权失败的回调
 */
+ (void)qqOAuthLogin:(NSString *)openId accessToken:(NSString *)accessToken nickName:(NSString *)nickName bundingType:(NSString *)type success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure;

/**< QQ解绑 */
+ (void)thirdPartUnBundlingWithUserID:(NSString *)userID bundType:(NSString *)type success:(void(^)(SCBModel *model))success failure:(void(^)(NSError *error))failure;


@end
