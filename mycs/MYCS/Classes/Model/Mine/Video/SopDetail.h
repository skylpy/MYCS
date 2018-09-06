//
//  SopDetail.h
//  SWWY
//
//  Created by 黄希望 on 15-1-16.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "SopList.h"
#import "User.h"
#import "SopCourseModel.h"

/**
 *  SOP 详情类 继承自 Sop 类
 */
@interface SopDetail : JSONModel

@property (nonatomic,strong) NSString *id;
@property (nonatomic,strong) NSString *mp4Url;              // 视频地址
@property (nonatomic,strong) NSString *category;            // 分类
@property (nonatomic,assign) int personPrice;               // 个人价格
@property (nonatomic,assign) int groupPrice;                // 团队价格
@property (nonatomic,assign) int commentType;               // 评论类型
@property (nonatomic,strong) NSString *commentCId;                // 评论的cid
@property (nonatomic,copy) NSString *link_url;      // 对应网页地址
@property (nonatomic,strong) NSString *author;
@property (nonatomic,assign) int click;
@property (nonatomic,assign) int commentTotal;
@property (nonatomic,assign) int ext_permission;
@property (nonatomic,assign) int int_permission;
@property (nonatomic,strong) NSString *duration;
@property (nonatomic,strong) NSString *introduction;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *picUrl;
@property (nonatomic,assign) int source;
@property (nonatomic,strong) NSArray<SopCourseModel> *sopCourse; // 学习章节数
@property (nonatomic,assign) int buy;
@property (nonatomic,strong) NSString *buy_cid;
@property (nonatomic,strong) NSString *check_word;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,copy) NSString *nextIndex;
@property (copy,nonatomic) NSString *up;
@property (copy,nonatomic) NSString *isPraise;

//@property (nonatomic,copy) NSString *id;

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

//当前任务课程索引
@property (nonatomic,assign) int courseIndex;
//当前任务章节索引
@property (nonatomic,assign) int chapterIndex;

@property (nonatomic,assign) int realCourseIndex;
@property (nonatomic,assign) int realChapterIndex;

//新增字段
@property (nonatomic,copy) NSString<Optional> *taskId;
@property (nonatomic,copy) NSString<Optional> *taskName;
@property (nonatomic,copy) NSString<Optional> *passRate;
@property (nonatomic,copy) NSString<Optional> *endTime;
@property (nonatomic,copy) NSString<Optional> *enterpriseName;

@property (nonatomic,copy) NSString *rank;
@property (nonatomic,copy) NSString *passNum;
//轮播图片数组
@property (nonatomic,copy) NSArray<Optional> *picList;
@property (nonatomic,copy) NSString<Optional> *interval_time;

/**
 *  Sop 详情接口
 *
 *  @param userId   登陆用户id
 *  @param userType 登录用户的类型
 *  @param action   参数值固定：detail
 *  @param sopId    sopId
 *  @param success  成功执行块
 *  @param failure  失败执行块
 */
+ (void)sopDetailWithsopId:(NSString*)sopId
                activityId:(NSString *)activityId
                 fromCache:(BOOL)isFromCache
                   success:(void (^)(SopDetail *sopDetail))success
                   failure:(void (^)(NSError *error))failure;


+ (void)sopDetailToDoTaskWithSopId:(NSString*)sopId taskId:(NSString *)taskId
                           success:(void (^)(SopDetail *sopDetail))success
                           failure:(void (^)(NSError *error))failure;

+ (void)addCollection:(NSString *)collectId collectionType:(NSString *)type Collect:(NSString *)collect success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

//userId           登陆用户id
//id                  教程sop模板ID
//name            教程编辑名称
//introduction     教程编辑内容
//authKey        参数加密验证码
//action           参数值固定  editSop
//device           机器码
+(void)sopEdictWithUserId:(NSString *)userId sopId:(NSString *)sopId name:(NSString *)name introduction:(NSString *)introduction success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure;
@end
