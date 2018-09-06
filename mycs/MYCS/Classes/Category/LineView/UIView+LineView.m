//
//  UIView+LineView.m
//  test
//
//  Created by AdminZhiHua on 15/12/7.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "UIView+LineView.h"
#import <objc/runtime.h>

#define ColorWithHex(value,alph) [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16)/255.0) green:((float)((value & 0x00FF00) >> 8)/255.0) blue:((float)(value & 0x0000FF)/255.0) alpha:(alph)]

@implementation UIView (LineView)

static const char *kLineColor = "kLineColor";
static const char *kLineType = "kLineType";


- (UIColor *)lineColor {
    
    id color = objc_getAssociatedObject(self, kLineColor);

    //返回默认的颜色
    if (!color) return ColorWithHex(0xD7D7D7, 1.0);
    
    return color;
}

- (void)setLineColor:(UIColor *)lineColor {
    
    objc_setAssociatedObject(self, kLineColor, lineColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addLineWithLineType:self.lineType];
    
}

- (LineViewType)lineType {
    NSNumber *value = objc_getAssociatedObject(self, kLineType);
    return [value intValue];
}

- (void)setLineType:(LineViewType)lineType {
    objc_setAssociatedObject(self, kLineType, @(lineType), OBJC_ASSOCIATION_ASSIGN);
}

- (void)addLineWithLineType:(LineViewType)type
{
    self.lineType = type;
    
    if (type & LineViewTypeTop) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = self.lineColor.CGColor;
        layer.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), .5);
        [self.layer addSublayer:layer];
    }
    
    if (type & LineViewTypeLeft) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = self.lineColor.CGColor;
        layer.frame = CGRectMake(0, 0, .5, CGRectGetHeight(self.bounds));
        [self.layer addSublayer:layer];
    }
    
    if (type & LineViewTypeBottom) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = self.lineColor.CGColor;
        layer.frame = CGRectMake(0, CGRectGetHeight(self.bounds), CGRectGetWidth(self.bounds), .5);
        [self.layer addSublayer:layer];
    }
    
    if (type & LineViewTypeRight) {
        CALayer *layer = [CALayer layer];
        layer.backgroundColor = self.lineColor.CGColor;
        layer.frame = CGRectMake(CGRectGetWidth(self.bounds), 0, .5, CGRectGetHeight(self.bounds));
        [self.layer addSublayer:layer];
    }
}

@end

