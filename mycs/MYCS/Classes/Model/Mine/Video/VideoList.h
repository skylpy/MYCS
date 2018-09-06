//
//  VideoList.h
//  SWWY
//
//  Created by 黄希望 on 15-1-14.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "EnumDefine.h"

@protocol Video

@end

/**
 *  视频类
 *
 *  @property name          视频名称
 *  @property videoId       视频ID
 *  @property duration      视频时长
 *  @property uploadTime    视频上传时间
 *  @property click         视频点击数
 *  @property describe      视频简介
 *  @property picurl        缩略图
 *  @property mp4url        mp4地址
 */
@interface Video : JSONModel

@property (strong,nonatomic) NSString *name;
@property (strong,nonatomic) NSString *videoId;
@property (strong,nonatomic) NSString *duration;
@property (strong,nonatomic) NSString *uploadTime;
@property (assign,nonatomic) int click;
@property (strong,nonatomic) NSString<Optional> *describe;
@property (strong,nonatomic) NSString *picurl;
@property (strong,nonatomic) NSString *mp4url;

@end


/**
 *  视频列表类
 *
 *  @property total     视频总数
 *  @property list      视频列表
 */
@interface VideoList : JSONModel

@property (assign,nonatomic) int total;
@property (strong,nonatomic) NSArray<Video> *list;


/**
 *  视频列表接口
 *
 *  @param userId       登陆用户id
 *  @param userType     登录用户的类型密码
 *  @param authKey      参数加密验证码
 *  @param action       参数值固定：list
 */
+ (void)videoListWithUserId:(NSString *)userId
                   userType:(NSString *)userType
                     action:(NSString *)action
                   pageSize:(int)pageSize
                       page:(int)page
                   fromType:(FromType)fromtype
                      paper:(Paper)paper
                    intPerm:(IntPerm)intperm
                    extPerm:(ExtPerm)extperm
                  fromCache:(BOOL)isFromCache
                    success:(void (^)(VideoList *videoList))success
                    failure:(void (^)(NSError *error))failure;


@end
