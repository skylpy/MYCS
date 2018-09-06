//
//  IncomeListModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/8.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface IncomeListModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *goodsId; //商品ID
@property (strong, nonatomic) NSString<Optional> *imageSrc; //缩略图
@property (strong, nonatomic) NSString<Optional> *money; //价格
@property (strong, nonatomic) NSString<Optional> *sellCount; //销量
@property (strong, nonatomic) NSString<Optional> *title; //商品标题
@property (strong, nonatomic) NSString<Optional> *type; //商品类型

/**
 *  收入详情
 *
 *  @param userID   登陆用户id
 *  @param userType 登录用户的类型
 *  @param month    月份，格式：YYYY-mm    默认为本月
 *  @param page     页码
 *  @param pageSize 每页个数
 *  @param success  成功返回块
 *  @param failure  失败返回块
 */
+ (void)requestIncomListWithUserID:(NSString *)userID userType:(NSString *)userType month:(NSString *)month page:(NSUInteger)page pageSize:(NSString *)pageSize success:(void (^)(NSArray *incomeList))success failure:(void (^)(NSError *error))failure;

@end
