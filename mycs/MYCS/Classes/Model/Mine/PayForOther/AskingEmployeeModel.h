//
//  AskingEmployeeModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/1/30.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface AskingEmployeeModel : JSONModel
@property (strong, nonatomic) NSString *modelID;
@property (strong, nonatomic) NSString *payingGoodsId;
@property (strong, nonatomic) NSString *uid;
@property (strong, nonatomic) NSString *username; //员工姓名
@property (strong, nonatomic) NSNumber *createTime; //申请时间戳
@property (strong, nonatomic) NSString *remark; //留言

/**
 *  获取员工申请列表
 *
 *  @param userID   登陆用户id
 *  @param userType 登录用户的类型
 *  @param listID   [列表] 接口中返回的申请记录id
 *  @param pageNo   页数
 *  @param pageSize 每页个数
 *  @param success  成功返回块
 *  @param failure  失败返回块
 */
+ (void)requestAskingEmployeeListWithUserID:(NSString *)userID userType:(NSString *)userType listID:(NSString *)listID pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize Success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end
