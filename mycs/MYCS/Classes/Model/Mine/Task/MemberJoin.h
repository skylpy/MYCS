//
//  MemberJoin.h
//  SWWY
//
//  Created by 黄希望 on 15-1-29.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@protocol JoinModel @end
/**
 *  员工参与数据模型
 */
@interface JoinModel : JSONModel

@property (assign,nonatomic) int taskStatus;            // 0 -- 不通过，1 -- 已通过 ，2 -- 未参加，3--考核中
@property (strong,nonatomic) NSString *userId;      // 用户ID
@property (strong,nonatomic) NSString *realname;    // 用户名
@property (strong,nonatomic) NSString *username;    // 登录帐号
@property (assign,nonatomic) int userRate;          // 正确率
@property (strong,nonatomic) NSString *rank;        // 排名

@end

/**
 *  【 参与员工 】
 */
@interface MemberJoin : JSONModel

@property (assign,nonatomic) int total;
@property (strong,nonatomic) NSArray<JoinModel> *list;

/**
 *  【 参与员工 】接口
 *
 *  @param userId   登陆用户id
 *  @param action   固定：users
 *  @param taskId   招聘、内训 详情的 userTaskId
 *  @param passed   不通过传0， 通过传1， 默认全部，请求地址不传该参数
 *  @param pageSize 分页数据页记录数
 *  @param page     当前分页
 *  @param success  success description
 *  @param failure  failure description
 */
+ (void)dataWithUserId:(NSString*)userId
                action:(NSString*)action
                taskId:(NSString*)taskId
                passed:(int)passed
              pageSize:(int)pageSize
                  page:(int)page
               success:(void (^)(MemberJoin *memberJoin))success
               failure:(void (^)(NSError *error))failure;
@end
