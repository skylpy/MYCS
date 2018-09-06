//
//  UMAnalyticsHelper.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/19.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "UMAnalyticsHelper.h"
#import <MobClick.h>

#define kUMAnalyticsAppKey @"5624b2cae0f55a23e1004b41"

@implementation UMAnalyticsHelper

+ (void)UMAnalyticStart {
    
    [MobClick startWithAppkey:kUMAnalyticsAppKey reportPolicy:BATCH channelId:@"App Store"];
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];

#if DEBUG
    [MobClick setLogEnabled:YES];
#endif
    
}

/****************调用本页面方法********************/

+ (void)beginLogPageView:(__unsafe_unretained Class)pageView {
    [MobClick beginLogPageView:NSStringFromClass(pageView)];
    return;
}

+ (void)endLogPageView:(__unsafe_unretained Class)pageView {
    [MobClick endLogPageView:NSStringFromClass(pageView)];
    return;
}

/****************调用自定义页面方法********************/

+ (void)beginLogPageName:(NSString *)pageName;{

    [MobClick beginLogPageView:pageName];
    return;
}

+ (void)endLogPageName:(NSString *)pageName{

    [MobClick endLogPageView:pageName];
    return;
}

/****************调用自定义事件方法********************/

+ (void)eventLogClick:(NSString *)eventId{

    [MobClick event:eventId];
    return;
}

+ (void)eventLogClick:(NSString *)eventId label:(NSString *)label{

    [MobClick event:eventId label:label];
    return;
}

@end
