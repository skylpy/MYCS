//
//  messageSendParam.h
//  SWWY
//
//  Created by zhihua on 15/4/22.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface messageSendParam : NSObject

//userId        登陆用户id
@property (nonatomic,copy) NSString *userId;
//userType      登录用户的类型
@property (nonatomic,copy) NSString *userType;
//authKey       参数加密验证码
@property (nonatomic,copy) NSString *authKey;
//action        固定：send
@property (nonatomic,copy) NSString *action;
//username 邮箱或者是昵称
@property (nonatomic,copy) NSString *username;
//content       消息内容
@property (nonatomic,copy) NSString *content;
//title         消息标题
@property (nonatomic,copy) NSString *title;

@end
