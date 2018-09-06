//
//  CommonTask.h
//  SWWY
//
//  Created by 黄希望 on 15-1-25.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "T_Chapter.h"

/**
 *  普通任务 详情接口
 */
@interface CommonTask : JSONModel

@property (strong,nonatomic) NSString *endTime;         // 截止时间
@property (strong,nonatomic) NSString *taskName;        // 任务名称
@property (strong,nonatomic) NSString *courseName;      // 课程名称
@property (strong,nonatomic) NSString *category;        // 分类名
@property (strong,nonatomic) NSString *courseId ;
@property (strong,nonatomic) NSString *duration;        // 时长
@property (assign,nonatomic) int passRate;              // 正确率
@property (assign,nonatomic) int status;                // 3-系统发布中  0-未发布  1-已发布  2-已过期
@property (strong,nonatomic) NSString *userTaskId;      // 任务ID，查“参与员工”时用
@property (strong,nonatomic) NSString *videoPic;        // 默认图
@property (strong,nonatomic) NSString *mp4Url;          // 默认播放的视频地址
@property (assign,nonatomic) int click;                 // 点击数
@property (strong,nonatomic) NSArray<T_Chapter> *chapters;         // 章节列表

/**
 *  详情接口
 *
 *  @param userId   登陆用户id
 *  @param userType 登录用户类型
 *  @param action   固定：detail
 *  @param sort     固定值：common
 *  @param Id       详情接口返回的id
 *  @param success  success description
 *  @param failure  failure description
 */
+ (void)taskWithUserId:(NSString *)userId
              userType:(NSString *)userType
                action:(NSString *)action
                  sort:(NSString *)sort
                    Id:(NSString *)Id
               success:(void (^)(CommonTask *commonTask))success
               failure:(void (^)(NSError *error))failure;
@end
