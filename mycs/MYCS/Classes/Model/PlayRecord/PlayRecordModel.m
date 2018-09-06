//
//  PlayRecordModel.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "PlayRecordModel.h"
#import "MJExtension.h"
#import "DataCacheTool.h"


@implementation NetworkPlayRecordModel

+ (void)loadPlayRecordWithPage:(NSInteger)page success:(void (^)(NetworkPlayRecordModel *model))success failure:(void (^)(NSError *error))failure {
    
    NSString *path = [HOST_URL stringByAppendingString:VIDEO_PATH];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"action"] = @"playRecord";
    params[@"userId"] = [AppManager sharedManager].user.uid;
    params[@"pageSize"] = @(10);
    params[@"page"] = @(page);
    
    [SCBModel BPOST:path parameters:params encrypt:YES success:^(SCBModel *model) {
        
        NetworkPlayRecordModel *recordModel = [NetworkPlayRecordModel objectWithKeyValues:model.data];
        
        if (success)
        {
            success(recordModel);
        }
        
    } failure:^(NSError *error) {
        
        if (failure)
        {
            failure(error);
        }
        
    }];
    
}

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [PlayRecordModel class]};
}

@end

@implementation PlayRecordModel

MJCodingImplementation

+ (instancetype)playRecordWith:(NSString *)title videoId:(NSString *)videoId picUrl:(NSString *)picUrl videoType:(NSString *)videoType {
    
    PlayRecordModel *recordModel = [PlayRecordModel new];
    recordModel.title = title;
    recordModel.video_id = videoId;
    recordModel.coverUrl = picUrl;
    recordModel.type = videoType;
    
    return recordModel;
    
}

+ (void)addLocalPlayRecord:(PlayRecordModel *)playRecord {
    
    //添加播放记录
    [DataCacheTool addPlayRecord:playRecord];
    
}

+ (NSMutableArray *)localPlayRecordsWith:(int)page {
    
    int pageSize = 16;
    
    NSMutableArray *list = [DataCacheTool playRecordsWith:page pageSize:pageSize];
    
    return list;
}

@end


