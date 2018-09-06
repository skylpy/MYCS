//
//  UIView+Message.h
//  swwy_ipad
//
//  Created by Yell on 15/9/6.
//  Copyright (c) 2015年 zhihua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Message)


- (void)showError:(NSError *)error;

- (void)showErrorMessage:(NSString *)message;

- (void)showSuccessWithStatus:(NSString *)status;

- (void)showLoading;

- (void)showLoadingWithStatus:(NSString *)status;

- (void)dismissLoading;

@end
