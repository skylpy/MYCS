//
//  watiToDoTaskTool.h
//  SWWY
//
//  Created by zhihua on 15/4/23.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface WaitToDoTaskTool : NSObject

+ (void)requestWaitDoTaskWithAction:(NSString *)action taskStatus:(NSString *)taskStatus page:(NSUInteger)pageNo success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end

@interface WaitToDoTaskResult : NSObject<MJKeyValue>

/**
 *  任务列表
 */
@property (nonatomic, strong) NSArray *list;
/**
 *  列表的总数
 */
@property (nonatomic, assign) int total;

@end

@interface WaitToDoTask : NSObject<MJKeyValue>

//courseId 课程id（当action=getCommonTask时填写）
@property (nonatomic,copy) NSString *courseId;
//SOPId SOPId(当action=getSOPTask时填写）
@property (nonatomic,copy) NSString *sopId;
//endTime 计划截止日期
@property (nonatomic,strong) NSNumber *endTime;
//isEnd 任务是否结束（0代表未结束，1代表已结束）
@property (nonatomic,strong) NSNumber *isEnd;
//passed 是否通过，0-未通过 1-已通过（isEnd为1时填写）
@property (nonatomic,strong) NSNumber *passed;

@property (nonatomic,copy) NSString *rank;
//rate 完成百分比（isEnd为0时填写）
@property (nonatomic,copy) NSString *rate;
//taskId 任务id，
@property (nonatomic,copy) NSString *taskId;
//taskName 任务名称
@property (nonatomic,copy) NSString *taskName;
//userRate 用户答题的正确率（isEnd为1时填写）
@property (nonatomic,copy) NSString *userRate;
//章节数
@property(nonatomic,copy) NSString * chaptersNum;
//图片
@property(nonatomic,copy) NSString * image;
//任务状态
@property (nonatomic,copy)NSString * taskStatus;
//合格指标
@property (nonatomic,copy)NSString * passRate;
//医院名称
@property (nonatomic,copy)NSString * enterpriseName;


@end
