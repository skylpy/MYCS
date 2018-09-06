//
//  PushBarView.m
//  MYCS
//
//  Created by wzyswork on 16/2/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "PushBarView.h"
#import <Accelerate/Accelerate.h>
#import <AudioToolbox/AudioToolbox.h>

@interface PushBarView ()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *detailLabel;
@property (nonatomic, strong) UIButton * closeButton;

@property (nonatomic, strong) UIButton * clickButton;

@end

@implementation PushBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self buildWindow];
    }
    return self;
}
- (void)buildWindow
{
    self.userInteractionEnabled = YES;
    self.hidden = NO;
    self.autoresizesSubviews = YES;
    self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.800];
    
    self.frame = CGRectMake(0, -64, ScreenH, 74);
    
    [self addSubview:self.iconView];
    [self addSubview:self.nameLabel];
    [self addSubview:self.detailLabel];
    [self addSubview:self.closeButton];
    
}

- (UIImageView *)iconView;
{
    if (!_iconView)
    {
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 25, 15, 15)];
        _iconView.clipsToBounds = YES;
    }
    return _iconView;
}
- (UILabel *)nameLabel;
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, ScreenW - 100,15)];
        _nameLabel.textColor = [UIColor whiteColor];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.font = [UIFont systemFontOfSize:14.0];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.clipsToBounds = YES;
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}
-(UIButton *)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_closeButton setImage:[UIImage imageNamed:@"delete_mouseenter"] forState:UIControlStateNormal];
    }
    
    return _closeButton;
}
-(UIButton *)clickButton
{
    if (!_clickButton)
    {
        _clickButton = [UIButton buttonWithType:UIButtonTypeCustom];
         _clickButton.frame = CGRectMake(0, 0, ScreenW - 50, 74);
        _clickButton.userInteractionEnabled = YES;
        _clickButton.enabled = YES;
        [_clickButton addTarget:self action:@selector(clickButtonAction) forControlEvents:UIControlEventTouchUpInside];
        _clickButton.backgroundColor = [UIColor clearColor];
    }
    
    return _clickButton;
}
- (UILabel *)detailLabel;
{
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,35,ScreenW - 100,30)];
        _detailLabel.textColor = [UIColor whiteColor];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:13.0];
        _detailLabel.textAlignment = NSTextAlignmentLeft;
        _detailLabel.clipsToBounds = YES;
        _detailLabel.numberOfLines = 2;
    }
    return _detailLabel;
}
#pragma --mark getter
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_pushBarClickBlock)
    {
        _pushBarClickBlock(self,self.model);
    }
}

-(void)clickButtonAction
{
    self.clickButton.enabled = NO;
    if (_pushBarClickBlock)
    {
        _pushBarClickBlock(self,self.model);
    }
}

-(void)handleClickAction:(PushBarClickBlock)pushBarClickBlock
{
    _pushBarClickBlock = pushBarClickBlock;
}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath  *round = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((ScreenW-35)/2, 74-12, 35, 5) byRoundingCorners:(UIRectCornerAllCorners) cornerRadii:CGSizeMake(10, 10)];
    [[UIColor greenColor] setFill];
    
    [round fill];
}

-(void)showWithModel:(PushModel *)model DismissAfter:(NSTimeInterval)time
{
    _model = model;
    
    UISwipeGestureRecognizer *recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
    
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
    
    [self addGestureRecognizer:recognizer];
    
    AudioServicesPlaySystemSound(1007);
    
    self.nameLabel.text = model.title;
    self.detailLabel.text = model.details;
    
    self.iconView.image = [UIImage imageNamed:@"pushIcon"];
    
    self.iconView.frame = CGRectMake(15, 25, 15, 15);
    
    
    self.nameLabel.frame = CGRectMake(50, 20, ScreenW - 100,15);
    
    
    self.detailLabel.frame = CGRectMake(50,35,ScreenW - 100,30);
    
    self.detailLabel.numberOfLines = 2;
    
    _closeButton.frame = CGRectMake(ScreenW - 50, 20, 50, 54);
    
    self.frame = CGRectMake(0, 0, ScreenW,74);
    
    [self setNeedsDisplay];
    
    [self performSelector:@selector(dismiss) withObject:nil afterDelay:time];
}

-(void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer{
    
    if(recognizer.direction == UISwipeGestureRecognizerDirectionUp)
    {
        [self dismiss];
    }
}

- (void)dismiss
{
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.y = -self.height;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}

@end
