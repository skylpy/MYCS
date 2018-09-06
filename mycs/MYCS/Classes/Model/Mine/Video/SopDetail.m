//
//  SopDetail.m
//  SWWY
//
//  Created by 黄希望 on 15-1-16.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "SopDetail.h"
#import "SCBModel.h"

@implementation SopDetail

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"person_price": @"personPrice",@"group_price":@"groupPrice",@"comment_type": @"commentType",@"comment_cid":@"commentCId",@"comment_total":@"commentTotal",@"nextIndex":@"nextIndex"}];
}

+ (void)sopDetailWithsopId:(NSString *)sopId activityId:(NSString *)activityId fromCache:(BOOL)isFromCache success:(void (^)(SopDetail *))success failure:(void (^)(NSError *))failure{
    NSString *path = [HOST_URL stringByAppendingString:SOP_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    User * user = [AppManager sharedManager].user;
    
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@(user.userType) forKey:@"userType"];
    
    [params setObjectNilToEmptyString:@"detail" forKey:@"action"];
    [params setObjectNilToEmptyString:sopId forKey:@"id"];
    if (activityId)
    {
        [params setObject:activityId forKey:@"activityId"];
    }
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        SopDetail *sop = [[SopDetail alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(sop);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)RequestWithPath:(NSString *)path param:(NSDictionary *)params userID:(NSString *)userID videoID:(NSString *)videoID success:(void (^)(SopDetail *sopDetail))success
                failure:(void (^)(NSError *error))failure{

}


+ (void)sopDetailToDoTaskWithSopId:(NSString*)sopId taskId:(NSString *)taskId
                    success:(void (^)(SopDetail *sopDetail))success
                    failure:(void (^)(NSError *error))failure{
    
    NSString *path = [HOST_URL stringByAppendingString:SOP_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    User * user = [AppManager sharedManager].user;
    
    [params setObjectNilToEmptyString:user.uid forKey:@"userId"];
    [params setObjectNilToEmptyString:@(user.userType) forKey:@"userType"];
    
    [params setObjectNilToEmptyString:@"detail" forKey:@"action"];
    [params setObjectNilToEmptyString:sopId forKey:@"id"];
    [params setObjectNilToEmptyString:taskId forKey:@"task_id"];
    
    
    //TODO: SOP任务
    [SCBModel BGET:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        SopDetail *sop = [[SopDetail alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(sop);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}







- (void)setCourseIndex:(int)courseIndex {
    _courseIndex = courseIndex;
    
    self.realCourseIndex = courseIndex;
    
}

- (void)setChapterIndex:(int)chapterIndex {
    _chapterIndex = chapterIndex;
    
    self.realChapterIndex = chapterIndex;
}

- (void)setRealCourseIndex:(int)realCourseIndex {
    
    if (_realCourseIndex>realCourseIndex) {
        return;
    }
    _realCourseIndex = realCourseIndex;
    
}

- (void)setRealChapterIndex:(int)realChapterIndex {
    
    if (_realChapterIndex > realChapterIndex) {
        return;
    }
    
    _realChapterIndex = realChapterIndex;
    
}

+ (void)addCollection:(NSString *)collectId collectionType:(NSString *)type Collect:(NSString *)collect success:(void (^)(void))success failure:(void (^)(NSError *))failure {
    
    NSString *path = [HOST_URL stringByAppendingString:SOP_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"addCollect";
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"type"] = type;
    params[@"id"] = collectId;
    params[@"collect"] = collect;
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        if (success) {
            success();
        }
        
    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }
        
    }];

}

+(void)sopEdictWithUserId:(NSString *)userId sopId:(NSString *)sopId name:(NSString *)name introduction:(NSString *)introduction success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    NSString *path = [HOST_URL stringByAppendingString:SOP_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userId forKey:@"userId"];
    
    [params setObject:@"editSop" forKey:@"action"];
    
    [params setObject:name forKey:@"name"];
    
    [params setObject:introduction forKey:@"introduction"];
    
    [params setObject:sopId forKey:@"id"];
    
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
