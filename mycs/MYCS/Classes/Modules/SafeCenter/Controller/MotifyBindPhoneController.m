//
//  MotifyBindPhoneController.m
//  MYCS
//
//  Created by wzyswork on 16/1/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MotifyBindPhoneController.h"

#import "CountDownButton.h"
#import "CheckCodeView.h"

@interface MotifyBindPhoneController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *showView;


@property (weak, nonatomic) IBOutlet UITextField *newsPhoneTextField;


@property (weak, nonatomic) IBOutlet UITextField *newsIdentifyTextField;


@property (weak, nonatomic) IBOutlet CountDownButton *newsIdentifyButton;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation MotifyBindPhoneController

#pragma mark - 样式设置
-(void)setUI
{
   
    self.newsIdentifyTextField.delegate = self;
    self.newsPhoneTextField.delegate = self;
    
    
    self.newsIdentifyButton.layer.cornerRadius = 4.0;
    self.newsIdentifyButton.clipsToBounds = YES;
    
    self.sureButton.layer.cornerRadius = 4.0;
    self.sureButton.clipsToBounds = YES;
    
    
    self.newsIdentifyTextField.layer.cornerRadius = 4.0;
    self.newsIdentifyTextField.clipsToBounds = YES;
    
    self.newsIdentifyTextField.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.newsIdentifyTextField.layer.borderWidth = 1;
    
    self.newsPhoneTextField.layer.cornerRadius = 4.0;
    self.newsPhoneTextField.clipsToBounds = YES;
    
    self.newsPhoneTextField.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.newsPhoneTextField.layer.borderWidth = 1;
    
    
    self.newsPhoneTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
    self.newsIdentifyTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
    
    self.newsPhoneTextField.leftViewMode = UITextFieldViewModeAlways;
    self.newsIdentifyTextField.leftViewMode = UITextFieldViewModeAlways;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newTextFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:self.newsPhoneTextField];
    
}

#pragma mark - 当新电话Textfield输入大于11位数的时候，发送验证码按钮显示可点击状态
-(void)newTextFieldTextDidChange:(NSNotification * )noty{
    
    self.newsPhoneTextField = noty.object;
    
    if (self.newsPhoneTextField.text.length >= 11)
    {
        self.newsIdentifyButton.backgroundColor = HEXRGB(0x47c2a9);
        self.newsIdentifyButton.enabled = YES;
        
    }else
    {
        
        self.newsIdentifyButton.backgroundColor = HEXRGB(0xd1d1d1);
        self.newsIdentifyButton.enabled = NO;
        
        [self.newsIdentifyButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    }
    
}
- (IBAction)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 发送新手机验证码Action
- (IBAction)sendNewsIdentifyAction:(CountDownButton *)sender {
    
    [self.newsPhoneTextField resignFirstResponder];
    
    if (self.newsPhoneTextField.text.length == 0)
    {
        
        [self showErrorMessage:@"请输入新的绑定手机号"];
        
        return;
    }
    if (self.newsPhoneTextField.text.length != 11)
    {
        
        [self showErrorMessage:@"手机号为11位数"];
        
        return;
    }
    
    NSString * phoneStr = [self.newsPhoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [CheckCodeView showInView:self WithPhone:phoneStr complete:^(CheckCodeView *view, NSString *code){
        
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

#pragma mark - 确定修改绑定Action
- (IBAction)sureAction:(id)sender {
    
    [self.newsPhoneTextField resignFirstResponder];
    
    if (self.newsPhoneTextField.text.length != 11)
    {
        
        [self showErrorMessage:@"手机号为11位数"];
        
        return;
    }
    if (self.newsPhoneTextField.text.length == 0)
    {
        
        [self showErrorMessage:@"请输入新的绑定手机号"];
        
        return;
    }
    
    if (self.newsIdentifyTextField.text.length == 0)
    {
        
        [self showErrorMessage:@"请输入手机号验证码"];
        
        return;
    }
    
    [self showLoadingHUD];
    
    NSString * newphoneStr = [self.newsPhoneTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString * newphoneCodeStr = [self.newsIdentifyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    [UserCenterModel changeBindPhoneWithMobile:newphoneStr Code:newphoneCodeStr userId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] uccess:^{
        
        [self dismissLoadingHUD];
        
        [self showSuccessWithStatusHUD:@"修改绑定手机成功"];
        
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
