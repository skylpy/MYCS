//
//  DoctorsHealthList.m
//  MYCS
//
//  Created by GuiHua on 16/7/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "DoctorsHealthList.h"
#import "SCBModel.h"
#import "MJExtension.h"


@implementation DoctorsHealthPhotos


@end

@implementation DoctorsHealthRelate


@end

@implementation DoctorsHealthDetail


@end

@implementation DoctorsHealthHosptial


@end

@implementation DoctorsHealthDoctor


@end

@implementation DoctorsHealthClass


@end

@implementation DoctorsHealthBannar


@end

@implementation DoctorsHealthList

+(void)getListsWithCategory:(NSString *)category itemType:(NSString *)itemType diseaseCategoryId:(NSString *)diseaseCategoryId page:(int)page Success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString * path = [HOST_URL stringByAppendingString:VIDEOINTERVIEW_PATH];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:@"list" forKey:@"action"];
    [params setObjectNilToEmptyString:category forKey:@"category"];
    [params setObjectNilToEmptyString:itemType forKey:@"itemType"];
    [params setObjectNilToEmptyString:diseaseCategoryId forKey:@"disease_category_id"];
    User *user = [AppManager sharedManager].user;
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@(user.userType) forKey:@"userType"];
    [params setObjectNilToEmptyString:@(page) forKey:@"page"];
    [params setObjectNilToEmptyString:@(10) forKey:@"pageSize"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        
        NSMutableArray * ListArr = [DoctorsHealthList arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(ListArr);
            
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];


}

+(void)getBannarWithCategory:(NSString *)category Success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString * path = [HOST_URL stringByAppendingString:VIDEOINTERVIEW_PATH];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    
    [params setObjectNilToEmptyString:category forKey:@"category"];
    [params setObjectNilToEmptyString:@"bannerList" forKey:@"action"];
    
    User *user = [AppManager sharedManager].user;
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@(user.userType) forKey:@"userType"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        
        NSMutableArray * ListArr = [DoctorsHealthBannar arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(ListArr);
            
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];


}

+(void)getDoctorsHealthClassWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString * path = [HOST_URL stringByAppendingString:VIDEOINTERVIEW_PATH];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:@"disCategory" forKey:@"action"];
    User *user = [AppManager sharedManager].user;
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@(user.userType) forKey:@"userType"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;

        NSMutableArray * ListArr = [DoctorsHealthClass arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(ListArr);
            
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

+(void)getDoctorsHealthDetailWithId:(NSString *)idstr Success:(void (^)(DoctorsHealthDetail *))success failure:(void (^)(NSError *))failure
{

    NSString * path = [HOST_URL stringByAppendingString:VIDEOINTERVIEW_PATH];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:@"detail" forKey:@"action"];
    [params setObjectNilToEmptyString:idstr forKey:@"target_id"];
    [params setObjectNilToEmptyString:@"7" forKey:@"target_type"];
    
    User *user = [AppManager sharedManager].user;
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@(user.userType) forKey:@"userType"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        
        DoctorsHealthDetail *Detail = [DoctorsHealthDetail objectWithKeyValues:model.data];
        
        NSArray *doctorData = [DoctorsHealthDoctor objectArrayWithKeyValuesArray:model.data[@"doctorData"]];
        Detail.doctorData = doctorData;
        
        NSArray *hospitalData = [DoctorsHealthHosptial objectArrayWithKeyValuesArray:model.data[@"hospitalData"]];
        Detail.hospitalData = hospitalData;
        
        NSMutableArray *videoRecommend = [DoctorsHealthRelate objectArrayWithKeyValuesArray:model.data[@"videoRecommend"]];
        
        Detail.videoRecommend = videoRecommend;
        
        NSArray *videoPhotos =  [DoctorsHealthPhotos objectArrayWithKeyValuesArray:model.data[@"videoPhotos"]];
        
        Detail.videoPhotos = videoPhotos;
        
        if (error && failure) {
            failure(error);
        } else if (success)
        {
            success(Detail);
            
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    
}

@end

