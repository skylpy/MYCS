//
//  TaskSelectView.m
//  MYCS
//
//  Created by yiqun on 16/8/31.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskSelectView.h"


@implementation TaskSelectView

- (void)setTitleString:(NSString *)titleString andColor:(UIColor *)color{
    
    _titleString = titleString;

    self.backgroundColor = bgsColor;
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 12, self.frame.size.width-20, 20)];
    _titleLabel.textColor = color;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:_titleLabel];
    _titleLabel.text = titleString;
    
    _icon = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-15, 15, 8, 15)];
    _icon.image = [UIImage imageNamed:@"arrows"];
    [self addSubview:_icon];
}

@end
