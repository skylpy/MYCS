//
//  SourceViewCell.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/11.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SourceViewCell.h"

#define kMarginWith 25

@interface SourceViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIImageView *arrowView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonLeftConst;
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation SourceViewCell

- (IBAction)chooseButtonAction:(UIButton *)button{
    
    button.selected = !button.selected;
    
    if (self.chooseButtonAction)
    {
        self.chooseButtonAction(self,button);
    }
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.lineView.backgroundColor = HEXRGB(0xD7D7D7);
}

- (void)setupWithTitle:(NSString *)title level:(NSInteger)level chooseButtonSelected:(BOOL)selected {
    
    self.titleL.text = title;
    
    self.buttonLeftConst.constant = kMarginWith*level;
    [self layoutIfNeeded];
    
    self.chooseButton.selected = selected;
}

- (void)setArrowHiden:(BOOL)hiden {
    self.arrowView.hidden = hiden;
}

- (BOOL)isArrowHiden {
    return self.arrowView.hidden;
}

- (void)setArrowDirection:(BOOL)expand {
    
    if (expand)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowView.transform = CGAffineTransformRotate(self.arrowView.transform, M_PI);
        }];
    }
    else
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.arrowView.transform = CGAffineTransformIdentity;
        }];
    }
}

@end
