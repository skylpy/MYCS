//
//  CustomAnimating.h
//  CustomTransition
//
//  Created by AdminZhiHua on 15/11/25.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Animating : NSObject<UIViewControllerAnimatedTransitioning>

//动画的时间
@property (nonatomic,assign) NSTimeInterval duration;

//动画类型
@property (nonatomic,assign) UIViewAnimationOptions options;


- (instancetype)initWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options;


@end
