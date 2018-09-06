//
//  ServiceModel.h
//  SWWY
//
//  Created by 黄希望 on 15-2-10.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@protocol ServiceModel
@end
@interface ServiceModel : JSONModel

@property (nonatomic,strong) NSString *ID;
@property (nonatomic,strong) NSString *text;
@property (nonatomic,strong) NSArray<ServiceModel,Optional> *children;

/**
 *  =====【 发布会员任务 -- 按服务选择 】====
 *
 *  @param userId   登陆用户id
 *  @param userType 登录用户的类型
 *  @param action   固定：getGrade
 *  @param success  成功返回块
 *  @param failur   失败返回块
 */
+ (void)listWithUserId:(NSString*)userId
              userType:(NSString*)userType
                action:(NSString*)action
               success:(void (^)(NSArray *list))success
               failure:(void (^)(NSError *error))failur;

@end


@interface Mem : JSONModel

@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *id;

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) BOOL isSelected;

/**
 *  ======【 发布会员任务 -- 按会员选择 】=====
 *
 *  @param userId   登陆用户id
 *  @param userType 登录用户的类型
 *  @param action   固定：searchMember
 *  @param keyword  关键字
 *  @param success  成功返回块
 *  @param failure  失败返回块
 */
+ (void)listWithUserId:(NSString*)userId
              userType:(NSString*)userType
                action:(NSString*)action
               keyword:(NSString*)keyword
               success:(void (^)(NSArray *list))success
               failure:(void (^)(NSError *error))failure;

@end