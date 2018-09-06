//
//  BindEmailController.m
//  MYCS
//
//  Created by wzyswork on 16/1/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "BindEmailController.h"

#import "CountDownButton.h"

@interface BindEmailController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *EmailAddrassTextField;

@property (weak, nonatomic) IBOutlet UITextField *identifyCodeTextField;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet CountDownButton *sendIdentifyButton;

@property (weak, nonatomic) IBOutlet UIView *PromptView;

@end

@implementation BindEmailController

#pragma mark - 样式设置
-(void)setUI{
    
    self.EmailAddrassTextField.delegate = self;
    self.identifyCodeTextField.delegate = self;
    
    self.sendIdentifyButton.layer.cornerRadius = 4.0;
    self.sendIdentifyButton.clipsToBounds = YES;
    
    self.sureButton.layer.cornerRadius = 4.0;
    self.sureButton.clipsToBounds = YES;
    
    self.EmailAddrassTextField.layer.cornerRadius = 4.0;
    self.EmailAddrassTextField.clipsToBounds = YES;
    
    self.identifyCodeTextField.layer.cornerRadius = 4.0;
    self.identifyCodeTextField.clipsToBounds = YES;
    
    self.identifyCodeTextField.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.identifyCodeTextField.layer.borderWidth = 1;
    
    self.EmailAddrassTextField.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.EmailAddrassTextField.layer.borderWidth = 1;
    
    self.EmailAddrassTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
    self.EmailAddrassTextField.leftViewMode = UITextFieldViewModeAlways;
    
    self.identifyCodeTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
    self.identifyCodeTextField.leftViewMode = UITextFieldViewModeAlways;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldTextDidEndEdict:) name:UITextFieldTextDidEndEditingNotification object:self.EmailAddrassTextField];
}

-(void)TextFieldTextDidEndEdict:(NSNotification * )noty
{
    
    if (self.EmailAddrassTextField == noty.object)
    {
        self.sendIdentifyButton.backgroundColor = HEXRGB(0x47c2a9);
        self.sendIdentifyButton.enabled = YES;
    }
    
}

- (IBAction)backAction:(UIBarButtonItem *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 发送验证码Action
- (IBAction)sendIdentifyAction:(CountDownButton *)sender {
    
    [self.EmailAddrassTextField resignFirstResponder];
    
    if (self.EmailAddrassTextField.text.length == 0)
    {
        
        [self showErrorMessage:@"请输入绑定邮箱"];
        
        return;
    }
    
    NSString * emailStr = [self.EmailAddrassTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
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

#pragma mark - 确定Action
- (IBAction)sureAction:(UIButton *)sender {
    
    [self.EmailAddrassTextField resignFirstResponder];
    
    if (self.EmailAddrassTextField.text.length == 0)
    {
        
        [self showErrorMessage:@"请输入绑定邮箱"];
        
        return;
    }
    
    if (self.identifyCodeTextField.text.length == 0)
    {
        
        [self showErrorMessage:@"请输入邮箱验证码"];
        
        return;
    }
    
    [self showLoadingHUD];
    
    NSString * emailStr = [self.EmailAddrassTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    NSString * emailCodeStr = [self.identifyCodeTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    [UserCenterModel changeBindEmailWithEmail:emailStr Code:emailCodeStr userId: [AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] uccess:^{
        
        [self dismissLoadingHUD];
        
        [self showSuccessWithStatusHUD:@"绑定邮箱成功"];
        
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
#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    if (textField == self.EmailAddrassTextField)
    {
        
        self.sendIdentifyButton.backgroundColor = HEXRGB(0x47c2a9);
        self.sendIdentifyButton.enabled = YES;
    }

    return YES;
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
