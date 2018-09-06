//
//  SOPDownLoadView.h
//  MYCS
//
//  Created by AdminZhiHua on 16/2/2.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SopDetail;
@interface SOPDownLoadView : UIView

+ (instancetype)showWith:(SopDetail *)detail InView:(UIView *)superView belowView:(UIView *)belowView action:(void(^)(void))actionBlock;

@end
