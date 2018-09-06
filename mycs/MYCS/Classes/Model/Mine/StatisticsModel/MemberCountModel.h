//
//  MemberCountModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/9.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface MemberCountModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *realname; //会员 名称
@property (strong, nonatomic) NSString<Optional> *personTotal; //人数

/**
 *  会员人数 详情
 *
 *  @param userID   登陆用户id
 *  @param userType 登录用户的类型
 *  @param month    月份，格式：YYYY-mm    默认为本月
 *  @param page     页码
 *  @param pageSize 每页个数
 *  @param success  成功返回块
 *  @param failure  失败返回块
 */
+ (void)requestMemberCountListWithUserID:(NSString *)userID userType:(NSString *)userType month:(NSString *)month page:(NSUInteger)page pageSize:(NSString *)pageSize success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end
