//
//  VideoTitleButton.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "VideoTitleButton.h"

@implementation VideoTitleButton

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.titleLabel sizeToFit];
    [self.imageView sizeToFit];
    
    self.imageView.x = self.width-self.imageView.width-15;
    self.imageView.y = (self.height-self.imageView.height)*0.5;
    
    self.titleLabel.x = 15;
    self.titleLabel.y = (self.height-self.titleLabel.height)*0.5;
    self.titleLabel.width = CGRectGetMaxX(self.imageView.frame)-15-20;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (self.selected)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.transform = CGAffineTransformRotate(self.imageView.transform, M_PI);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.imageView.transform = CGAffineTransformIdentity;
        }];
    }
    
}


@end
