//
//  UMAnalyticsHelper.h
//  MYCS
//
//  Created by AdminZhiHua on 15/11/19.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import <Foundation/Foundation.h>

///对友盟统计功能的封装
@interface UMAnalyticsHelper : NSObject

///启动友盟统计功能
+ (void)UMAnalyticStart;


/****************调用本页面方法********************/

/// 在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)beginLogPageView:(__unsafe_unretained Class)pageView;

/// 在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)endLogPageView:(__unsafe_unretained Class)pageView;


/****************调用自定义页面方法********************/

/// 在viewWillAppear调用,才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)beginLogPageName:(NSString *)pageName;

/// 在viewDidDisappeary调用，才能够获取正确的页面访问路径、访问深度（PV）的数据
+ (void)endLogPageName:(NSString *)pageName;




/****************调用自定义事件方法********************/

// 自定义事件,数量统计.  @param  eventId 网站上注册的事件Id.
+ (void)eventLogClick:(NSString *)eventId;

/** 自定义事件,数量统计.
 使用前，请先到友盟App管理后台的设置->编辑自定义事件 中添加相应的事件ID，然后在工程中传入相应的事件ID
 @param  label 分类标签。不同的标签会分别进行统计，方便同一事件的不同标签的对比,为nil或空字符串时后台会生成和eventId同名的标签.
 */
+ (void)eventLogClick:(NSString *)eventId label:(NSString *)label; // label为nil或@""时，等同于 event:eventId label:eventId;

@end
