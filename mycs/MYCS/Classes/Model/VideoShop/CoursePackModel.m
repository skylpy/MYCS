//
//  CoursePackModel.m
//  MYCS
//
//  Created by GuiHua on 16/5/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "CoursePackModel.h"
#import "DeviceInfoTool.h"

@implementation CoursePackChapter

@end

@implementation CoursePackModel

+(void)requestCoursePackModelWithID:(NSString *)Id andIsAjax:(NSInteger)isAjax Success:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL_NOIOS stringByAppendingString:CoursePack_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"course" forKey:@"action"];
    [params setObject:Id forKey:@"id"];
    [params setObject:@(isAjax) forKey:@"isAjax"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        
        NSArray *modelList = [CoursePackModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        
        for (CoursePackModel * Cmodel in modelList)
        {
            Cmodel.coursePackChapters = [NSMutableArray array];
            [Cmodel.coursePackChapters addObjectsFromArray:[CoursePackChapter arrayOfModelsFromDictionaries:Cmodel.chapterData error:&error]];
            
        }
        
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(modelList);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}

-(void)analysisModel:(SCBModel * )model
{
    
}

@end

@implementation CoursePackListModel

+(void)requestCoursePackListWithPage:(NSInteger)page andKeyWord:(NSString *)keyword Success :(void (^)(NSArray *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL_NOIOS stringByAppendingString:CoursePack_PATH];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"index" forKey:@"action"];
    [params setObject:@(1) forKey:@"courseList"];
    [params setObjectNilToEmptyString:keyword forKey:@"keyword"];
    [params setObject:@(1) forKey:@"isAjax"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(10) forKey:@"pageSize"];
    params[@"version"] = [NSString stringWithFormat:@"v%@", [DeviceInfoTool appVersion]];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        
        NSArray *modelList = [CoursePackListModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(modelList);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


@end










