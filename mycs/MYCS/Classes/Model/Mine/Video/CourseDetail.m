//
//  CourseDetail.m
//  SWWY
//
//  Created by 黄希望 on 15-1-16.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "CourseDetail.h"
#import "SCBModel.h"

@implementation CourseDetail

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"comment_type": @"commentType",@"comment_cid":@"commentCId",@"person_price": @"personPrice",@"group_price":@"groupPrice",@"ext_permission":@"extPermission",@"int_permission":@"intPermission",@"id":@"courseId"}];
}

+ (void)courseDetailWithUserId:(NSString *)userId userType:(UserType)userType action:(NSString *)action videoId:(NSString *)courseId activityId:(NSString *)activityId fromCache:(BOOL)isFromCache success:(void (^)(CourseDetail *))success failure:(void (^)(NSError *))failure{
    NSString *path = [HOST_URL stringByAppendingString:COURSE_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId) {
        [params setObject:userId forKey:@"userId"];
    }
    if (action) {
        [params setObject:action forKey:@"action"];
    }
    if (courseId) {
        [params setObject:courseId forKey:@"id"];
    }
    if (activityId)
    {
        [params setObject:activityId forKey:@"activityId"];
    }
    [params setObject:@(userType) forKey:@"userType"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        CourseDetail *course = [[CourseDetail alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(course);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

    
}


+ (void)courseDetailToDoTaskWithacourseId:(NSString*)courseId
                                   taskId:(NSString *)taskId
                               success:(void (^)(CourseDetail *courseDetail))success
                               failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:COURSE_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    User * user = [AppManager sharedManager].user;
    
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@(user.userType) forKey:@"userType"];
    
    [params setObjectNilToEmptyString:@"detail" forKey:@"action"];
    [params setObjectNilToEmptyString:courseId forKey:@"id"];
    [params setObjectNilToEmptyString:taskId forKey:@"task_id"];
    
    //TODO: 普通任务
    [SCBModel BGET:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        CourseDetail *course = [[CourseDetail alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(course);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)setNextIndex:(int)nextIndex {
    _nextIndex = nextIndex;
    self.realNextIndex = nextIndex;
}

- (void)setRealNextIndex:(int)realNextIndex {
    if (_realNextIndex>realNextIndex) {
        return;
    }
    _realNextIndex = realNextIndex;
}

+(void)courseEdictWithUserId:(NSString *)userId courseId:(NSString *)courseId name:(NSString *)name introduction:(NSString *)introduction success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL stringByAppendingString:COURSE_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userId forKey:@"userId"];
    
    [params setObject:@"editCourse" forKey:@"action"];
    
    [params setObject:name forKey:@"name"];
    
    [params setObject:introduction forKey:@"introduction"];
    
    [params setObject:courseId forKey:@"courseId"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        if (success)
        {
            success(@"成功");
        }
        
    } failure:^(NSError *error)
     {
         if (failure)
         {
             failure(error);
         }
     }];
    

}

@end
