//
//  VideoShopListModel.m
//  SWWY
//
//  Created by GuoChenghao on 15/1/27.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "VideoShopListModel.h"
#import "SCBModel.h"
#import "DeviceInfoTool.h"

@implementation ShopListItemModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"modelID"}];
}

@end

@interface VideoShopListModel ()

@end

@implementation VideoShopListModel

+ (void)requestVideoShopListWithAction:(NSString *)action page:(int)page pageSize:(int)pageSize fromCache:(BOOL)isFromCache success:(void (^)(VideoShopListModel *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL stringByAppendingString:VIDEOCLASSIFY_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:action forKey:@"action"];
    params[@"type"] = @"yixue";
    params[@"page"] = [NSString stringWithFormat:@"%d",page];
    params[@"pageSize"] = [NSString stringWithFormat:@"%d",pageSize];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        VideoShopListModel *modelTemp = [[VideoShopListModel alloc] initWithDictionary:model.data error:&error];
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


+ (void)searchVideoListWithcid:(NSString *)cid type:(ClassifyVideoSearchType)type keyword:(NSString *)keyword status:(NSString *)status page:(int)page success:(void (^)(NSArray *list, NSInteger total))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:VIDEOCLASSIFY_PATH];
    
    
    NSString * searchType;
    switch (type) {
        case ClassifyVideoSearchTypeVideo:
            searchType = @"video";
            break;
        case ClassifyVideoSearchTypeCourse:
            searchType = @"course";
            break;
        case ClassifyVideoSearchTypeSOP:
            searchType = @"sop";
            break;
        default:
            break;
    }
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    User *user = [AppManager sharedManager].user;
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:[NSString stringWithFormat:@"%d",user.userType] forKey:@"userType"];
    [params setObjectNilToEmptyString:@"list" forKey:@"action"];
    [params setObjectNilToEmptyString:searchType forKey:@"type"];
    [params setObjectNilToEmptyString:cid forKey:@"cid"];
    [params setObjectNilToEmptyString:keyword forKey:@"keyword"];
    [params setObjectNilToEmptyString:status forKey:@"status"];
    [params setObjectNilToEmptyString:[NSString stringWithFormat:@"%d",page] forKey:@"page"];
    [params setObjectNilToEmptyString:@"10" forKey:@"pageSize"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *arrayTemp = [ShopListItemModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        id totalObject = [model.data objectForKey:@"total"];
        NSInteger totalValue = 0;
        if ([totalObject isKindOfClass:[NSNumber class]] || [totalObject isKindOfClass:[NSString class]]) {
            totalValue = [totalObject integerValue];
        }
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(arrayTemp, totalValue);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
