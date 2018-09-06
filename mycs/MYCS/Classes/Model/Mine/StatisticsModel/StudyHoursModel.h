//
//  StudyHoursModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/9.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface StudyHoursModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *username; //员工帐号
@property (strong, nonatomic) NSString<Optional> *realname; //员工真名
@property (strong, nonatomic) NSString<Optional> *studyTime; //学习数量

/**
 *  内训学习时长详情
 *
 *  @param userID   登陆用户id
 *  @param userType 登录用户的类型
 *  @param month    月份，格式：YYYY-mm    默认为本月
 *  @param page     页码
 *  @param pageSize 每页个数
 *  @param success  成功返回块
 *  @param failure  失败返回块
 */
+ (void)requestStudyHoursListWithUserID:(NSString *)userID userType:(NSString *)userType month:(NSString *)month page:(NSUInteger)page pageSize:(NSString *)pageSize success:(void (^)(NSArray *studyHoursList))success failure:(void (^)(NSError *error))failure;

@end
