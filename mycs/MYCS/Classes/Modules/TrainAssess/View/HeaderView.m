//
//  HeaderView.m
//  CityListWithIndex
//
//  Created by ljw on 16/7/19.
//  Copyright © 2016年 ljw. All rights reserved.
//

#import "HeaderView.h"


@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

- (void)setTitleString:(NSString *)titleString
{
    _titleString = titleString;
    
    
    
    _titleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _titleView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_titleView];
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 10)];
    _headView.backgroundColor = bgsColor;
    [_titleView addSubview:_headView];
    
    _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, CGRectGetMaxY(_headView.frame)+8, self.frame.size.width-16*2, 30)];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    [_titleView addSubview:_titleLabel];
    _titleLabel.text = titleString;
    
    
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleView.frame)-1, self.frame.size.width-20, 1)];
    lineView.backgroundColor = bgsColor;
    [_titleView addSubview:lineView];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
