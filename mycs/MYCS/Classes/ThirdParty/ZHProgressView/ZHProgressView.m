//
//  ZHProgressView.m
//  SWWY
//
//  Created by zhihua on 15/5/3.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "ZHProgressView.h"

@implementation ZHProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (int)fontSize{
    
    if (!_fontSize) {
        _fontSize = 10;
    }
    return _fontSize;
}

- (int)lineWith{
    if (!_lineWith) {
        _lineWith = 4;
    }
    return _lineWith;
}

- (float)totalProgress{
    if (!_totalProgress) {
        _totalProgress = 100;
    }
    return _totalProgress;
}

- (void)setCurrentProgress:(float)currentProgress{
    _currentProgress = currentProgress;
    
    [self setNeedsDisplay];
}



- (void)drawRect:(CGRect)rect {
    
    CGFloat rectW = rect.size.width;
    CGFloat rectH = rect.size.height;
    
    //画背景圈
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //半径
    CGFloat radius = rectW * 0.5 - 6;
    
    CGContextAddArc(context, rectW * 0.5, rectH * 0.5, radius, 0, M_PI * 2, 0);
    
    [[UIColor grayColor] set];
    
    CGContextSetLineWidth(context, self.lineWith);
    
    CGContextStrokePath(context);
    
    
    //画进度圈
    CGFloat endAngle = (self.currentProgress / self.totalProgress) * 2 *M_PI - M_PI_2;
    
    CGContextAddArc(context, rectW * 0.5, rectH * 0.5, radius, -M_PI_2, endAngle, 0);
    
    [self.radiusColor set];
    
    CGContextStrokePath(context);
    
    //画进度比例
    CGFloat textW = 30;
    CGFloat textH = 20;
    CGFloat textX = (rectW - textW) * 0.5;
    CGFloat textY = (rectH - textH) * 0.5 + 5;
    
    int percentageCompleted = (int)(100.0f / self.totalProgress) * self.currentProgress;
    
    NSString *text = [NSString stringWithFormat:@"%d%%",percentageCompleted];
    
    [HEXRGB(0xffc35e) set];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    [text drawInRect:CGRectMake(textX, textY, textW, textH) withFont:[UIFont systemFontOfSize:self.fontSize] lineBreakMode:0 alignment:NSTextAlignmentCenter];
    
#pragma clang diagnostic pop

}

@end
