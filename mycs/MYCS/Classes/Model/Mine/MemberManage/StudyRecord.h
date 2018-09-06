//
//  StudyRecord.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/13.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface StudyRecord : JSONModel

@property (strong, nonatomic) NSString<Optional> *addTime; //发布时间
@property (strong, nonatomic) NSString<Optional> *courseName; //课程名称
@property (strong, nonatomic) NSString<Optional> *staff; //已发布人数

/**
 *  学习记录 服务详情中的audit 会员审核状态等于 1 或者等于 3时才需要请求
 *
 *  @param userId   登录用户id
 *  @param userType 登录用户的类型
 *  @param memberID 会员ID
 *  @param pageNo   页数
 *  @param pageSize 每页数量
 *  @param success  成功返回块
 *  @param failure  失败返回块
 */
+ (void)requestStudyRecordListWithUerId:(NSString*)userId userType:(NSString*)userType memberID:(NSString *)memberID pageNo:(int)pageNo pageSize:(NSString *)pageSize success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end
