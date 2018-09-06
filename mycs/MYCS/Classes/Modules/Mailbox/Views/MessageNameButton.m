//
//  MessageTitleButton.m
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MessageNameButton.h"

@implementation MessageNameButton

-(void)setID:(NSString *)ID
{
    _ID=ID;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    int margin = 5;
    CGFloat titleW =self.frame.size.width/4*3-margin;
    self.titleLabel.frame = CGRectMake(margin, 0, titleW, self.frame.size.height);
    self.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.imageView.frame = CGRectMake(self.frame.size.width-19-5, (self.frame.size.height-19)/2, 19, 19);

    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [self setImage:[UIImage imageNamed:@"delete_mouseenter"] forState:UIControlStateNormal];
    
    [self setImage:[UIImage imageNamed:@"delete"] forState:UIControlStateHighlighted];
    
    self.titleLabel.font = [UIFont systemFontOfSize:12];
    
    self.layer.borderWidth = 0.5;
    [self.layer setCornerRadius:5.0];
    
    self.layer.borderColor = HEXRGB(0xD1D1D1).CGColor;
    self.titleLabel.textColor = HEXRGB(0x5381C3);

}

@end
