//
//  CourseList.m
//  SWWY
//
//  Created by 黄希望 on 15-1-14.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "CourseList.h"
#import "SCBModel.h"

@implementation Course
+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id": @"courseId"}];
}
@end

@implementation CourseList

+ (void)courseListWithUserId:(NSString *)userId
                    userType:(NSString *)userType
                      action:(NSString *)action
                      keyword:(NSString *)keyword
                       vipId:(NSString *)vipIdStr
                      cateId:(NSString *)cateIdStr
                    pageSize:(int)pageSize
                        page:(int)page
                   fromCache:(BOOL)isFromCache
                     success:(void (^)(CourseList *courseList))success
                     failure:(void (^)(NSError *error))failure{
    
    NSString *path = [HOST_URL stringByAppendingString:TASK_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if ([AppManager sharedManager].user.isAdmin.intValue == 1)
    {
        [params setObject:@"1" forKey:@"staffAdmin"];
    }
    else
    {
        [params setObject:@"0" forKey:@"staffAdmin"];
    }
    if (userId) {
        [params setObject:userId forKey:@"userId"];
    }
    if (action) {
        [params setObject:action forKey:@"action"];
    }
    if (userType) {
        [params setObject:userType forKey:@"userType"];
    }
    //新增分类参数
    if (vipIdStr) {
        [params setObject:vipIdStr forKey:@"vipId"];
    }
    if (cateIdStr) {
        [params setObject:cateIdStr forKey:@"cateId"];
    }
    
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(page) forKey:@"page"];
    
    if (keyword)
    {
          params[@"keyword"] = keyword;
    }
  
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        CourseList *courseModel = [[CourseList alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(courseModel);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)RequestWithPath:(NSString *)path param:(NSDictionary *)params success:(void (^)(CourseList *courseList))success
                failure:(void (^)(NSError *error))failure{
    

}


@end
