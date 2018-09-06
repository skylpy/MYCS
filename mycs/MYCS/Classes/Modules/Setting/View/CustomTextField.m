//
//  CustomTextField.m
//  SWWY
//
//  Created by zhihua on 15/6/26.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "CustomTextField.h"

@implementation CustomTextField

static CGFloat leftMargin = 30;

- (CGRect)textRectForBounds:(CGRect)bounds
{
    bounds.origin.x += leftMargin;
    
    return bounds;
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    bounds.origin.x += leftMargin;
    
    return bounds;
}

- (void)setMarginLeft:(CGFloat)marginLeft{
    _marginLeft = marginLeft;
    leftMargin = marginLeft;
    [self textRectForBounds:self.bounds];
    [self editingRectForBounds:self.bounds];
}

@end
