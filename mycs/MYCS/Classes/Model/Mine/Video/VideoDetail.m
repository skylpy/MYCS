//
//  VideoDetail.m
//  SWWY
//
//  Created by 黄希望 on 15-1-16.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "VideoDetail.h"
#import "SCBModel.h"

@implementation VideoDetail

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"comment_type": @"commentType",@"comment_cid":@"commentCId",@"person_price": @"personPrice",@"group_price":@"groupPrice",@"ext_permission":@"extPermission",@"int_permission":@"intPermission",@"comment_total":@"commentTotal"}];
}

+ (void)videoDetailWithUserId:(NSString *)userId userType:(UserType)userType action:(NSString *)action videoId:(NSString *)videoId activityId:(NSString *)activityId fromeCache:(BOOL)isFromCache success:(void (^)(VideoDetail *))success failure:(void (^)(NSError *))failure{
    NSString *path = [HOST_URL stringByAppendingString:VIDEO_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId) {
        [params setObject:userId forKey:@"userId"];
    }
    if (action) {
        [params setObject:action forKey:@"action"];
    }
    if (videoId) {
        [params setObject:videoId forKey:@"videoId"];
    }
    if (activityId)
    {
        [params setObject:activityId forKey:@"activityId"];
    }
    [params setObject:@(userType) forKey:@"userType"];
    
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        VideoDetail *detail = [[VideoDetail alloc] initWithDictionary:model.data error:&error];
        if (error && failure) {
            failure(error);
        } else if (success) {
            success(detail);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

+ (void)RequestWithPath:(NSString *)path param:(NSDictionary *)params userID:(NSString *)userID videoID:(NSString *)videoID success:(void (^)(VideoDetail *videoDetail))success
                failure:(void (^)(NSError *error))failure{
    
}

+(void)videoEdictWithUserId:(NSString *)userId videoId:(NSString *)videoId title:(NSString *)title describe:(NSString *)describe success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure
{
    
    NSString *path = [HOST_URL stringByAppendingString:VIDEO_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [params setObject:userId forKey:@"userId"];
    
    [params setObject:@"editVideo" forKey:@"action"];
    
    [params setObject:title forKey:@"title"];
    
    [params setObject:describe forKey:@"describe"];
    
    [params setObject:videoId forKey:@"videoId"];
    
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









