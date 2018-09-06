//
//  UIScrollView+SpringHeadView.h
//  Sample
//
//  Created by AdminZhiHua on 15/12/2.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (SpringHeadView)<UIScrollViewDelegate>

@property (nonatomic, weak) UIView *topView;

- (void)addSpringHeadView:(UIView *)view;

@end


