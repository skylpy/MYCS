//
//  CoverView.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoverView : UIView

+ (instancetype)showInView:(UIView *)view frame:(CGRect)frame touchBlock:(void (^)(CoverView *view))touchBlock;

- (void)showAnimation;

- (void)dismiss;

@end
