//
//  OfficeModel.m
//  SWWY
//
//  Created by Yell on 15/7/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "OfficeContentModel.h"
#import "SCBModel.h"
#import "MJExtension.h"

@implementation OfficeDetailHonourListModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation OfficeDetailIndustryModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation OfficeDetailUserModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation OfficeDetailModel
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation OfficeContentModel



+ (void)OfficeDetailWithUid:(NSString *)checkUid success:(void (^)(OfficeDetailModel *model))success failure:(void (^)(NSError *error))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"officeIndex";
    param[@"checkUid"] = checkUid;
    [param setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];
    
    NSString *path = [HOST_URL stringByAppendingString:OFFICEAPI_PATH];
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        
        OfficeDetailModel *modelTemp = [[OfficeDetailModel alloc] initWithDictionary:model.data error:&error];
        modelTemp.honourList = [OfficeDetailHonourListModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"honourList"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(modelTemp);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

@end

@implementation OfficeUnDetailModel

+ (void)OfficeListsWithUid:(NSString *)checkUid page:(int)page pageSize:(int)pageSize success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"action"] = @"officeList";
    param[@"checkUid"] = checkUid;
    param[@"pageSize"] = @(pageSize);
    param[@"page"] = @(page);
    
    NSString *path = [HOST_URL stringByAppendingString:OFFICEAPI_PATH];
    
    [SCBModel BPOST:path parameters:param encrypt:YES success:^(SCBModel *model) {
        
        NSMutableArray *list = [NSMutableArray array];
        
        for (NSDictionary *dic in model.data[@"list"]) {
            OfficeUnDetailModel *model = [OfficeUnDetailModel objectWithKeyValues:dic];
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
