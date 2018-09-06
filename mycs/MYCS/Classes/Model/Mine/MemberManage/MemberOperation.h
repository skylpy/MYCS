//
//  MemberOperation.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

/**
 *  会员管理操作接口
 */
@interface MemberOperation : JSONModel

/**
 *  =====【 会员审核 】======
 *
 *  @param userId   登录用户id
 *  @param userType 登录用户的类型
 *  @param memberID 会员ID
 *  @param audit    审核，其中通过审核：pass   拒绝审核：refuse
 *  @param reason   可选，拒绝理由，拒绝审核必需要传值
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)auditMemberWithUerId:(NSString*)userId userType:(NSString*)userType memberID:(NSString *)memberID audit:(NSString *)audit reason:(NSString *)reason success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/**
 *  ====【 会员申请、增加服务人数、延长服务时间，用于获取联系人信息 】====
 *
 *  @param userId   登录用户id
 *  @param userType 登录用户的类型
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)requestContactWithUserId:(NSString*)userId userType:(NSString*)userType success:(void (^)(NSString *contactName, NSString *phone))success failure:(void (^)(NSError *error))failure;

/**
 *  提交申请或增加服务人数、延长服务时间 提交
 *
 *  @param userId   userId
 *  @param userType userType
 *  @param gradeId  gradeId
 *  @param year     延长的年限
 *  @param staff    增加的开通人数
 *  @param success  成功反回
 *  @param failure  失败返回
 */
+ (void)submitWithUserId:(NSString*)userId userType:(NSString*)userType action:(NSString *)action gradeId:(NSString*)gradeId year:(NSString *)year staff:(NSString *)staff success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

//合并到上面接口
//// =====【 增加服务人数、延长服务时间 提交 】================= //
///*
// 以下参数二选一：
// year          延长的年限
// staff         增加的开通人数
// */
//+ (void)submitWIthUserId:(NSString*)userId
//                userType:(NSString*)userType
//                  action:(NSString*)action
//                 gradeId:(NSString*)gradeId
//                    year:(int)year
//                   staff:(int)staff
//                 success:(void (^)(BOOL ok))success
//                 failure:(void (^)(NSError *error))failure;

@end
