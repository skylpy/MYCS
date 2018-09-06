//
//  DeptModel.h
//  SWWY
//
//  Created by 黄希望 on 15-1-31.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@protocol DeptModel @end

@protocol MemModel @end
/**
 *  选择服务
 */
@interface MemModel : JSONModel

@property (strong,nonatomic) NSString<Optional> *id;
@property (strong,nonatomic) NSString<Optional> *text;
@property (strong,nonatomic) NSString<Optional> *parent_id;
@property (strong,nonatomic) NSArray<MemModel,Optional> *children;

@end

/**
 *  选择部门类
 */
@interface DeptModel : JSONModel

@property (strong,nonatomic) NSString *deptId;
@property (strong,nonatomic) NSString *deptName;
@property (strong,nonatomic) NSString *parentId;
@property (strong,nonatomic) NSString *enterpriseUid;
@property (strong,nonatomic) NSString *listOrder;
@property (strong,nonatomic) NSArray *userStaff;
@property (strong,nonatomic) NSArray<DeptModel,Optional> *children;

/**
 *  【 选择部门 】接口
 *
 *  @param action   getDept
 */
+ (void)dataWithUserId:(NSString*)userId
              userType:(NSString*)userType
                action:(NSString*)action
               success:(void (^)(NSArray *list))success
               failure:(void (^)(NSError *error))failure;

/**
 *  【 选择服务对象 】接口
 *
 *  @param action   getGrade
 */
+ (void)getMemberDetail:(NSString *)userID userType:(NSString *)userType action:(NSString *)action success:(void (^)(NSArray *memberDetailList))success failure:(void(^)(NSError *error))failure;

@end
