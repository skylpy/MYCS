//
//  PlayRecordModel.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VCSDetailViewController.h"
#import "NSObject+MJCoding.h"

@class PlayRecordModel;
@interface NetworkPlayRecordModel : NSObject

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<PlayRecordModel *> *list;

//从网络上加载播放记录
+ (void)loadPlayRecordWithPage:(NSInteger)page success:(void (^)(NetworkPlayRecordModel *model))success failure:(void (^)(NSError *error))failure;

@end

@interface PlayRecordModel : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger praiseNum;

@property (nonatomic, copy) NSString *video_id;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *coverUrl;

@property (nonatomic, assign) NSInteger goods_type;

@property (nonatomic, assign) NSInteger viewNum;

+ (instancetype)playRecordWith:(NSString *)title videoId:(NSString *)videoId picUrl:(NSString *)picUrl videoType:(NSString *)videoType;

+ (void)addLocalPlayRecord:(PlayRecordModel *)playRecord;

+ (NSMutableArray *)localPlayRecordsWith:(int)page;

@end

