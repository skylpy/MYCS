//
//  SopList.h
//  SWWY
//
//  Created by 黄希望 on 15-1-14.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "EnumDefine.h"


@protocol Sop
@end

@interface Sop : JSONModel

@property (strong,nonatomic) NSString *sopId;              //课程ID
@property (assign,nonatomic) int click;                 //课程点击数
@property (strong,nonatomic) NSString *addTime;         //课程添加时间
@property (strong,nonatomic) NSString *name;            //课程名称
@property (strong,nonatomic) NSString *introduction;    //课程简介
@property (strong,nonatomic) NSString *picUrl;           //缩略图
@property (strong,nonatomic) NSString *duration;        //课程时长
@property (nonatomic,copy) NSString *videoNum;
@property (assign,nonatomic) BOOL isSeleted;

@property (copy,nonatomic) NSString * usedTime;

@end

@interface SopList : JSONModel

@property (assign,nonatomic) int total;                 //课程总数
@property (strong,nonatomic) NSArray<Sop> *list;        //课程列表

/**
 *  SOP列表接口
 *
 *  @param userId   登陆用户id
 *  @param userType 登录用户的类型
 *  @param authKey  参数加密验证码
 *  @param action   参数值固定：list
 *  @param pageSize 分页数据页记录数
 *  @param page     当前分页
 *  @param vipId ,cateId    分类的ID
 *  @param success  成功执行块
 *  @param failure  失败执行块
 */
+ (void)sopListWithUserId:(NSString *)userId
                 userType:(NSString *)userType
                   action:(NSString *)action
                   keyword:(NSString *)keyword
                    vipId:(NSString *)vipIdStr
                   cateId:(NSString *)cateIdStr
                 pageSize:(int)pageSize
                     page:(int)page
                fromCache:(BOOL)isFromCache
                  success:(void (^)(SopList *sopList))success
                  failure:(void (^)(NSError *error))failure;

@end
