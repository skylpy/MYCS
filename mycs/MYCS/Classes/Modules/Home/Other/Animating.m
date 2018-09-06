//
//  CustomAnimating.m
//  CustomTransition
//
//  Created by AdminZhiHua on 15/11/25.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "Animating.h"

@implementation Animating

- (instancetype)init {
    return [self initWithDuration:0.5 options:0];
}

- (instancetype)initWithDuration:(NSTimeInterval)duration options:(UIViewAnimationOptions)options {
    self = [super init];
    if (self) {
        _options = options;
        _duration = duration;
    }
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning的代理方法
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return self.duration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    //即将消失的控制器
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    //即将显示的控制器
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    toVC.view.frame = [transitionContext finalFrameForViewController:toVC];
    [toVC.view layoutIfNeeded];
    
    //判断option是否是UIViewAnimationOptionShowHideTransitionViews
    BOOL optionsContainShowHideTransitionViews = (self.options & UIViewAnimationOptionShowHideTransitionViews) != 0;
    
    if (!optionsContainShowHideTransitionViews) {
        [[transitionContext containerView] addSubview:toVC.view];
    }
    
    //执行转场动画
    [UIView transitionFromView:fromVC.view toView:toVC.view duration:self.duration options:self.options|UIViewAnimationOptionShowHideTransitionViews completion:^(BOOL finished) {
        if (!optionsContainShowHideTransitionViews) {
            [fromVC.view removeFromSuperview];
        }
        [transitionContext completeTransition:YES];
    }];
    
}

@end
