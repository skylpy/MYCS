//
//  WebViewDetailController.h
//  MYCS
//
//  Created by wzyswork on 16/2/3.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHWebViewController.h"

@interface WebViewDetailController : ZHWebViewController

@property (nonatomic, copy) NSString *urlStr;

@property (nonatomic, strong) UIImage *shareImage;

@property (nonatomic,assign) BOOL isCollege;

@end
