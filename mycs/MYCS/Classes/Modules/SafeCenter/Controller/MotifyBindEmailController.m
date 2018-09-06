//
//  MotifyBindEmailController.m
//  MYCS
//
//  Created by wzyswork on 16/1/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MotifyBindEmailController.h"

#import "CountDownButton.h"

@interface MotifyBindEmailController ()<UITextFieldDelegate>


@property (weak, nonatomic) IBOutlet UITextField *newsEmailTextField;

@property (weak, nonatomic) IBOutlet UITextField *newsIdentifyTextField;


@property (weak, nonatomic) IBOutlet CountDownButton *newsIdentifyButton;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UIView *PromptView;

@end

@implementation MotifyBindEmailController

#pragma mark - 设置样式
-(void)setUI
{
   
    self.newsEmailTextField.delegate = self;
    self.newsIdentifyTextField.delegate = self;
    
    
    self.newsIdentifyButton.layer.cornerRadius = 4.0;
    self.newsIdentifyButton.clipsToBounds = YES;
    
    self.sureButton.layer.cornerRadius = 4.0;
    self.sureButton.clipsToBounds = YES;
    
    
    self.newsIdentifyTextField.layer.cornerRadius = 4.0;
    self.newsIdentifyTextField.clipsToBounds = YES;
    self.newsIdentifyTextField.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.newsIdentifyTextField.layer.borderWidth = 1;
    
    self.newsEmailTextField.layer.cornerRadius = 4.0;
    self.newsEmailTextField.clipsToBounds = YES;
    self.newsEmailTextField.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.newsEmailTextField.layer.borderWidth = 1;
    
    
    self.newsEmailTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
    self.newsIdentifyTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
    
    self.newsEmailTextField.leftViewMode = UITextFieldViewModeAlways;
    self.newsIdentifyTextField.leftViewMode = UITextFieldViewModeAlways;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldTextDidEndEdict:) name:UITextFieldTextDidEndEditingNotification object:self.newsEmailTextField];
}

-(void)TextFieldTextDidEndEdict:(NSNotification * )noty
{
    
    if (self.newsEmailTextField == noty.object)
    {
        self.newsIdentifyButton.backgroundColor = HEXRGB(0x47c2a9);
        self.newsIdentifyButton.enabled = YES;
    }
    
}
- (IBAction)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 发送新邮箱验证码Action
- (IBAction)getNewsEmailIdentifyAction:(CountDownButton *)sender {
    
    if (self.newsEmailTextField.text.length == 0)
    {
        
        [self showErrorMessage:@"请输入新的绑定邮箱"];
        
        return;
    }
    
    NSString * emailStr = [self.newsEmailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [self showLoadingHUD];
    [UserCenterModel sendCodeWithEmail:emailStr andType:@"newEmail" success:^{
        
        [self dismissLoadingHUD];
        
        [sender startCountDown:90];
        
        self.PromptView.hidden = NO;
        [UIView animateWithDuration:2 animations:^{
            
            self.PromptView.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            self.PromptView.hidden = YES;
            self.PromptView.alpha = 1;
            
        }];
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        
        [self showError:error];
        
    }];
    
    
}

#pragma mark - 确定修改Action
- (IBAction)sureAction:(id)sender {
    
    if (self.newsEmailTextField.text.length == 0)
    {
        
        [self showErrorMessage:@"请输入新的绑定邮箱"];
        
        return;
    }
    
    if (self.newsIdentifyTextField.text.length == 0)
    {
        
        [self showErrorMessage:@"请输入新的绑定邮箱的验证码"];
        
        return;
    }
    
    
    NSString * newemailStr = [self.newsEmailTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    
    NSString * newemailStrCode = [self.newsIdentifyTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [UserCenterModel changeBindEmailWithEmail:newemailStr Code:newemailStrCode userId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] uccess:^{
        
        [self dismissLoadingHUD];
        
        [self showSuccessWithStatusHUD:@"修改绑定邮箱成功"];
        
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
