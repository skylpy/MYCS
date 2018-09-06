//
//  BillModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/5.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

//==================================账单详情==================================//
@interface BillDetailModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *avatar; //交易者头像
@property (strong, nonatomic) NSString<Optional> *username; //交易者名称
@property (strong, nonatomic) NSString<Optional> *money; //金额
@property (strong, nonatomic) NSNumber<Optional> *payTime; //时间戳
@property (strong, nonatomic) NSString<Optional> *orderId; //交易号
@property (strong, nonatomic) NSString<Optional> *title; //标题
@property (strong, nonatomic) NSString<Optional> *introduction; //简介
@property (strong, nonatomic) NSString<Optional> *imageSrc; //图片

@end

//==================================账单列表内容==================================//
@interface BillListItemModel : JSONModel

@property (strong, nonatomic) NSNumber<Optional> *payTime; //付款的时间戳
@property (strong, nonatomic) NSString<Optional> *money; //金额
@property (strong, nonatomic) NSNumber *payOut; //1表示支出，0表示收入
@property (strong, nonatomic) NSString *orderId; //帐单ID
@property (strong, nonatomic) NSString<Optional> *goodsId; //商品ID
@property (strong, nonatomic) NSString<Optional> *title; //标题
@property (strong, nonatomic) NSString<Optional> *imageSrc; //商品缩略图

@end

//==================================账单==================================//
@interface BillModel : JSONModel

/**
 *  帐单列表
 *
 *  @param userID   登陆用户id
 *  @param userType 登录用户的类型
 *  @param month    月份，格式：YYYY-mm    默认为本月
 *  @param status   账单状态：全部传空，收入传income、支付传payOut
 *  @param page     页码
 *  @param pageSize 每页个数
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)requestBillListWithUserID:(NSString *)userID userType:(NSString *)userType month:(NSString *)month status:(NSString *)status page:(NSUInteger)page pageSize:(NSString *)pageSize success:(void (^)(NSArray *billList))success failure:(void (^)(NSError *error))failure;

/**
 *  帐单详情
 *
 *  @param userID   登陆用户id
 *  @param userType 登录用户的类型
 *  @param orderID  帐单 ID
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)requestBillDetailWithUserID:(NSString *)userID userType:(NSString *)userType orderID:(NSString *)orderID success:(void (^)(BillDetailModel *billDetail))success failure:(void (^)(NSError *error))failure;

@end
