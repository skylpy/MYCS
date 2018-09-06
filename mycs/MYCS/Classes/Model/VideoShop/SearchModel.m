//
//  SearchModel.m
//  SWWY
//
//  Created by Yell on 15/7/4.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "SearchModel.h"
#import "SCBModel.h"
#import "AppManager.h"

@implementation searchAllVideoDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation searchAllcourseDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation searchAllsopDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation searchAllDoctorDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation searchAllOfficeDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation searchAllHospitalDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end


@implementation searchAllLabDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation searchAllEnterpriseDataModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation searchAllNewsDataModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation searchAllModel
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}
@end

@implementation searchAllBaseDataListModel

@end

@implementation HotHistoryListItemModel

@end
@implementation HotSearchListItemModel

@end

@implementation SearchModel


+ (void)getHotSearchListSuccess:(void (^)(HotSearchListItemModel *model))success  failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:SEARCH_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"searchHot" forKey:@"action"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        HotSearchListItemModel *listModel = [[HotSearchListItemModel alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(listModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getHistoryListSuccess:(void (^)(HotHistoryListItemModel *model))success  failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:SEARCH_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[AppManager sharedManager].user.uid forKeyedSubscript:@"userId"];
    [params setObject:@"searchHistory" forKey:@"action"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        HotHistoryListItemModel *listModel = [[HotHistoryListItemModel alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(listModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+(void)SearhAllListWithKeyWord:(NSString *)keyWord Success:(void (^)(NSMutableDictionary *))Success failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL stringByAppendingString:SEARCH_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"searchAll" forKey:@"action"];
    [params setObjectNilToEmptyString:keyWord forKey:@"keyword"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        
        searchAllModel *allModelList = [[searchAllModel alloc]initWithDictionary:model.data error:&error];
        NSArray *videoList = [searchAllVideoDataModel arrayOfModelsFromDictionaries:allModelList.videoData.list error:&error];
        NSArray *courseList = [searchAllcourseDataModel arrayOfModelsFromDictionaries:allModelList.courseData.list error:&error];
        NSArray *sopList = [searchAllsopDataModel arrayOfModelsFromDictionaries:allModelList.sopData.list error:&error];
        NSArray *doctorList = [searchAllDoctorDataModel arrayOfModelsFromDictionaries:allModelList.doctorData.list error:&error];
        NSArray *OfficeList = [searchAllOfficeDataModel arrayOfModelsFromDictionaries:allModelList.officeData.list error:&error];
        NSArray *HospitalList = [searchAllHospitalDataModel arrayOfModelsFromDictionaries:allModelList.hosData.list error:&error];
        NSArray *EnterpriseList = [searchAllEnterpriseDataModel arrayOfModelsFromDictionaries:allModelList.enterpriseData.list error:&error];
        NSArray *labList = [searchAllLabDataModel arrayOfModelsFromDictionaries:allModelList.labData.list error:&error];
        NSArray *newsList = [searchAllNewsDataModel arrayOfModelsFromDictionaries:allModelList.newsData.list error:&error];
        
        NSMutableDictionary *AllListDict = [NSMutableDictionary dictionary];
        [AllListDict setObject:videoList forKey:@"0"];
        [AllListDict setObject:courseList forKey:@"1"];
        [AllListDict setObject:sopList forKey:@"2"];
        [AllListDict setObject:doctorList forKey:@"3"];
        [AllListDict setObject:OfficeList forKey:@"4"];
        [AllListDict setObject:HospitalList forKey:@"5"];
        [AllListDict setObject:labList forKey:@"6"];
        [AllListDict setObject:EnterpriseList forKey:@"7"];
        [AllListDict setObject:newsList forKey:@"8"];
        
        if (error && failure) {
            failure(error);
        } else if (Success) {
            Success(AllListDict);
        }
    } failure:^(NSError *error) {
        
        failure(error);
        
    }];
}

+(void)SearhVideoWithKeyWord:(NSString *)keyWord type:(int)type page:(NSString *)page priceType:(NSString *)prcieType Success:(void(^)(NSMutableArray * ListArr))Success failure:(void(^)(NSError *error))failure{
    
    NSString *path = [HOST_URL stringByAppendingString:SEARCH_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (type == 1)
    {
        [params setObject:@"searchVideo" forKey:@"action"];
        
    }else if (type == 2)
    {
        [params setObject:@"searchCourse" forKey:@"action"];
        
    }else if (type == 3)
    {
        [params setObject:@"searchSop" forKey:@"action"];
        
    }
    
    [params setObject:page forKey:@"page"];
    [params setObject:@"10" forKey:@"pageSize"];
    [params setObjectNilToEmptyString:prcieType forKey:@"isFree"];
    [params setObjectNilToEmptyString:keyWord forKey:@"keyword"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        
        NSArray * listArr =  model.data[@"list"];
        NSMutableArray *List = [NSMutableArray array];
        if (type == 1)
        {
            List = [searchAllVideoDataModel arrayOfModelsFromDictionaries:listArr error:&error];
        }else if (type == 2)
        {
            List = [searchAllcourseDataModel arrayOfModelsFromDictionaries:listArr error:&error];
        }else if (type == 3)
        {
            List = [searchAllsopDataModel arrayOfModelsFromDictionaries:listArr error:&error];
        }
        
        if (error && failure) {
            failure(error);
        } else if (Success) {
            Success(List);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    
}


+(void)SearhOtherWithKeyWord:(NSString *)keyWord type:(int)type page:(NSString *)page Success:(void(^)(NSMutableArray * ListArr))Success failure:(void(^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:SEARCH_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (type == 0)
    {
        [params setObject:@"searchDoctor" forKey:@"action"];
        
    }else if (type == 1)
    {
        [params setObject:@"searchEnterprise" forKey:@"action"];
        [params setObject:@"185" forKey:@"agroupId"];
        
    }else if (type == 2)
    {
        [params setObject:@"searchEnterprise" forKey:@"action"];
        [params setObject:@"183" forKey:@"agroupId"];
    }else if (type == 3)
    {
        [params setObject:@"searchEnterprise" forKey:@"action"];
        [params setObject:@"187" forKey:@"agroupId"];
    }
    else if (type == 4)
    {
        [params setObject:@"searchEnterprise" forKey:@"action"];
        [params setObject:@"5" forKey:@"agroupId"];
    }else if (type == 5)
    {
        [params setObject:@"searchNews" forKey:@"action"];
    }
    [params setObject:page forKey:@"page"];
    [params setObject:@"10" forKey:@"pageSize"];
    [params setObjectNilToEmptyString:keyWord forKey:@"keyword"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError * error ;
        NSArray * listArr =  model.data[@"list"];
        NSMutableArray *List = [NSMutableArray array];
        
        
        if (type == 0)
        {
            List = [searchAllDoctorDataModel arrayOfModelsFromDictionaries:listArr error:&error];
            
        }else if (type == 1)
        {
            List = [searchAllOfficeDataModel arrayOfModelsFromDictionaries:listArr error:&error];
        }
        else if (type == 2)
        {
            List = [searchAllHospitalDataModel arrayOfModelsFromDictionaries:listArr error:&error];
            
        }else if (type == 3)
        {
            List = [searchAllLabDataModel arrayOfModelsFromDictionaries:listArr error:&error];
            
        }else if (type == 4)
        {
            List = [searchAllEnterpriseDataModel arrayOfModelsFromDictionaries:listArr error:&error];
            
        }else if (type == 5)
        {
            List = [searchAllNewsDataModel arrayOfModelsFromDictionaries:listArr error:&error];
        }
        
        if (error && failure) {
            failure(error);
        } else if (Success) {
            Success(List);
        }
        
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    
}

@end
