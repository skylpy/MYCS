//
//  BindPhoneController.m
//  MYCS
//
//  Created by wzyswork on 16/1/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "BindPhoneController.h"

#import "UserCenterModel.h"

#import "CheckCodeView.h"
#import "CountDownButton.h"

@interface BindPhoneController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *identifyTextField;

@property (weak, nonatomic) IBOutlet CountDownButton *sendIdentifyButton;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIView *showView;

@end

@implementation BindPhoneController

#pragma mark - 样式设置
-(void)setUI{
  
    self.identifyTextField.delegate = self;
    self.phoneTextField.delegate = self;
    
    self.sendIdentifyButton.layer.cornerRadius = 4.0;
    self.sendIdentifyButton.clipsToBounds = YES;
    
    self.sureButton.layer.cornerRadius = 4.0;
    self.sureButton.clipsToBounds = YES;
    
    self.phoneTextField.layer.cornerRadius = 4.0;
    self.phoneTextField.clipsToBounds = YES;
    
    self.identifyTextField.layer.cornerRadius = 4.0;
    self.identifyTextField.clipsToBounds = YES;
    
    self.identifyTextField.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.identifyTextField.layer.borderWidth = 1;
    
    self.phoneTextField.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.phoneTextField.layer.borderWidth = 1;
    
    self.phoneTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
    self.phoneTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.identifyTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
    self.identifyTextField.leftViewMode = UITextFieldViewModeAlways;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.phoneTextField];
}
#pragma mark - phoneTextField.text改变通知
-(void)TextFieldTextDidChange:(NSNotification * )noty{

    self.phoneTextField = noty.object;
    
    if (self.phoneTextField.text.length >= 11)
    {
        self.sendIdentifyButton.backgroundColor = HEXRGB(0x47c2a9);
        
        self.sendIdentifyButton.enabled = YES;
        
    }else
    {
        
        self.sendIdentifyButton.backgroundColor = HEXRGB(0xd1d1d1);
        self.sendIdentifyButton.enabled = NO;
    }
  
}
- (IBAction)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 发送验证码Action
- (IBAction)sendIdentifyAction:(CountDownButton *)sender {
    
    [self.phoneTextField resignFirstResponder];
    
    if (self.phoneTextField.text.length == 0)
    {
        
        [self showErrorMessage:@"请输入绑定手机号"];
        
        return;
    }
    if (self.phoneTextField.text.length != 11)
    {
        
        [self showErrorMessage:@"手机号为11位数"];
        
        return;
    }
    
    NSString * phoneStr = [self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [CheckCodeView showInView:self WithPhone:phoneStr complete:^(CheckCodeView *view, NSString *code) {
        
        if (code == nil || code.length == 0)return;
        
        [self showLoadingHUD];
        [UserCenterModel sendPhoneCaptchaCode:code Phone:phoneStr andAction:@"send" uccess:^{
            
            [self dismissLoadingHUD];
            
            [sender startCountDown:90];
            
            self.showView.hidden = NO;
            [UIView animateWithDuration:2 animations:^{
                
                self.showView.alpha = 0;
                
            } completion:^(BOOL finished) {
                
                self.showView.hidden = YES;
                self.showView.alpha = 1;
                
            }];
        } failure:^(NSError *error) {
        
            [self dismissLoadingHUD];
            
            [self showError:error];
            
        }];
        
    }];

}

#pragma mark - 确定Action
- (IBAction)sureAction:(id)sender
{
    [self.identifyTextField resignFirstResponder];
    
    if (self.phoneTextField.text.length == 0)
    {
        
        [self showErrorMessage:@"请输入绑定手机号"];
        
        return;
    }
    
    if (self.phoneTextField.text.length != 11)
    {
        
        [self showErrorMessage:@"手机号为11位数"];
        
        return;
    }
    
    if (self.identifyTextField.text.length == 0)
    {
        
        [self showErrorMessage:@"请输入手机号验证码"];
        
        return;
    }
    [self showLoadingHUD];
    
    NSString * phoneStr = [self.phoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString * phoneCodeStr = [self.identifyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [UserCenterModel changeBindPhoneWithMobile:phoneStr Code:phoneCodeStr userId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] uccess:^{
        
        [self dismissLoadingHUD];
        
        [self showSuccessWithStatusHUD:@"绑定手机成功"];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self.navigationController popViewControllerAnimated:YES];
            
            if (self.SafeCenterDataRefleshBlock)
            {
                self.SafeCenterDataRefleshBlock();
            }
        });
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        
        [self showError:error];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
