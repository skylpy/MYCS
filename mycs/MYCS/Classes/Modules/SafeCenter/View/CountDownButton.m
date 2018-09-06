//
//  CountDownButton.m
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "CountDownButton.h"

@interface CountDownButton ()

@property (assign, nonatomic) int timeCount;

@end

@implementation CountDownButton

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.normalString = self.titleLabel.text;
}

- (void)startCountDown:(int)time
{
    //启动线程 倒计时验证码
    self.enabled = NO;
    self.timeCount = time;
    
    [self setTitle:[NSString stringWithFormat:@"剩余%d秒", self.timeCount] forState:UIControlStateNormal|UIControlStateDisabled];
    
    //repeats设为YES时每次 invalidate后重新执行，如果为NO，逻辑执行完后计时器无效
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerAdvanced:) userInfo:nil repeats:YES];
}

- (void)timerAdvanced:(NSTimer *)timer
{
    self.timeCount--;
    
    [self setTitle:[NSString stringWithFormat:@"剩余%d秒", _timeCount] forState:UIControlStateNormal|UIControlStateDisabled];
    
    if (_timeCount == 0)
    {
        [timer invalidate];
        self.enabled = YES;
        
        [self setTitle:self.normalString forState:UIControlStateNormal];
    }
}

- (void)setEnabled:(BOOL)enabled
{
    if (enabled)
    {
        self.backgroundColor = HEXRGB(0x47c2a9);
        
    } else
    {
        self.backgroundColor = HEXRGB(0xd1d1d1);
    }
    
    [super setEnabled:enabled];
}



@end
