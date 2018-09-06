//
//  VideoDetail.h
//  SWWY
//
//  Created by 黄希望 on 15-1-16.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "VideoList.h"
#import "User.h"

/**
 *  视频详情类 继承自 video 类
 */
@interface VideoDetail : JSONModel

@property (strong,nonatomic) NSString *id;
@property (strong,nonatomic) NSString *duration;    // 时长
@property (assign,nonatomic) int click;             // 点击数
@property (strong,nonatomic) NSString<Optional> *describe; // 简介
@property (strong,nonatomic) NSString *picurl;      // 缩略图
@property (strong,nonatomic) NSString *mp4url;      // 视频地址
@property (strong,nonatomic) NSString<Optional> *mp4urlHd;      // 视频地址

@property (nonatomic,copy) NSString *link_url;      // 对应网页地址

@property (assign,nonatomic) int type;              // 来源，0表示自制，1表示购买
@property (strong,nonatomic) NSString *title;       // 视频标题
@property (strong,nonatomic) NSString *category;    // 视频分类
@property (assign,nonatomic) int commentType;       // 评论的类型
@property (strong,nonatomic) NSString *commentCId;  // 评论cid
@property (assign,nonatomic) int commentTotal;      // 评论总数
@property (assign,nonatomic) int personPrice;       // type=0时，个人价格
@property (assign,nonatomic) int groupPrice;        // type=0时，团体价格
@property (assign,nonatomic) int extPermission;     // 对外权限 :0,外部不公开 1,外部公开 2,外部验证可看 3,外部付费可看
@property (assign,nonatomic) int intPermission;     // 对内权限 :0,内部不公开 1,内部公开
@property (assign,nonatomic) int price;             // type=1时，购买的价格
@property (strong,nonatomic) NSString *from;        // type=1时，来源 : "红牛公司"
@property (assign,nonatomic) int buy;               // 0表示不需要购买，1表示需要购买，2表示申请购买中，3表示已购买
@property (strong,nonatomic) NSString *buy_cid;     // 购买的商品ID
@property (strong,nonatomic) NSString *check_word;  // 验证码
@property (strong,nonatomic) NSString *uid;         // 视频所有者ID，从无忧商城进来的要先判断下是不是本人，不是再判断对外权限

//--是否已经购买了当前会员套餐（当前资源属于会员套餐资源时）
@property (nonatomic,assign) BOOL isMember;
//--当前资源的额外权限限制，0--无，1--属于会员套餐，2--无需登录即可播放的资源
@property (nonatomic,assign) int extra_permission;
//--所属套餐类型
@property (nonatomic,copy) NSArray *memberType;
@property (nonatomic,copy) NSString *vipTips;

//是否收藏
@property (nonatomic,assign) BOOL is_collect;

//m3u8地址
@property (nonatomic,copy) NSString *m3u8;
//m3u8地址
@property (nonatomic,copy) NSString<Optional> *m3u8Hd;

@property (copy,nonatomic) NSString *up;
@property (copy,nonatomic) NSString *isPraise;
//轮播图片数组
@property (nonatomic,copy) NSArray<Optional> *picList;
@property (nonatomic,copy) NSString<Optional> *interval_time;

//是否播放高清视频
@property (nonatomic,assign,getter=isChangeHD) BOOL changeHD;

//下载文件的大小
@property (nonatomic,copy) NSString *fileSize;

@property (nonatomic,assign,getter=isDownloadComplete) BOOL downloadComplete;

/**
 *  视频详情接口
 *
 *  @param userId   登陆用户id
 *  @param userType 登录用户的类型
 *  @param action   参数值固定：detail
 *  @param videoId  视频ID
 *  @param success  成功执行块
 *  @param failure  失败执行块
 */

+ (void)videoDetailWithUserId:(NSString*)userId
                     userType:(UserType)userType
                       action:(NSString*)action
                      videoId:(NSString*)videoId
                   activityId:(NSString *)activityId
                   fromeCache:(BOOL)isFromCache
                      success:(void (^)(VideoDetail *videoDetail))success
                      failure:(void (^)(NSError *error))failure;

//userId         登陆用户id
//videoId      视频id
//title            视频编辑名称
//describe     视频编辑内容
//authKey     参数加密验证码
//action        参数值固定  editVideo
//device        机器码

+ (void)videoEdictWithUserId:(NSString*)userId
                     videoId:(NSString *)videoId
                       title:(NSString*)title
                      describe:(NSString*)describe
                      success:(void (^)(NSString *success))success
                      failure:(void (^)(NSError *error))failure;
@end






