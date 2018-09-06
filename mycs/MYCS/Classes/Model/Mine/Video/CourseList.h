//
//  CourseList.h
//  SWWY
//
//  Created by 黄希望 on 15-1-14.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "EnumDefine.h"


@protocol Course
@end

/**
 *  教程类
 */
@interface Course : JSONModel

@property (strong,nonatomic) NSString *courseId;              //课程ID
@property (assign,nonatomic) int click;                 //课程点击数
@property (strong,nonatomic) NSString *addTime;         //课程添加时间
@property (strong,nonatomic) NSString *name;            //课程名称
@property (strong,nonatomic) NSString *introduction;    //课程简介
@property (strong,nonatomic) NSString *image;           //缩略图
@property (strong,nonatomic) NSString *duration;        //课程时长
@property (assign,nonatomic) BOOL isSeleted;

@end

/**
 *  课程列表类
 */
@interface CourseList : JSONModel

@property (assign,nonatomic) int total;                 //课程总数
@property (strong,nonatomic) NSArray<Course> *list;     //课程列表

/**
 *  课程列表接口
 *
 *  @param userId   登陆用户id
 *  @param userType 登录用户的类型
 *  @param authKey  参数加密验证码
 *  @param action   参数值固定：list
 *  @param pageSize 分页数据页记录数
 *  @param page     当前分页
 *  @param success  成功执行块
 *  @param failure  失败执行块
 */
+ (void)courseListWithUserId:(NSString *)userId
                    userType:(NSString *)userType
                      action:(NSString *)action
                     keyword:(NSString *)keyword
                       vipId:(NSString *)vipIdStr
                      cateId:(NSString *)cateIdStr
                    pageSize:(int)pageSize
                        page:(int)page
                   fromCache:(BOOL)isFromCache
                     success:(void (^)(CourseList *courseList))success
                     failure:(void (^)(NSError *error))failure;

@end
