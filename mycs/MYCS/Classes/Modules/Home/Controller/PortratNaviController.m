//
//  PortratNaviController.m
//  MYCS
//
//  Created by AdminZhiHua on 15/10/9.
//  Copyright © 2015年 GuoChenghao. All rights reserved.
//

#import "PortratNaviController.h"
#import "UIImage+Color.h"

@interface PortratNaviController () <UIGestureRecognizerDelegate>

@end

@implementation PortratNaviController

+ (void)load {
    //设置全局样式
    NSDictionary *attribute = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

    [[UINavigationBar appearance] setTitleTextAttributes:attribute];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    UIImage *bgImage = [UIImage imageWithColor:HEXRGB(0x47c1a9)];
    [[UINavigationBar appearance] setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];

    //隐藏导航条的线
    [UINavigationBar appearance].shadowImage = [UIImage new];
    if (iS_IOS8LATER)
    {
        [UINavigationBar appearance].translucent = NO;
    }

    //设置导航标题的大小样式
    NSMutableDictionary *titleAttr            = [NSMutableDictionary dictionary];
    titleAttr[NSFontAttributeName]            = [UIFont fontWithName:@"Helvetica" size:18];
    titleAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];

    [UINavigationBar appearance].titleTextAttributes = titleAttr;

    //设置UIBarbuttonItem的大小样式
    UIBarButtonItem *item                    = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttr            = [NSMutableDictionary dictionary];
    itemAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    itemAttr[NSFontAttributeName]            = [UIFont fontWithName:@"Helvetica" size:15];
    [item setTitleTextAttributes:itemAttr forState:UIControlStateNormal];

    //隐藏返回按钮的标题
    [item setBackButtonTitlePositionAdjustment:UIOffsetMake(0, -60) forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


@end
