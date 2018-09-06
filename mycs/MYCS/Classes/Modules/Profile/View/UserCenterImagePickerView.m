//
//  UserCenterImagePickerView.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/17.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "UserCenterImagePickerView.h"

@interface UserCenterImagePickerView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation UserCenterImagePickerView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    //添加点击事件
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self.bgView addGestureRecognizer:tapGest];
    
    //显示动画
    [self showAnimation];
    
}

- (void)showAnimation {
    
    self.bgView.alpha = 0;
    self.bottomView.transform = CGAffineTransformTranslate(self.bottomView.transform, 0, 125);
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bottomView.transform = CGAffineTransformIdentity;
        self.bgView.alpha = 0.4;
    }];
}

+ (void)showWithComplete:(void(^)(UserCenterImagePickerView *view,NSUInteger index))block {
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    UserCenterImagePickerView *imagePickView = [[[NSBundle mainBundle] loadNibNamed:@"UserCenterImagePickerView" owner:nil options:nil]lastObject];
    
    imagePickView.completeBlock = block;
    
    imagePickView.frame = [UIScreen mainScreen].bounds;
    
    [window addSubview:imagePickView];
    
}

- (IBAction)takeAction:(UIButton *)sender {
    
    if (self.completeBlock) {
        self.completeBlock(self,sender.tag);
    }
    [self dismiss];
}

- (IBAction)selectAction:(UIButton *)sender {
    
    if (self.completeBlock) {
        self.completeBlock(self,sender.tag);
    }
    [self dismiss];
}

- (IBAction)tapAction:(id)sender {
    
    if (self.completeBlock) {
        self.completeBlock(self,0);
    }
    [self dismiss];
    
}

- (IBAction)cancleAction:(UIButton *)sender {
    
    if (self.completeBlock) {
        self.completeBlock(self,sender.tag);
    }
    
    [self dismiss];
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 animations:^{
       
        self.bgView.alpha = 0;
        self.bottomView.transform = CGAffineTransformTranslate(self.bottomView.transform, 0, 125);
        
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


@end
