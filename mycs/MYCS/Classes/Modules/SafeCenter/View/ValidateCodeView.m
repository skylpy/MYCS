//
//  ValidateCodeView.m
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ValidateCodeView.h"

#import "APIClient.h"

#import "UIViewController+Message.h"

@interface ValidateCodeView ()<UITextFieldDelegate>

@property (nonatomic , strong) IBOutlet UITextField *tfCode;

@property (nonatomic , strong) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIImageView *codeImage;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (nonatomic , strong) UIControl *controlView;

@property (copy) void (^completion)(NSString *validateCode);

@property (nonatomic,copy) NSString *phoneNumber;

@end

@implementation ValidateCodeView

+ (void)popWithView:(UIView*)aView phoneNumber:(NSString *)phoneNumber Completion: (void(^)(NSString *validateCode))completion
{
    UIControl *controlView = [[UIControl alloc] initWithFrame:aView.bounds];
    controlView.backgroundColor = [UIColor blackColor];
    controlView.alpha = 0.5;
    [aView addSubview:controlView];
    
    ValidateCodeView *popView = [[[NSBundle mainBundle] loadNibNamed:@"ValidateCodeView" owner:self options:nil] lastObject];
    
    popView.phoneNumber = phoneNumber;
    
    //异步下载图片
    [popView performSelectorInBackground:@selector(initCodeImage:) withObject:popView];
    
    popView.completion = completion;
    popView.controlView = controlView;
    popView.center = CGPointMake(aView.center.x, aView.center.y-50);
    popView.layer.borderWidth = 1.f;
    popView.layer.borderColor = RGBCOLOR(180, 180, 180).CGColor;
    popView.layer.cornerRadius = 8;
    [aView addSubview:popView];
}

- (void)initCodeImage:(ValidateCodeView *)popView
{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://www.swwy.com/app/apps/captcha.php?action=smsVerify&phone=%@",popView.phoneNumber];
    
    //设置验证码
    NSURL *url = [NSURL URLWithString:urlStr];
    
    NSData *codeData = [NSData dataWithContentsOfURL:url];
    
    popView.codeImage.image = [UIImage imageWithData:codeData];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = RGBCOLOR(210, 210, 210).CGColor;
    self.bgView.layer.cornerRadius = 6;
    
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    
    self.cancelBtn.layer.cornerRadius = 5;
    self.cancelBtn.layer.masksToBounds = YES;
}

- (IBAction)doneBtnAction:(id)sender
{
    
    if (self.completion)
    {
        self.completion(self.tfCode.text);
        
        [self deleteBtnAction:nil];
    }

}

- (IBAction)deleteBtnAction:(UIButton*)sender{
    
    [self.tfCode resignFirstResponder];
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [self.controlView removeFromSuperview];
    [self removeFromSuperview];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
