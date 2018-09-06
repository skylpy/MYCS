//
//  StudyLog.h
//  SWWY
//
//  Created by AdminZhiHua on 15/12/2.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudyLogTool : NSObject

/*!
 *  @author zhihua, 15-12-02 14:12:19
 *
 *  每个章节、视频播放时的请求,UserId为nil，则不执行
 *
 *  @param goodsId   如果当前播放的是视频/教程/sop, goodsId就是视频/教程/sop的id
 *  @param type      当前播放的资源类型  0--视频，1--课程，2--sop
 *  @param courseId  如果当前播放的资源类型是SOP 需要提交当前播放的教程id
 *  @param chapterId 如果当前播放的资源类型是教程或SOP 需要提交当前播放的章节id
 *  @param logId     如果当前播放的资源类型是教程或SOP 需要提交上一个章节播放时返回的logId
 *  @param taskId    如果当前是考核   需要提交考核任务id
 *  @param success   请求执行成功的回调
 *  @param failure   请求执行失败的回调
 */
+ (void)startStudyLog:(NSString *)goodsId goodsType:(int)type courseId:(NSString *)courseId chapterId:(NSString *)chapterId lastLogId:(NSString *)logId taskId:(NSString *)taskId success:(void (^)(NSString *logId))success failure:(void (^)(NSError *error))failure;

/*!
 *  @author zhihua, 15-12-02 14:12:47
 *
 *  任务考核中途退出时的请求，UserId为nil，则不执行
 *
 *  @param logId   开始播放时返回的logId
 *  @param success 请求成功的回调
 *  @param failure 请求失败的回调
 */
+ (void)exitLogWiht:(NSString *)logId viewTime:(NSTimeInterval)viewTime videoTimeSpot:(NSTimeInterval)videoTimeSpot success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/*!
 *  @author zhihua, 15-12-02 14:12:57
 *
 *  播放结束时的请求，UserId为nil，则不执行
 *
 *  @param logId   开始播放时返回的logId
 *  @param success 播放成功的回调
 *  @param failure 播放失败的回调
 */
+ (void)endStudyLogWith:(NSString *)logId breakPointPlay:(BOOL)breakPointPlay viewTime:(NSTimeInterval)viewTime videoTimeSpot:(NSTimeInterval)videoTimeSpot success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/**
 *  @author GuiHua, 16-07-19 16:07:08
 *
 *  专访视频点击量累加
 *  @param goodsId 视频id
 *  @param userId 用户id
 *  @param userType 用户类型
 *  @param action updateViewClick
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+ (void)updateViewClickStudyLogWith:(NSString *)goodsId userId:(NSString *)userId userType:(NSString *)userType action:(NSString *)action success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end
