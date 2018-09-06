//
//  CourseDetail.h
//  SWWY
//
//  Created by 黄希望 on 15-1-16.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "CourseList.h"
#import "User.h"
#import "ChapterModel.h"

/**
 *  教程详情类 继承自 course 类
 */
@interface CourseDetail : JSONModel

@property (nonatomic,strong) NSString *id;
@property (strong, nonatomic) NSString *sales;               // 销量
@property (strong, nonatomic) NSString *author;              // 供应商家、source=1时的来源
@property (nonatomic,copy) NSString *link_url;      // 对应网页地址
@property (strong, nonatomic) NSString *price;               // 购买价格
@property (strong, nonatomic) NSString *payTime;             // 发布日期
@property (strong, nonatomic) NSString *category;            // 所属分类
@property (strong, nonatomic) NSString *courseId;            // 教程ID
@property (strong, nonatomic) NSString *name;                // 教程标题
@property (strong, nonatomic) NSString *image;               // 教程缩略图
@property (strong, nonatomic) NSString *duration;            // 教程时长
@property (strong, nonatomic) NSString *introduction;        // 教程简介
@property (assign, nonatomic) int click;                     // 点击
@property (assign, nonatomic) int source;                    // 来源， 0表示自制，1表示购买
@property (assign, nonatomic) int groupPrice;                // 团体价格
@property (assign, nonatomic) int personPrice;               // 个人价格
@property (assign, nonatomic) int extPermission;             // 对外权限 ,0--外部不公开,1--外部公开,2--外部验证可看,3--外部付费可看； type=1，购买的视频没有对外权限，不需要检查这个字段
@property (assign, nonatomic) int intPermission;             // 对内权限 ,0--内部不公开,1--内部公开
@property (assign, nonatomic) int commentType;               // 评论类型
@property (strong, nonatomic) NSString *commentCId;          // 评论cid
@property (assign, nonatomic) int commentTotal;              // 评论总数
@property (strong, nonatomic) NSArray<ChapterModel> *chapters;   // 章节列表
@property (assign, nonatomic) int buy;                       // 0表示不需要购买，1表示需要购买，2表示申请购买中，3表示已购买
@property (strong, nonatomic) NSString *buy_cid;             // 购买的商品ID
@property (strong, nonatomic) NSString *check_word;          // 验证码
@property (strong, nonatomic) NSString *uid;                 // 教程所有者ID，从无忧商城进来的要先判断下是不是本人，不是再判断对外权限


//--是否已经购买了当前会员套餐（当前资源属于会员套餐资源时）
@property (nonatomic,assign) BOOL isMember;
//--当前资源的额外权限限制，0--无，1--属于会员套餐，2--无需登录即可播放的资源
@property (nonatomic,assign) int extra_permission;
//--所属套餐类型
@property (nonatomic,copy) NSArray *memberType;

@property (nonatomic,copy) NSString *vipTips;

@property (nonatomic,assign) int previewTime;

//是否收藏
@property (nonatomic,assign) BOOL is_collect;

//m3u8地址
@property (nonatomic,copy) NSString *m3u8;
//m3u8地址
@property (nonatomic,copy) NSString<Optional> *m3u8Hd;

//任务播放章节的索引
@property (nonatomic,assign) int nextIndex;
@property (nonatomic,assign) int realNextIndex;

@property (copy,nonatomic) NSString *up;
@property (copy,nonatomic) NSString *isPraise;

//新增字段
@property (nonatomic,copy) NSString *taskId;
@property (nonatomic,copy) NSString *taskName;
@property (nonatomic,copy) NSString *passRate;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *enterpriseName;
@property (nonatomic,copy) NSString *rank;

@property (nonatomic,copy) NSString *passNum;
//轮播图片数组
@property (nonatomic,copy) NSArray *picList;
@property (nonatomic,copy) NSString *interval_time;

@property (nonatomic,copy) NSString <Optional>*isSelect;

/**
 *  教程详情接口
 *
 *  @param userId   登陆用户id
 *  @param userType 登录用户的类型
 *  @param action   参数值固定：detail
 *  @param courseId 教程id
 *  @param success  成功执行块
 *  @param failure  失败执行块
 */

+ (void)courseDetailWithUserId:(NSString*)userId
                      userType:(UserType)userType
                        action:(NSString*)action
                       videoId:(NSString*)courseId
                       activityId:(NSString *)activityId
                     fromCache:(BOOL)isFromCache
                       success:(void (^)(CourseDetail *courseDetail))success
                       failure:(void (^)(NSError *error))failure;

+ (void)courseDetailToDoTaskWithacourseId:(NSString*)courseId
                                   taskId:(NSString *)taskId
                                  success:(void (^)(CourseDetail *courseDetail))success
                                  failure:(void (^)(NSError *error))failure;

//参数：
//userId           登陆用户id
//courseId       教程id
//name            教程编辑名称
//introduction     教程编辑内容
//authKey        参数加密验证码
//action           参数值固定  editCourse
//device           机器码
+(void)courseEdictWithUserId:(NSString *)userId courseId:(NSString *)courseId name:(NSString *)name introduction:(NSString *)introduction success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure;
@end
