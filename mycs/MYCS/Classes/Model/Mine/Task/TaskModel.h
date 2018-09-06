//
//  TaskModel.h
//  SWWY
//
//  Created by 黄希望 on 15-1-25.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "EnumDefine.h"

@protocol TaskModel @end

@interface TaskModel : JSONModel
/**
 *  任务类
 */
@property (assign, nonatomic) NSTimeInterval endTime;
@property (strong, nonatomic) NSString *memberTaskId;
@property (strong, nonatomic) NSString *picUrl;
@property (assign, nonatomic) NSTimeInterval startTime;
@property (strong, nonatomic) NSString *name;            // 标题
@property (strong, nonatomic) NSString *courseName;
@property (strong, nonatomic) NSString *Id;              // ID
@property (assign, nonatomic) int status;
@property (strong, nonatomic) NSString *remainCount;
@property (strong, nonatomic) NSString *sopId;
@property (assign, nonatomic) TaskReleaseType ReleaseType;
@property (assign, nonatomic) TaskVideoType videoType;
@property (strong, nonatomic) NSString * type;

@end
