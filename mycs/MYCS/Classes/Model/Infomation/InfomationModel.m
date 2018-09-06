//
//  InfomationModel.m
//  SWWY
//
//  Created by zhihua on 15/7/2.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "InfomationModel.h"
#import "SCBModel.h"
#import "MJExtension.h"

@implementation InfomationModel

+ (void)InformationListWithPage:(int)page pageSize:(int)pageSize cid:(int)cid fromeCache:(BOOL)isFromCache success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(page);
    param[@"pageSize"] = @(pageSize);
    param[@"cid"] = @(cid);
    
    NSString *path = [HOST_URL stringByAppendingString:INFOMATION];
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        NSMutableArray *list = [NSMutableArray array];
        
        for (NSDictionary *dict in model.data[@"list"]) {
            InfomationModel *model = [InfomationModel objectWithKeyValues:dict];
            [list addObject:model];
        }
        
        if (success) {
            success(list);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
    
}

+ (void)InformationListWithCheckID:(NSString *)checkID Page:(int)page pageSize:(int)pageSize success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"page"] = @(page);
    param[@"pageSize"] = @(pageSize);
    param[@"action"] = @"newsList";
    param[@"checkUid"] = checkID;
    
    NSString *path = [HOST_URL stringByAppendingString:OFFICEAPI_PATH];
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        NSMutableArray *list = [NSMutableArray array];
        
        for (NSDictionary *dict in model.data[@"list"]) {
            InfomationModel *model = [InfomationModel objectWithKeyValues:dict];
            [list addObject:model];
        }
        
        if (success) {
            success(list);
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];

}



@end
