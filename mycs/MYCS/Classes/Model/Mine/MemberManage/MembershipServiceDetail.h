//
//  MembershipServiceDetail.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "EnumDefine.h"

@interface MembershipServiceDetail : JSONModel

@property (strong, nonatomic) NSString<Optional> *realname; //企业或个人名称
@property (strong, nonatomic) NSString<Optional> *phone; //电话
@property (strong, nonatomic) NSString<Optional> *year; //期限
@property (strong, nonatomic) NSString<Optional> *auditTime; //服务开始时间
@property (strong, nonatomic) NSString<Optional> *expireTime; //服务终止时间
@property (strong, nonatomic) NSString<Optional> *staff; //学员
@property (strong, nonatomic) NSString<Optional> *uid; //会员UID
@property (strong, nonatomic) NSNumber<Optional> *userType; //会员类型
@property (strong, nonatomic) NSNumber<Optional> *audit; //会员审核状态，0表示审核中，1表示审核通过，2表示已拒绝，3表示已过期
@property (strong, nonatomic) NSString<Optional> *gradeName; //服务名称
@property (strong, nonatomic) NSString<Optional> *detail; //服务介绍
@property (strong, nonatomic) NSString<Optional> *introduction; //企业介绍，当会员类型userType==5时才显示，个人会员不显示
@property (strong, nonatomic) NSString<Optional> *avatar; //会员头像

/**
 *  ======================【 服务详情 】=====================
 *
 *  @param userId   登录用户id
 *  @param userType 登录用户的类型
 *  @param memberID 会员ID
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)requestMembershipServiceDetailWithUerId:(NSString*)userId userType:(NSString*)userType memberID:(NSString *)memberID success:(void (^)(MembershipServiceDetail *memberDetail))success failure:(void (^)(NSError *error))failure;

@end
