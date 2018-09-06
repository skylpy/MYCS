//
//  BackButton.m
//  MYCS
//
//  Created by yiqun on 16/9/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "BackButton.h"
#define kTitleRatio 0.8
// 深灰——副级文字
#define lgrayColor ([UIColor colorWithRed:(153/255.0) green:((153)/255.0) blue:((153)/255.0) alpha:(1.0)])


@implementation BackButton

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:lgrayColor forState:UIControlStateHighlighted];
        [self setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"icon_back_gray"] forState:UIControlStateHighlighted];
        
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
        self.imageView.contentMode = UIViewContentModeLeft;
        
        self.titleLabel.textColor = [UIColor whiteColor];
        
        self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        self.titleLabel.numberOfLines = 1;
    }
    return self;
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state{
    
    [super setTitleColor:color forState:state];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    
    [super setImage:image forState:state];
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat X = 0;
    CGFloat Y = 0;
    CGFloat imageW = 20;
    CGFloat imageH = contentRect.size.height;
    _imageFrame.size.width = imageW;
    return CGRectMake(X, Y, imageW, imageH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    
    CGFloat titleH = contentRect.size.height ;
    CGFloat Y = 0;
    CGFloat titleW = contentRect.size.width;
    CGFloat X = CGRectGetMaxX(_imageFrame);
    return CGRectMake(X, Y, titleW, titleH);
    
}

@end
