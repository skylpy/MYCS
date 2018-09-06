//
//  PayForOtherModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/1/29.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

typedef NS_ENUM(NSInteger, PayStatus){
    payStatus_pending = 0,
    payStatus_payed = 1,
    payStatus_reject = 2
};

@interface PayForOtherModel : JSONModel

@property (strong, nonatomic) NSString *modelID; //申请记录的id
@property (strong, nonatomic) NSString *picUrl; //图片
@property (strong, nonatomic) NSString *goodsName; //代付商品名
@property (strong, nonatomic) NSString *price; //价格
@property (strong, nonatomic) NSString *latestStaff; //最新一个申请员工姓名
@property (strong, nonatomic) NSString *totalApply; //申请总人数
@property (strong, nonatomic) NSString *buy_cid;
@property (strong, nonatomic) NSString *comment_type;
@property (assign, nonatomic) PayStatus status; //状态：0表示 未处理，1表示已付款，2表示已拒绝

/**
 *  获取员工代付列表
 *
 *  @param userID   登陆用户id
 *  @param userType 登录用户的类型
 *  @param sort     最新：updateTime  最多人数： totalApply
 *  @param status   状态：已处理：processed   未处理：pending
 *  @param pageNo   页数
 *  @param pageSize 每页个数
 *  @param success  成功返回块
 *  @param failure  失败返回块
 */

+ (void)requestPayForOtherWithUserID:(NSString *)userID userType:(NSString *)userType sort:(NSString *)sort status:(NSString *)status pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize Success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

/**
 *  拒绝支付
 *
 *  @param userID   <#userID description#>
 *  @param userType <#userType description#>
 *  @param listID   <#listID description#>
 *  @param reason   <#reason description#>
 *  @param success  <#success description#>
 *  @param failure  <#failure description#>
 */
+ (void)rejectPayForOtherWithUserID:(NSString *)userID userType:(NSString *)userType listID:(NSString *)listID reason:(NSString *)reason success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end
