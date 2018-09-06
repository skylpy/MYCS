//
//  StaffPlayCountModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/9.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface StaffPlayCountModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *courseId; //课程ID
@property (strong, nonatomic) NSString<Optional> *introduction; //课程简介
@property (strong, nonatomic) NSString<Optional> *title; //课程标题
@property (strong, nonatomic) NSString<Optional> *click; //课程点击量
@property (strong, nonatomic) NSString<Optional> *imageSrc; //缩略图

/**
 *  学习总课程数
 *
 *  @param userID   登陆用户id
 *  @param userType 登录用户的类型
 *  @param month    月份，格式：YYYY-mm    默认为本月
 *  @param page     页码
 *  @param pageSize 每页个数
 *  @param success  成功返回块
 *  @param failure  失败返回块
 */
+ (void)requestStaffPlayCountListWithUserID:(NSString *)userID userType:(NSString *)userType month:(NSString *)month page:(NSUInteger)page pageSize:(NSString *)pageSize success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end
