//
//  VideoList.m
//  SWWY
//
//  Created by 黄希望 on 15-1-14.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "VideoList.h"
#import "SCBModel.h"

@implementation Video @end

@implementation VideoList

+ (void)videoListWithUserId:(NSString *)userId
                   userType:(NSString *)userType
                     action:(NSString *)action
                   pageSize:(int)pageSize
                       page:(int)page
                   fromType:(FromType)fromtype
                      paper:(Paper)paper
                    intPerm:(IntPerm)intperm
                    extPerm:(ExtPerm)extperm
                  fromCache:(BOOL)isFromCache
                    success:(void (^)(VideoList *videoList))success
                    failure:(void (^)(NSError *error))failure{
    NSString *path = [HOST_URL stringByAppendingString:VIDEO_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (userId) {
        [params setObject:userId forKey:@"userId"];
    }
    if (action) {
        [params setObject:action forKey:@"action"];
    }
    if (userType) {
        [params setObject:userType forKey:@"userType"];
    }
    [params setObject:@(pageSize) forKey:@"pageSize"];
    [params setObject:@(page) forKey:@"page"];
    [params setObject:@(fromtype) forKey:@"fromType"];
    [params setObject:@(paper) forKey:@"paper"];
    [params setObject:@(intperm) forKey:@"intPerm"];
    [params setObject:@(extperm) forKey:@"extPerm"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NSError *error;
        VideoList *listModel = [[VideoList alloc] initWithDictionary:model.data error:&error];
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

+ (void)RequestWithPath:(NSString *)path params:(NSDictionary *)params success:(void (^)(VideoList *videoList))success
                failure:(void (^)(NSError *error))failure{
    

}

@end
