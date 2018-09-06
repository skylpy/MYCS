//
//  AssessModel.m
//  MYCS
//
//  Created by Yell on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AssessModel.h"

@implementation AssessChapterModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation AssessChaptersListModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}

@end

@implementation AssessCourseModel

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    return YES;
}
@end

@implementation AssessModel


+(void)getSOPListWithSopId:(NSString *)sopId taskId:(NSString *)taskId Success:(void(^)(NSArray *list))success failure:(void(^)(NSError * error))failure
{
    NSString * path = [HOST_URL stringByAppendingString:MYWAITDOTASK_PATH];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];

    [params setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@"getDataFromSop" forKey:@"action"];
    [params setObjectNilToEmptyString:sopId forKey:@"sopId"];
    [params setObjectNilToEmptyString:taskId forKey:@"taskId"];
    
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError * error;
        NSArray * list = [AssessCourseModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        
        for (AssessCourseModel * courseModel in list) {
            
            BOOL canDo = YES;
            
            for (AssessChapterModel * model in courseModel.chapter.list) {
                
                model.canDo = canDo;
                
                if (model.passStatus == 0)
                    canDo = NO;
            }
            
        }
        
        if (error && failure) {
            failure(error);
            
        } else if (success) {
            success(list);
            
        }
        
    } failure:^(NSError *error) {
        failure(error);

    }];

}


+(void)getCourseListWithCourseId:(NSString *)courseId taskId:(NSString *)taskId Success:(void(^)(NSArray *list))success failure:(void(^)(NSError * error))failure
{

    
    NSString * path = [HOST_URL stringByAppendingString:MYWAITDOTASK_PATH];
    
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    [params setObjectNilToEmptyString:@"getCourseChapters" forKey:@"action"];
    [params setObjectNilToEmptyString:courseId forKey:@"courseId"];
    [params setObjectNilToEmptyString:taskId forKey:@"taskId"];
    [params setObjectNilToEmptyString:[AppManager sharedManager].user.uid forKey:@"userId"];


    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        
        NSError * error;
        
        NSArray * list = [AssessChapterModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];
        
        BOOL canDo = YES;
        
        for (AssessChapterModel * model in list) {
            
            model.canDo = canDo;

            if (model.passStatus == 0)
                canDo = NO;
        }
        
        if (error && failure) {
            failure(error);
            
        } else if (success) {
            
            success(list);
            
        }
        
    } failure:^(NSError *error) {
        failure(error);

    }];
    
}


@end
