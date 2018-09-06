//
//  TaskRelease.h
//  SWWY
//
//  Created by 黄希望 on 15-1-29.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "CourseOfSOP.h"
#import "TaskCourseReleaseController.h"

@interface TaskRelease : JSONModel

#pragma mark - 企业与机构相同的接口
/**
 *  【 普通任务 -- 发布招聘 】
 *
 *  @param userId     登陆用户id
 *  @param userType   登录用户的类型
 *  @param action     固定：sendTask
 *  @param taskName   招聘、内训标题
 *  @param courseId   教程ID
 *  @param courseName 教程名称
 *  @param issueTime  开始时间
 *  @param endTime    结束时间
 *  @param passRate   正确率
 *  @param scope      招聘对象的邮箱地址，多个用半角分号分隔
 *  @param password   初始密码
 *  @param note       说明
 *  @param type       参数值固定为: 0
 *  @param success    success description
 *  @param failure    failure description
 */
+ (void)commonReleaseWithUserId:(NSString*)userId
                       userType:(NSString*)userType
                         action:(NSString*)action
                       taskName:(NSString*)taskName
                       courseId:(NSString*)courseId
                     courseName:(NSString*)courseName
                      issueTime:(NSString*)issueTime
                        endTime:(NSString*)endTime
                       passRate:(int)passRate
                          scope:(NSString*)scope
                       password:(NSString*)password
                           note:(NSString*)note
                           type:(int)type
                        success:(void (^)(JSONModel *model))success
                        failure:(void (^)(NSError *error))failure;


/**
 *  【 普通任务 -- 发布内训 】
 *
 *  @param userId     登陆用户id
 *  @param userType   登录用户的类型
 *  @param action     固定：sendTask
 *  @param taskName   招聘、内训标题
 *  @param courseId   教程ID
 *  @param courseName 教程名称
 *  @param issueTime  开始时间
 *  @param endTime    结束时间
 *  @param passRate   正确率
 *  @param deptId     部门ID，多个用半角逗号分隔
 *  @param staffUid   员工ID，多个用半角逗号分隔
 *  @param note       说明
 *  @param type       参数值固定为: 1
 *  @param success    success description
 *  @param failure    failure description
 */
+ (void)commonReleaseWithUserId:(NSString*)userId
                       userType:(NSString*)userType
                         action:(NSString*)action
                       taskName:(NSString*)taskName
                       courseId:(NSString*)courseId
                     courseName:(NSString*)courseName
                      issueTime:(NSString*)issueTime
                        endTime:(NSString*)endTime
                       passRate:(int)passRate
                         deptId:(NSString*)deptId
                       staffUid:(NSString*)staffUid
                           note:(NSString*)note
                           type:(int)type
                        success:(void (^)(JSONModel *model))success
                        failure:(void (^)(NSError *error))failure;


/**
 *  【 SOP任务 -- 发布招聘 】
 *
 *  @param userId     登陆用户id
 *  @param userType   登录用户的类型
 *  @param action     固定：sendSopTask
 *  @param taskName   招聘、内训标题
 *  @param sopId      选择的SOP id
 *  @param sopName    选择的sop名称
 *  @param issueTime  开始时间
 *  @param usedTime   总时长
 *  @param courseId   sop里面包含的教程ID
 *  @param courseName 教程名称
 *  @param scope      招聘对象的邮箱地址，多个用半角分号分隔
 *  @param password   初始密码
 *  @param note       说明
 *  @param type       参数值固定为: 0
 *  @param success    success description
 *  @param failure    failure description
 */
+ (void)sopReleaseWithUserId:(NSString*)userId
                    userType:(NSString*)userType
                      action:(NSString*)action
                    taskName:(NSString*)taskName
                       sopId:(NSString*)sopId
                     sopName:(NSString*)sopName
                   issueTime:(NSString*)issueTime
                    usedTime:(NSString*)usedTime
                       scope:(NSString*)scope
                    password:(NSString*)password
                        note:(NSString*)note
                        type:(int)type
                     success:(void (^)(JSONModel *model))success
                     failure:(void (^)(NSError *error))failure;

/**
 *  【 SOP任务 -- 发布内训】
 *
 *  @param userId     登陆用户id
 *  @param userType   登录用户的类型
 *  @param action     固定：sendSopTask
 *  @param taskName   招聘、内训标题
 *  @param sopId      选择的SOP id
 *  @param sopName    选择的sop名称
 *  @param issueTime  开始时间
 *  @param usedTime   总时长
 *  @param courseId   sop里面包含的教程ID
 *  @param courseName 教程名称
 *  @param deptId     选择的部门ID，多个用半角逗号分隔
 *  @param staffUid   选择的员工ID，多个用半角逗号分隔
 *  @param note       说明
 *  @param type       参数值固定为: 1
 *  @param success    success description
 *  @param failure    failure description
 */
+ (void)sopReleaseWithUserId:(NSString*)userId
                    userType:(NSString*)userType
                      action:(NSString*)action
                    taskName:(NSString*)taskName
                       sopId:(NSString*)sopId
                     sopName:(NSString*)sopName
                   issueTime:(NSString*)issueTime
                    usedTime:(NSString*)usedTime
                      deptId:(NSString*)deptId
                    staffUid:(NSString*)staffUid
                        note:(NSString*)note
                        type:(int)type
                     success:(void (^)(JSONModel *model))success
                     failure:(void (^)(NSError *error))failure;

#pragma mark - 机构独有接口
/**
 *  ===【机构 普通任务 -- 发布会员任务】===
 *
 *  @param userId     登陆用户id
 *  @param userType   登录用户的类型
 *  @param action     固定：sendTask
 *  @param taskName   招聘、内训标题
 *  @param courseId   教程ID
 *  @param courseName 教程名称
 *  @param issueTime  开始时间
 *  @param endTime    结束时间
 *  @param passRate   正确率
 *  @param gradeId    服务ID，多个用半角逗号分隔
 *  @param staffUid   会员ID，多个用半角逗号分隔
 *  @param note       说明
 *  @param type       参数值固定为: 3
 *  @param success    成功返回
 *  @param failure    失败返回
 */
+ (void)commonMemberReleaseWithUserId:(NSString*)userId
                             userType:(NSString*)userType
                               action:(NSString*)action
                             taskName:(NSString*)taskName
                             courseId:(NSString*)courseId
                           courseName:(NSString*)courseName
                            issueTime:(NSString*)issueTime
                              endTime:(NSString*)endTime
                             passRate:(int)passRate
                              gradeId:(NSString*)gradeId
                             staffUid:(NSString*)staffUid
                                 note:(NSString*)note
                                 type:(int)type
                              success:(void (^)(JSONModel *model))success
                              failure:(void (^)(NSError *error))failure;

/**
 *  ===【机构 SOP任务 -- 发布会员任务 】===
 *
 *  @param userId    登陆用户id
 *  @param userType  登录用户的类型
 *  @param action    固定：agencySendSop
 *  @param taskName  任务标题
 *  @param sopId     选择的SOP id
 *  @param sopName   选择的sop名称
 *  @param issueTime 开始时间
 *  @param usedTime  总时长
 *  @param gradeId   服务ID，多个用半角逗号分隔
 *  @param staffUid  会员ID，多个用半角逗号分隔
 *  @param note      说明
 *  @param success   成功返回
 *  @param failure   失败返回
 */
+ (void)sopMemberReleaseWithUserId:(NSString*)userId
                          userType:(NSString*)userType
                            action:(NSString*)action
                          taskName:(NSString*)taskName
                             sopId:(NSString*)sopId
                           sopName:(NSString*)sopName
                         issueTime:(NSString*)issueTime
                          usedTime:(NSString*)usedTime
                           gradeId:(NSString*)gradeId
                          staffUid:(NSString*)staffUid
                              note:(NSString*)note
                           success:(void (^)(JSONModel *model))success
                           failure:(void (^)(NSError *error))failure;

/**
 *  【 卫计委任务 -- 发布普通任务内训 】
 *
 *  @param userId     登陆用户id
 *  @param userType   登录用户的类型
 *  @param action     固定：sendTask
 *  @param taskName   招聘、内训标题
 *  @param courseId   教程ID
 *  @param courseName 教程名称
 *  @param issueTime  开始时间
 *  @param endTime    结束时间
 *  @param hospUid    中医院的uid
 *  @param passRate   正确率
 *  @param deptId     部门ID，多个用半角逗号分隔
 *  @param staffUid   员工ID，多个用半角逗号分隔
 *  @param note       说明
 *  @param type       参数值固定为: 1
 *  @param success    success description
 *  @param failure    failure description
 */
+ (void)commissionReleaseWithUserId:(NSString*)userId
                       userType:(NSString*)userType
                         action:(NSString*)action
                       taskName:(NSString*)taskName
                       courseId:(NSString*)courseId
                     courseName:(NSString*)courseName
                      issueTime:(NSString*)issueTime
                        endTime:(NSString*)endTime
                        hospUid:(NSString*)hospUid
                       passRate:(int)passRate
                         deptId:(NSString*)deptId
                       staffUid:(NSString*)staffUid
                           note:(NSString*)note
                           type:(int)type
                        success:(void (^)(JSONModel *model))success
                        failure:(void (^)(NSError *error))failure;

/**
 *  【卫计委任务 -- 发布sop任务内训 】
 *
 *  @param userId     登陆用户id
 *  @param userType   登录用户的类型
 *  @param action     固定：sendSopTask
 *  @param taskName   招聘、内训标题
 *  @param sopId      选择的SOP id
 *  @param sopName    选择的sop名称
 *  @param issueTime  开始时间
 *  @param usedTime   总时长
 *  @param courseId   sop里面包含的教程ID
 *  @param courseName 教程名称
 *  @param deptId     选择的部门ID，多个用半角逗号分隔
 *  @param staffUid   选择的员工ID，多个用半角逗号分隔
 *  @param note       说明
 *  @param type       参数值固定为: 1
 *  @param success    success description
 *  @param failure    failure description
 */
+ (void)commissionSopReleaseWithUserId:(NSString*)userId
                    userType:(NSString*)userType
                      action:(NSString*)action
                    taskName:(NSString*)taskName
                       sopId:(NSString*)sopId
                     sopName:(NSString*)sopName
                   issueTime:(NSString*)issueTime
                    usedTime:(NSString*)usedTime
                      deptId:(NSString*)deptId
                    staffUid:(NSString*)staffUid
                     hospUid:(NSString*)hospUid
                        note:(NSString*)note
                        type:(int)type
                     success:(void (^)(JSONModel *model))success
                     failure:(void (^)(NSError *error))failure;

#pragma mark - 企业独有接口
/**
 *  【 企业 -- 确定发布会员任务 】接口
 *
 *  @param userId       登陆用户id
 *  @param userType     登录用户的类型
 *  @param action       固定：sendMemberTask
 *  @param memberTaskId 会员任务ID
 *  @param sort         任务种类： common : 普通任务； sop : sop任务
 *  @param deptId       部门ID，多个用半角逗号分隔
 *  @param staffUid     员工ID，多个用半角逗号分隔
 *  @param success      success description
 *  @param failure      failure description
 */
+ (void)memberReleaseWithUserId:(NSString*)userId
                       userType:(NSString*)userType
                         action:(NSString*)action
                   memberTaskId:(NSString*)memberTaskId
                           sort:(NSString*)sort
                         deptId:(NSString*)deptId
                       staffUid:(NSString*)staffUid
                        success:(void (^)(JSONModel *model))success
                        failure:(void (^)(NSError *error))failure;

+ (void)releaseSOPTaskWith:(TaskReleaseParamModel *)paramModel success:(void (^)(JSONModel *model))success failure:(void (^)(NSError *error))failure;

@end


@interface M_taskModel : JSONModel

@property (nonatomic,strong) NSString *taskName; //任务标题
@property (nonatomic,strong) NSString *name; //课程或者sop名称
@property (nonatomic,assign) NSTimeInterval issueTime; //开始时间戳
@property (nonatomic,assign) NSTimeInterval endTime; //结束时间戳
@property (nonatomic,assign) int pass_rate; //正确率
@property (nonatomic,assign) int staffCount; //可发布总人数
@property (nonatomic,strong) NSString *note; //任务说明
@property (nonatomic,assign) int usedTime; //总时长
@property (nonatomic,strong) NSString *memberTaskId;
@property (nonatomic,strong) NSArray<CourseOfSOP> *courseList; //== 当sort == sop时，sop下的课程列表

/**
 *  ======【 企业 -- 发布会员任务 】======
 *
 *  @param userId       登陆用户id
 *  @param userType     登录用户的类型
 *  @param action       固定：memberTask
 *  @param memberTaskId 会员任务ID
 *  @param sort         任务种类： common : 普通任务； sop : sop任务
 *  @param success      成功返回
 *  @param failure      失败返回
 */
+ (void)memberTaskListWithUserId:(NSString*)userId
                        userType:(NSString*)userType
                          action:(NSString*)action
                    memberTaskId:(NSString*)memberTaskId
                            sort:(NSString*)sort
                         success:(void (^)(M_taskModel *model))success
                         failure:(void (^)(NSError *error))failure;

@end
