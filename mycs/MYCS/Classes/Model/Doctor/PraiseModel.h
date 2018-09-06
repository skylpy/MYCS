//
//  PraiseModel.h
//  SWWY
//
//  Created by zhihua on 15/7/3.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PraiseModel : NSObject

//authKey       参数加密验证码
//action     固定参数changePraise
//userId    进行 点赞/取消点赞 用户的id
//target_type    被 点赞/取消点赞 对象类型，0--名医业界评价,1--交流评论类型点赞
//target_id    被 点赞/取消点赞 对象id，类型按target_type
+ (void)praiseWithUseID:(NSString *)userID
            target_type:(int)target_type
              target_id:(NSString *)target_id
                success:(void (^)(void))success
                failure:(void (^)(NSError *error))failure;

@end
