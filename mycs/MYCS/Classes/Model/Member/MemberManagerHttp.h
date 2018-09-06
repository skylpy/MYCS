//
//  MemberManagerHttp.h
//  SWWY
//
//  Created by zhihua on 15/5/10.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberInfo.h"

@interface MemberManagerHttp : NSObject

/**
 *  会员列表
 *
 *  @param action 参数值固定为： getPersonalMember(获取个人会员)        getCompanyMember(获取企业会员)
 */
+ (void)getMemberDetail:(NSString *)userID userType:(NSString *)userType action:(NSString *)action page:(int) page pageSize:(int)pageSize success:(void (^)(NSArray *memberDetailList))success failure:(void(^)(NSError *error))failure;

@end
