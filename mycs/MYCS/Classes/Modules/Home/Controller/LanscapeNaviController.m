//
//  LanscapeNaviController.m
//  test
//
//  Created by AdminZhiHua on 15/10/8.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "LanscapeNaviController.h"
#import "Animating.h"

@interface LanscapeNaviController () <UIViewControllerTransitioningDelegate>

@end

@implementation LanscapeNaviController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.hidden = YES;

    if (!self.needToCustomDissmiss) return;

    // 自定义dismiss样式
    self.transitioningDelegate  = self;
    self.modalPresentationStyle = UIModalPresentationCustom;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscape;
}

#pragma mark - 自定义取消动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return [[Animating alloc] initWithDuration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft];
}

@end
