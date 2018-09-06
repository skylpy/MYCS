//
//  TaskFilteView.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskFilteView : UIView

+ (instancetype)showInView:(UIView *)superView belowView:(UIView *)belowView action:(void(^)(NSUInteger idx))actionBlock;

@end
