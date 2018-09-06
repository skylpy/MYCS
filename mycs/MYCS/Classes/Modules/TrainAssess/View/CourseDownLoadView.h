//
//  CourseDownLoadView.h
//  MYCS
//
//  Created by AdminZhiHua on 16/2/2.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CourseDetail;
@interface CourseDownLoadView : UIView

+ (instancetype)showWith:(CourseDetail *)detail InView:(UIView *)superView belowView:(UIView *)belowView action:(void(^)(void))actionBlock;

@end

typedef NS_ENUM(NSUInteger,CacheBtnStatus) {
    CacheBtnStatusNormal,
    CacheBtnStatusAddNoComplete,
    CacheBtnStatusAddComplete
};

@interface CacheCahpterBtn : UIButton

@property (nonatomic,assign) CacheBtnStatus status;

@end

@interface AllCacheBtn : UIButton

- (void)updateBadgeNumber;

@end