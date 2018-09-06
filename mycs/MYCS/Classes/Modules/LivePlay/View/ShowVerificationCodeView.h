//
//  ShowVerificationCodeView.h
//  MYCS
//
//  Created by GuiHua on 16/6/17.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowVerificationCodeView : UIView

+ (instancetype)showInView:(UIView *)superView actionBlock:(void (^)(ShowVerificationCodeView *view,NSString * idStr))actionBlock;

- (void)dissmissAcion;
- (void)showAction;
@end
