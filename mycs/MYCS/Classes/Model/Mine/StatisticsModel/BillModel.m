//
//  BillModel.m
//  SWWY
//
//  Created by GuoChenghao on 15/2/5.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "BillModel.h"
#import "SCBModel.h"

//==================================账单详情==================================//
@implementation BillDetailModel

@end

//==================================账单列表内容==================================//
@implementation BillListItemModel

@end

//==================================账单==================================//
@implementation BillModel

+ (void)requestBillListWithUserID:(NSString *)userID userType:(NSString *)userType month:(NSString *)month status:(NSString *)status page:(NSUInteger)page pageSize:(NSString *)pageSize success:(void (^)(NSArray *billList))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:STATISTICS_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:month forKey:@"month"];
    [params setObjectNilToEmptyString:@"bill" forKey:@"action"];
    [params setObjectNilToEmptyString:status forKey:@"status"];
    [params setObjectNilToEmptyString:@(page) forKey:@"page"];
    [params setObjectNilToEmptyString:pageSize forKey:@"pageSize"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *list = [BillListItemModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(list);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)requestBillDetailWithUserID:(NSString *)userID userType:(NSString *)userType orderID:(NSString *)orderID success:(void (^)(BillDetailModel *billDetail))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:STATISTICS_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:userID forKey:@"userId"];
    [params setObjectNilToEmptyString:userType forKey:@"userType"];
    [params setObjectNilToEmptyString:orderID forKey:@"orderId"];
    [params setObjectNilToEmptyString:@"billDetail" forKey:@"action"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        BillDetailModel *tempModel = [[BillDetailModel alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(tempModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
