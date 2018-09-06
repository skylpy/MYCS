//
//  SopTask.h
//  SWWY
//
//  Created by 黄希望 on 15-1-25.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "T_Course.h"

@interface SopTask : JSONModel

@property (strong,nonatomic) NSString *endTime;
@property (strong,nonatomic) NSString *userTaskId;
@property (strong,nonatomic) NSString *title;
@property (assign,nonatomic) int click;
@property (assign,nonatomic) int status;
@property (strong,nonatomic) NSString *cid;
@property (copy,nonatomic) NSString * sopId;
@property (strong,nonatomic) NSString *category;
@property (strong,nonatomic) NSString *duration;
@property (strong,nonatomic) NSString *videoPic;
@property (strong,nonatomic) NSString *mp4Url;
@property (strong,nonatomic) NSArray<T_Course> *course;


/**
 *  sop 任务详情接口
 *
 *  @param userId   登陆用户id
 *  @param userType 登录用户类型
 *  @param action   固定：detail
 *  @param sort     固定值：sop
 *  @param Id       详情接口返回的id
 *  @param success  success description
 *  @param failure  failure description
 */
+ (void)taskWithUserId:(NSString *)userId
              userType:(NSString *)userType
                action:(NSString *)action
                  sort:(NSString *)sort
                    Id:(NSString *)Id
               success:(void (^)(SopTask *sopTask))success
               failure:(void (^)(NSError *error))failure;

@end
