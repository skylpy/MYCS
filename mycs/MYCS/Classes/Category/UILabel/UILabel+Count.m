//
//  UILabel+Count.m
//  MYCS
//
//  Created by wzyswork on 16/2/17.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "UILabel+Count.h"

@implementation UILabel (Count)


-(void)textWith:(NSString *)text andX:(CGFloat)x andY:(CGFloat)y
{
    if (text.intValue <= 0)return;
    
    if (text.intValue > 99)
    {
        text = @"99+";
    }
    self.text = text;
    
    int marginX = 7;
    int marginY = 12;
    
    if (ScreenW <= 330)
    {
        marginX = 10;
        marginY = 15;
    }
    else if(ScreenW > 400)
    {
        marginX = 5;
        marginY = 10;
    }
    
    
    self.frame = CGRectMake(x + marginX, y/2 - marginY + 3,25, 18);
    
    self.textAlignment = NSTextAlignmentCenter;
    
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.layer.borderWidth = 1;
    
    self.textColor = [UIColor whiteColor];
    
    self.backgroundColor = HEXRGB(0xFF463A);
    
    self.font = [UIFont systemFontOfSize:11];
    
    self.layer.cornerRadius = self.width / 2 - 4;
    
    self.clipsToBounds = YES;
}
@end
