//
//  VideoClassifyModel.m
//  SWWY
//
//  Created by GuoChenghao on 15/1/27.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "VideoClassifyModel.h"
#import "SCBModel.h"

@implementation childrenListModel

@end

@implementation SecondLevelModel

@end

@implementation FirstLevelModel

@end


@implementation VideoClassifyModel

+ (void)requestVideoClassifySuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure
{
    NSString *path = [HOST_URL stringByAppendingString:VIDEOCLASSIFY_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"cateList" forKey:@"action"];
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        NSError *error;
        NSArray *modelList = [FirstLevelModel arrayOfModelsFromDictionaries:[model.data objectForKey:@"list"] error:&error];

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
