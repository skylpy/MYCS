//
//  StatisticsModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/4.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface StatisticsModel : JSONModel

@property (strong, nonatomic) NSNumber<Optional> *total;

/**
 *  获取统计梗概
 *
 *  @param userID   登陆用户id
 *  @param userType 登录用户的类型
 *  @param month    月份，格式：yyyy-MM    默认为本月
 *  @param action  
 ========================================
 会员人数统计       member
 会员服务统计       server
 总收入            income
 总支出            payOut
 总销量            sell
 内训学习数量      studyTask
 学习总课程数      staffCourseCount
企业，机构和个人：
 学习总时长        studyHours
 教程总点播量       click
员工：
 总点播量          staffClick
 学习总时长        staffStudyHours

 ========================================
 *  @param success  成功返回块
 *  @param failure  失败返回块
 */
+ (void)requestStatisticsWithUserID:(NSString *)userID userType:(NSString *)userType month:(NSString *)month action:(NSString *)action success:(void (^)(StatisticsModel *statistics))success failure:(void (^)(NSError *error))failure;

@end
