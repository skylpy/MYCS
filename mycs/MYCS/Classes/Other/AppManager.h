//
//  AppManager.h
//  SWWY
//  应用程序整体管理单例
//  Created by GuoChenghao on 15/1/8.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import "UserCenterModel.h"
#import "VideoFilterModel.h"
#import "NSMutableDictionary+Util.h"

@interface AppManager : NSObject

/**
 *  用户信息对象
 */
@property (strong, nonatomic) User *user;

@property (nonatomic,strong) NSMutableDictionary *registerDic;

/**
 *  用户中心信息
 */
@property (strong, nonatomic) UserCenterModel *userCenterModel;

/*!
 *  @author zhihua, 16-03-08 11:03:08
 *
 *  当前的网络状态
 */
@property (nonatomic,assign) AFNetworkReachabilityStatus status;

/*!
 *  @author zhihua, 16-03-08 13:03:40
 *
 *  非WIFI环境下下载图片
 */
@property (nonatomic,assign) BOOL WWLANDownImageOff;

/*!
 *  @author zhihua, 16-03-08 15:03:36
 *
 *  非WIFI环境下播放视频
 */
@property (nonatomic,assign) BOOL WWLANPlayVideoOff;
/*!
 *  @author GuiHua
 *
 *  @brief 判断是否允许推送
 *
 */
@property (nonatomic,assign) BOOL canNotification;
/*!
 *  @author GuiHua
 *
 *  @brief 判断是否做过退出登录操作
 *
 */
@property (nonatomic,assign) BOOL selectQuit;

/*!
 *  @author GuiHua
 *
 *  @brief 判断是否被踢了
 *
 */
@property (nonatomic,assign) BOOL isKickOut;

/*!
 *  @author GuiHua
 *
 *  @brief 判断是否第一次安装
 *
 */
@property (nonatomic,assign) BOOL isFirstInstall;

/**
 *  应用程序整体管理单例生成
 *
 *  @return 应用程序整体管理单例对象
 */
+ (instancetype)sharedManager;

///检查是否更新
+ (BOOL)isNewUpdate;

///归档用户信息
+ (void)saveUserCount:(User *)user;

///判断用户是否登陆过
+ (BOOL)hasLogin;

///退出登录
+ (void)loginOut;

///检查用户是否登陆，没有登陆则弹出登陆界面
+ (BOOL)checkLogin;

/*!
 *  @author zhihua, 15-12-08 16:12:40
 *
 *  实时监控网络状态的变化
 *  当网络状态发生改变的时候，会发送通知@"kReachabilityStatusChange"
 *  通知中带有object参数
 *  AFNetworkReachabilityStatusUnknown          = -1,
 *  AFNetworkReachabilityStatusNotReachable     = 0,
 *  AFNetworkReachabilityStatusReachableViaWWAN = 1,
 *  AFNetworkReachabilityStatusReachableViaWiFi = 2,
 */
- (void)startMonitorReachability;

/*!
 *  @author zhihua, 15-12-08 16:12:40
 *
 *  停止网络状态的监控
 */
- (void)stopMonitorReachability;

@end
