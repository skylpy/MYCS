//
//  AppDelegate.h
//  MYCS
//
//  Created by AdminZhiHua on 15/12/28.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Singleton.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

singleton_interface(AppDelegate)

    @property(strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) UINavigationController *rootNavi;

@property (nonatomic, strong) UIAlertView *alertView;

@property (nonatomic, strong) UITabBarController *mainTabBarController;

@end
