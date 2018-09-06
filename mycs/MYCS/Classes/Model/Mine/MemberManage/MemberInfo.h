//
//  MemberDetail.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/13.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "GradeModel.h"

@interface MemberInfo : JSONModel

/**
 *  机构的会员详情与企业的会员详情共用
 */
@property (strong, nonatomic) NSString<Optional> *realname; //会员名称
@property (strong, nonatomic) NSString<Optional> *introduction; //会员简介
@property (strong, nonatomic) NSString<Optional> *avatar; //会员头像
@property (strong, nonatomic) NSArray<GradeModel, Optional> *list; //服务列表

/**
 *  机构服务列表, 只在企业或个人角色的会员详情返回
 */
@property (strong, nonatomic) NSArray<GradeModel, Optional> *gradeList; //机构服务列表, 只在企业或个人角色返回


/**
 *  机构--会员详情
 *
 *  @param userId   登录用户id
 *  @param userType 登录用户的类型
 *  @param memberUID 会员UID
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)requestMemberDetailWithUerId:(NSString*)userId userType:(NSString*)userType memberUID:(NSString *)memberUID success:(void (^)(MemberInfo *memberDetail))success failure:(void (^)(NSError *error))failure;

/**
 *  个人，企业--会员详情
 *
 *  @param userId   登录用户id
 *  @param userType 登录用户的类型
 *  @param agencyID 机构UID
 *  @param success  成功返回块
 *  @param failure  失败返回块
 */
+ (void)requestPersonalMemberDetailWithUerId:(NSString*)userId userType:(NSString*)userType agencyID:(NSString *)agencyID success:(void (^)(MemberInfo *memberDetail))success failure:(void (^)(NSError *error))failure;

@end
