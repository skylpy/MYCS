//
//  UIViewController+LeftItem.m
//  MYCS
//
//  Created by AdminZhiHua on 16/3/22.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "UIViewController+LeftItem.h"
#import <objc/runtime.h>
#import "ClassifyListViewController.h"
#import "MessageHomeViewController.h"
#import "TrainCourseDetailController.h"
#import "TrainSopDetailController.h"

@implementation UIViewController (LeftItem)

+ (void)load {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        Class class = [self class];
        
        Method ori_Method =  class_getInstanceMethod(class, @selector(viewDidLoad));
        Method my_Method = class_getInstanceMethod(class, @selector(leftItem_viewDidLoad));
        method_exchangeImplementations(ori_Method, my_Method);

    });
    
}

- (void)leftItem_viewDidLoad {
    [self leftItem_viewDidLoad];
    
    if ([self isKindOfClass:[ClassifyListViewController class]] || [self isKindOfClass:[MessageHomeViewController class]]|| [self isKindOfClass:[TrainCourseDetailController class]]|| [self isKindOfClass:[TrainSopDetailController class]])return;
    
    //聊天控制器的相册
    Class class = NSClassFromString(@"RCAlbumListViewController");
    if ([self isKindOfClass:class]) return;
    
    if ([self isKindOfClass:[UIViewController class]])
    {
        [self configLeftBarItem];
    }
}

- (void)configLeftBarItem {
    
    UIImage* backItemImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIImage* backItemHlImage = [[UIImage imageNamed:@"back"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIButton* backButton = [[UIButton alloc] init];
    
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    
    [backButton setTitleColor:self.navigationController.navigationBar.tintColor forState:UIControlStateNormal];
    
    [backButton setTitleColor:[self.navigationController.navigationBar.tintColor colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
    
    [backButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    
    [backButton setImage:backItemImage forState:UIControlStateNormal];
    
    [backButton setImage:backItemHlImage forState:UIControlStateHighlighted];
    [backButton sizeToFit];
    
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -8, 0, 0)];
    
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = item;
    
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
