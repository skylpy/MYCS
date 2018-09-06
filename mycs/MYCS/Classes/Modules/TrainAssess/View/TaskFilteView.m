//
//  TaskFilteView.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskFilteView.h"

@interface TaskFilteView ()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *bgButton;

@property (nonatomic,copy) void(^actionBlock)(NSUInteger idx);

@end

@implementation TaskFilteView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self showWithAnimation];
    
}

+ (instancetype)showInView:(UIView *)superView belowView:(UIView *)belowView action:(void(^)(NSUInteger idx))actionBlock{
    
    TaskFilteView *filteView = [[[NSBundle mainBundle] loadNibNamed:@"TaskFilteView" owner:nil options:nil]lastObject];
    
    filteView.frame = [UIScreen mainScreen].bounds;
    
//    if (!iS_IOS8LATER)
//    {
//        filteView.y = 32;
//    }
//    
//    [superView insertSubview:filteView belowSubview:belowView];
    
    filteView.actionBlock = actionBlock;
    
    return filteView;
}

- (void)showWithAnimation {
    
    self.contentView.transform = CGAffineTransformTranslate(self.contentView.transform, 0, -176);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.contentView.transform = CGAffineTransformTranslate(self.contentView.transform, 0, 176+64);
    }];
    
}

- (void)dismissWithAnimation {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.contentView.transform = CGAffineTransformTranslate(self.contentView.transform, 0, -176-64);
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}

- (IBAction)bgAction:(UIButton *)sender {
    
    if (self.actionBlock) {
        self.actionBlock(sender.tag);
    }
    
    [self dismissWithAnimation];
    
}

- (IBAction)allButtonAction:(UIButton *)sender {

    if (self.actionBlock) {
        self.actionBlock(sender.tag);
    }
    
    [self dismissWithAnimation];

}

- (IBAction)unJoinButtonAction:(UIButton *)sender {
    
    if (self.actionBlock) {
        self.actionBlock(sender.tag);
    }
    
    [self dismissWithAnimation];

}

- (IBAction)unPassButtonAction:(UIButton *)sender {
    
    if (self.actionBlock) {
        self.actionBlock(sender.tag);
    }
    
    [self dismissWithAnimation];

}

- (IBAction)hasPassButtonAction:(UIButton *)sender {
    
    if (self.actionBlock) {
        self.actionBlock(sender.tag);
    }
    
    [self dismissWithAnimation];

}


@end
