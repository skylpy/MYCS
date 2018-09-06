//
//  PayInformation.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface PayInformation : JSONModel

@property (strong, nonatomic) NSString *orderNo;
@property (strong, nonatomic) NSString *orderPrice;

/**
 *  申请购买
 *
 *  @param userID    登录用户id
 *  @param userType  登录用户的类型
 *  @param goodsID   购买商品的ID， 视频、教程、sop的对应ID
 *  @param goodsType 教程传0， 视频传1， sop传2
 *  @param goodsName 商品的标题
 *  @param remark    申请的理由
 *  @param success
 *  @param failure   
 */
+ (void)makeBillWithUserID:(NSString *)userID userType:(NSString *)userType goodsID:(NSString *)goodsID goodsType:(NSString *)goodsType goodsName:(NSString *)goodsName remark:(NSString *)remark success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/**
 *  获取支付信息
 *
 *  @param userID      登陆用户id
 *  @param userType    登录用户的类型
 *  @param commentType 视频、教程、sop 详情里面的comment_type  或者 代付列表里面的comment_type
 *  @param buyID       视频、教程、sop 详情里面的buy_cid  或者 代付列表里面的buy_cid
 *  @param success     成功返回
 *  @param failure     失败返回
 */
+ (void)requestPayInformationWithUserID:(NSString *)userID userType:(NSString *)userType commentType:(NSString *)commentType buyID:(NSString *)buyID Success:(void (^)(PayInformation *payInfo))success failure:(void (^)(NSError *error))failure;

/**
 *  调用支付宝
 *
 *  @param orderNO          支付单号
 *  @param orderName        账单名称
 *  @param orderDescription 账单描述
 *  @param orderPrice       账单价格
 */
//+ (void)creatWithOrderNo:(NSString *)orderNO orderName:(NSString *)orderName orderDescription:(NSString *)orderDescription orderPrice:(NSString *)orderPrice;

@end
