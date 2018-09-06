//
//  CheckCodeView.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/14.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "CheckCodeView.h"
#import "UIImageView+WebCache.h"
#import "ConstKeys.h"

@interface CheckCodeView ()

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIImageView *codeView;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIView *textView;

@end

@implementation CheckCodeView

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.sureBtn.layer.cornerRadius = 4;
    self.sureBtn.layer.masksToBounds = YES;
    
    self.cancelBtn.layer.cornerRadius = 4;
    self.cancelBtn.layer.masksToBounds = YES;
    
    self.contentView.layer.borderColor = HEXRGB(0xaaaaaa).CGColor;
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.cornerRadius = 6;
    self.contentView.layer.masksToBounds = YES;
    
    self.textView.layer.borderColor = HEXRGB(0xaaaaaa).CGColor;
    self.textView.layer.borderWidth = 1;
    self.textView.layer.cornerRadius = 6;
    self.textView.layer.masksToBounds = YES;
    
    self.bgView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0.5;
    }];
    
}

+ (instancetype)showInView:(UIViewController *)view WithPhone:(NSString *)phoneNumber complete:(void (^)(CheckCodeView *, NSString *))block{
    
    CheckCodeView *checkView = [[[NSBundle mainBundle] loadNibNamed:@"CheckCodeView" owner:nil options:nil]lastObject];
    
    checkView.phoneNumber = phoneNumber;
    
    checkView.actionBlock = block;
    
    checkView.frame = view.navigationController.view.frame;
    
    [view.navigationController.view addSubview:checkView];
    
    return checkView;
}

- (void)setPhoneNumber:(NSString *)phoneNumber {
    _phoneNumber = phoneNumber;
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.mycs.cn%@?action=smsVerify&phone=%@",CAPTCHA_PATH,phoneNumber];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSData *codeData = [NSData dataWithContentsOfURL:url];
    self.codeView.image = [UIImage imageWithData:codeData];
    
}

- (IBAction)sureAction:(UIButton *)button {
    
    if (self.actionBlock) {
        self.actionBlock(self,self.inputTextField.text);
    }
    [self dissmiss];
}

- (IBAction)cancelBtn:(UIButton *)button {
    
    if (self.actionBlock) {
        self.actionBlock(self,nil);
    }
    [self dissmiss];
}

- (void)dissmiss {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}


@end
