//
//  WaitDoTaskInfoModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/11.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "WaitDoTaskChapter.h"

//=======================待办任务详情======================//
@interface WaitDoTaskInfoModel : JSONModel

@property (strong, nonatomic) NSString *courseId; //教程id
@property (strong, nonatomic) NSString *imgURL; //教程图片路径
@property (strong, nonatomic) NSString *introduction; //教程简介
@property (strong, nonatomic) NSString *name; //教程名称
@property (strong, nonatomic) NSString *user_next_chapter_id; //下一个未学习的章节id
@property (strong, nonatomic) NSArray<WaitDoTaskChapter> *chapters; //包含章节列表的的数组

/**
 *  获取任务中课程信息接口
 *
 *  @param userID   用户ID
 *  @param courseID 课程ID
 *  @param taskID   任务ID
 *  @param success  成功返回块
 *  @param failure  失败返回块
 */
+ (void)requestTaskInfoWithUserID:(NSString *)userID courseID:(NSString *)courseID taskID:(NSString *)taskID success:(void (^)(WaitDoTaskInfoModel *taskInfo))success failure:(void (^)(NSError *error))failure;

@end
