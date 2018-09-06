//
//  AuthorLetterView.m
//  MYCS
//
//  Created by AdminZhiHua on 16/3/11.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AuthorLetterView.h"

@interface AuthorLetterView ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageConstHeight;
@property (weak, nonatomic) IBOutlet UIImageView *letterImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation AuthorLetterView

+ (void)showInWindow {
    
    AuthorLetterView *view = [[[NSBundle mainBundle] loadNibNamed:@"AuthorLetterView" owner:nil options:nil]lastObject];
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    //设置frame
    view.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    view.imageConstHeight.constant = (ScreenW-70)*3/2;

    [view layoutIfNeeded];
    
    [keyWindow addSubview:view];
    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self.bgView addGestureRecognizer:tapGest];
    
    self.bgView.alpha = 0;
    self.letterImageView.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bgView.alpha = 0.4;
        self.letterImageView.alpha = 1;
        
    }];
    
}

- (void)tapAction:(UIGestureRecognizer *)gest {
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.bgView.alpha = 0;
        self.letterImageView.alpha = 0;

    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
}



@end
