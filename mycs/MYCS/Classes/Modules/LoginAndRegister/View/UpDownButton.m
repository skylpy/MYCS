//
//  UpDownButton.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/14.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "UpDownButton.h"

@implementation UpDownButton

- (instancetype)initWithFrame:(CGRect)frame {
    //self = [super init];
    if ([super initWithFrame:frame]) {
        self.imageView.contentMode = UIViewContentModeCenter;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    
    if (!self.titleLabel.text) self.titleLabel.height = 20;
    
    CGFloat imageCenterX = (self.width - self.imageView.width)*0.5;
    CGFloat imageY = (self.height - self.imageView.height-self.titleLabel.height-6)*0.5;
    
    self.imageView.frame = CGRectMake(imageCenterX, imageY, self.imageView.width, self.imageView.height);
    
    CGFloat titleX = (self.width - self.titleLabel.width)*0.5;
    CGFloat titleY = CGRectGetMaxY(self.imageView.frame)+6;
    
    self.titleLabel.frame = CGRectMake(titleX, titleY, self.titleLabel.width, self.titleLabel.height);
    
}

@end
