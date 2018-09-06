//
//  TaskListModel.h
//  SWWY
//
//  Created by 黄希望 on 15-1-25.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "TaskModel.h"

/**
 *  任务管理列表类
 */
@interface TaskListModel : JSONModel

@property (assign,nonatomic) int total;
@property (strong,nonatomic) NSArray<TaskModel> *list;

/**
 *  任务管理列表接口
 *
 *  @param userId   登陆用户id
 *  @param userType 登录用户类型
 *  @param action   固定：list
 *  @param type      类型： 招聘传0； 内训传1；会员任务传3
 *  @param sort     任务种类： common : 普通任务； sop : sop任务
 *  @param pageSize 分页数据页记录数，可选，默认使用web端配置
 *  @param page     当前分页，可选，默认为第一页
 *  @param success  success
 *  @param failure  failure description
 */
+ (void)listWithUserId:(NSString *)userId
              userType:(NSString *)userType
                action:(NSString *)action
                  type:(int)type
                  sort:(NSString*)sort
               keyword:(NSString *)keyword
              pageSize:(int)pageSize
                  page:(int)page
              taskSort: (NSString *)taskSort
               success:(void (^)(TaskListModel *taskListModel))success
               failure:(void (^)(NSError *error))failure;

@end
