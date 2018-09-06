//
//  CheckCodeView.h
//  MYCS
//
//  Created by AdminZhiHua on 15/11/14.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckCodeView : UIView

@property (nonatomic,copy) NSString *phoneNumber;

@property (nonatomic,strong) void (^actionBlock)(CheckCodeView *view, NSString *code);

+ (instancetype)showInView:(UIViewController *)view WithPhone:(NSString *)phoneNumber complete:(void (^)(CheckCodeView *view, NSString *code))block;


@end
