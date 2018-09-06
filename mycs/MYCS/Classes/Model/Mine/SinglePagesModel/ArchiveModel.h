//
//  ArchiveModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/4.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface ArchiveModel : JSONModel

@property (strong, nonatomic) NSNumber *addTime; //计划添加时间
@property (strong, nonatomic) NSString *course_id; //课程id
@property (strong, nonatomic) NSNumber *endTime; //计划截止日期
@property (strong, nonatomic) NSString *pass_rate; //达标正确率
@property (strong, nonatomic) NSNumber *passed; //是否通过，0-未通过 1-已通过
@property (strong, nonatomic) NSString *taskName; //任务名称
@property (strong, nonatomic) NSString *task_id; //任务id
@property (strong, nonatomic) NSString *userRate; //用户任务的整体正确率

/**
 *  归档学习列表
 *
 *  @param userID   用户id
 *  @param pageNo   当前分页，可选，默认为第一页
 *  @param pageSize 分页数据页记录数，可选，默认使用web端配置
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)requestArchiveListWithUserID:(NSString *)userID page:(NSUInteger)pageNo pageSize:(NSString *)pageSize success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end
