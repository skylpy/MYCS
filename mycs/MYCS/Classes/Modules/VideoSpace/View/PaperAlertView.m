//
//  PaperAlertView.m
//  SWWY
//
//  Created by GuoChenghao on 15/3/24.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "PaperAlertView.h"
#import "UIView+frameAccessor.h"
#import "UIImage+Color.h"

@interface PaperAlertView ()

@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong, nonatomic) IBOutlet UIButton *cancelBtn;
@property (strong, nonatomic) IBOutlet UIView *boxView;
@property (weak, nonatomic) IBOutlet UIButton *tipsBtn;
@property (weak, nonatomic) IBOutlet UIButton *dissmissBtn;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelBtnRightMargin;

@property (copy, nonatomic) void (^block)(PaperAlertView *UIAlertView, NSInteger buttonIndex);

@end

@implementation PaperAlertView

+ (instancetype)showInView:(UIView *)view message:(NSString *)message With:(AlertViewType)alertType usingBlock:(void (^)(PaperAlertView *alertView, NSInteger buttonIndex))block {
    
    PaperAlertView *alertView = [[[NSBundle mainBundle] loadNibNamed:@"PaperAlertView" owner:nil options:nil] lastObject];
    
    alertView.alertType = alertType;
    alertView.block = block;
    alertView.message = message;
    
    alertView.frame = view.bounds;
    [view addSubview:alertView];
    
    return alertView;
}

- (void)setMessage:(NSString *)message
{
    _message = message;
    [self.tipsBtn setTitle:message forState:UIControlStateNormal];
}

- (void)setType:(NSInteger)type
{
    _type = type;
    
    if (type == 1) {
        self.sureBtn.hidden = YES;
        self.cancelBtnRightMargin.constant = 149;
        [self.cancelBtn setTitle:@"确定" forState:UIControlStateNormal];
    } else {
        self.sureBtn.hidden = NO;
        self.cancelBtnRightMargin.constant = 70;
    }
}

- (void)awakeFromNib{
    
    [super awakeFromNib];
    self.tipsBtn.titleLabel.numberOfLines = 0;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = HEXRGB(0x47c1a9).CGColor;
    
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    
    self.cancelBtn.layer.cornerRadius = 5;
    self.cancelBtn.layer.masksToBounds = YES;
    
}

- (void)setAlertType:(AlertViewType)alertType{
    
    _alertType = alertType;
    
    switch (alertType) {
        case AlertViewTypeSubmit:
        {
            self.dissmissBtn.hidden = YES;
            
            self.sureBtn.hidden = NO;
            [self.sureBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.sureBtn setImage:nil forState:UIControlStateNormal];
            [self.sureBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0x999999)] forState:UIControlStateNormal];
            [self.sureBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0x808080)] forState:UIControlStateHighlighted];
            
            self.cancelBtn.hidden = NO;
            [self.cancelBtn setTitle:@"确定" forState:UIControlStateNormal];
            [self.cancelBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0x47c1a9)] forState:UIControlStateNormal];
            [self.cancelBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0x4c9183)] forState:UIControlStateHighlighted];
            
            self.cancelBtnRightMargin.constant = 70;
            
        }
            break;
        case AlertViewTypeNext:
        {
            self.dissmissBtn.hidden = YES;
            
            self.sureBtn.hidden = NO;
            [self.sureBtn setTitle:@"取消" forState:UIControlStateNormal];
            [self.sureBtn setImage:nil forState:UIControlStateNormal];
            [self.sureBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0x999999)] forState:UIControlStateNormal];
            [self.sureBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0x808080)] forState:UIControlStateHighlighted];
            
            self.cancelBtn.hidden = NO;
            [self.cancelBtn setTitle:@"确定" forState:UIControlStateNormal];
            [self.cancelBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0x47c1a9)] forState:UIControlStateNormal];
            [self.cancelBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0x4c9183)] forState:UIControlStateHighlighted];
            self.cancelBtnRightMargin.constant = 70;
            
        }
            break;
        case AlertViewTypeCheckAll:
        {
            self.dissmissBtn.hidden = YES;
            
            self.sureBtn.hidden = YES;
            
            self.cancelBtn.hidden = NO;
            [self.cancelBtn setTitle:@"确定" forState:UIControlStateNormal];
            [self.cancelBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0x47c1a9)] forState:UIControlStateNormal];
            [self.cancelBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0x4c9183)] forState:UIControlStateHighlighted];
            self.cancelBtnRightMargin.constant = 149;

        }
            break;
        case AlertViewTypePass:
        {
            self.dissmissBtn.hidden = NO;
            
            self.sureBtn.hidden = NO;
            [self.sureBtn setTitle:@"重播" forState:UIControlStateNormal];
            [self.sureBtn setImage:[UIImage imageNamed:@"rebroadcast"] forState:UIControlStateNormal];
            [self.sureBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0xfe6263)] forState:UIControlStateNormal];
            [self.sureBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0xd15050)] forState:UIControlStateHighlighted];

            self.cancelBtn.hidden = NO;
            [self.cancelBtn setTitle:@"确定" forState:UIControlStateNormal];
            [self.cancelBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0x47c1a9)] forState:UIControlStateNormal];
            [self.cancelBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0x4c9183)] forState:UIControlStateHighlighted];
            self.cancelBtnRightMargin.constant = 70;

        }
            break;
        case AlertViewTypeUnPass:
        {
            self.dissmissBtn.hidden = YES;
            
            self.sureBtn.hidden = NO;
            [self.sureBtn setTitle:@"重播" forState:UIControlStateNormal];
            [self.sureBtn setImage:[UIImage imageNamed:@"rebroadcast"] forState:UIControlStateNormal];
            [self.sureBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0xfe6263)] forState:UIControlStateNormal];
            [self.sureBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0xd15050)] forState:UIControlStateHighlighted];
            
            self.cancelBtn.hidden = NO;
            [self.cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
            [self.cancelBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0x47c1a9)] forState:UIControlStateNormal];
            [self.cancelBtn setBackgroundImage:[UIImage imageFromContextWithColor:HEXRGB(0x4c9183)] forState:UIControlStateHighlighted];
            self.cancelBtnRightMargin.constant = 70;
            
        }
            break;
            
        default:
            break;
    }
    
}

#pragma mark - button action
- (IBAction)sureAction:(UIButton *)sender {
    if (self.block) {
        self.block(self, sender.tag);
    }
}

- (IBAction)cancelAction:(UIButton *)sender {
    if (self.block) {
        self.block(self, sender.tag);
    }
}

- (IBAction)dismissAction:(UIButton *)sender {
    if (self.block) {
        self.block(self, sender.tag);
    }
}

- (void)dealloc {
    NSLog(@"AlertView has dealloc!");
}

@end
