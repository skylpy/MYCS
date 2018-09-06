//
//  ActivityModel.h
//  MYCS
//
//  Created by AdminZhiHua on 15/9/25.
//  Copyright © 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ActivityModel : NSObject

/**< 活动id */
@property (nonatomic,copy) NSString *id;
/**< 活动标题 */
@property (nonatomic,copy) NSString *title;
/**<  */
@property (nonatomic,copy) NSString *sid;
/**< 发布时间 */
@property (nonatomic,copy) NSString *issueTime;
/**< 开始时间 */
@property (nonatomic,copy) NSString *startTime;
/**< 结束时间 */
@property (nonatomic,copy) NSString *endTime;
/**< 活动内容 */
@property (nonatomic,copy) NSString *describe;
/**< 活动规则 */
@property (nonatomic,copy) NSString *role;
/**< 活动状态 0:进行中  , 1:未开始  , 2:已结束 */
@property (nonatomic,copy) NSString *status;
/**< 图片地址 */
@property (nonatomic,copy) NSString *imgUrl;

+ (void)joinActivityWith:(NSString *)userId activityId:(NSString *)activityId success:(void(^)())success failure:(void (^)(NSError *error))failure;

+ (void)shareCompleteWith:(NSString *)userId activityId:(NSString *)activityId success:(void(^)())success failure:(void (^)(NSError *error))failure;

@end

@interface ActivityParamModel : NSObject

//活动详情
@property (nonatomic,copy) NSString *url;

//分享活动
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *linkUrl;
@property (nonatomic,copy) NSString *describe;

//公共
@property (nonatomic,copy) NSString *activityId;

//参加活动
@property (nonatomic,copy) NSString *userId;

//视频
@property (nonatomic,copy) NSString *videoId;

//教程
@property (nonatomic,copy) NSString *courseId;

//sop
@property (nonatomic,copy) NSString *sopId;

//医生
@property (nonatomic,copy) NSString *uid;




@end
