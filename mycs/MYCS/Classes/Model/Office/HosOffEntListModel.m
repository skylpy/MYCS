//
//  HosOffEntListModel.m
//  SWWY
//
//  Created by zhihua on 15/7/16.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "HosOffEntListModel.h"
#import "SCBModel.h"
#import "MJExtension.h"

@implementation HosOffEntListModel

+ (void)HosOffEntListWithAction:(NSString *)action
                           page:(int)page
                       pageSize:(int)pageSize
                        success:(void (^)(NSArray *list))success
                        failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = action;
    param[@"page"] = @(page);
    param[@"pageSize"] = @(pageSize);
    
    NSString *path = [HOST_URL stringByAppendingString:HOSOFFENTLIST_PATH];
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        NSMutableArray *list = [NSMutableArray array];
        
        for (NSDictionary *dict in model.data[@"list"]) {
            
            HosOffEntListModel *model = [HosOffEntListModel objectWithKeyValues:dict];
            
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
