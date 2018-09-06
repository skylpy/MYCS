//
//  MotifyPassWordController.m
//  MYCS
//
//  Created by wzyswork on 16/1/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MotifyPassWordController.h"

#import "UserCenterModel.h"

#import "NSString+Util.h"

#import "UserForgetPasswordController.h"

@interface MotifyPassWordController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldPassdwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *newsPassdwordTextField;

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@end

@implementation MotifyPassWordController

#pragma mark - 样式设置
-(void)setUI{

    self.sureButton.layer.cornerRadius = 4.0;
    self.sureButton.clipsToBounds = YES;
    self.oldPassdwordTextField.delegate = self;
    self.newsPassdwordTextField.delegate = self;
    
    self.oldPassdwordTextField.layer.cornerRadius = 4.0;
    self.oldPassdwordTextField.clipsToBounds = YES;
    self.oldPassdwordTextField.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.oldPassdwordTextField.layer.borderWidth = 1;
    self.oldPassdwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.oldPassdwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];
    
    
    self.newsPassdwordTextField.layer.cornerRadius = 4.0;
    self.newsPassdwordTextField.clipsToBounds = YES;
    self.newsPassdwordTextField.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.newsPassdwordTextField.layer.borderWidth = 1;
    self.newsPassdwordTextField.leftViewMode = UITextFieldViewModeAlways;
    self.newsPassdwordTextField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 8, 40)];

 
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setUI];
}
- (IBAction)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 确定Action
- (IBAction)sureAction:(id)sender
{
    if ([self canGoon])
    {
        [self showLoadingHUD];
        
        NSString * newPWDStr = [self.newsPassdwordTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        NSString * oldPWDStr = [self.oldPassdwordTextField.text  stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        
        [UserCenterModel changePasswordWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] oldPassword:oldPWDStr newPassword:newPWDStr success:^{
            
            [self dismissLoadingHUD];
            
            [self showSuccessWithStatusHUD:@"修改密码成功"];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } failure:^(NSError *error) {
            
            [self dismissLoadingHUD];
            
            [self showError:error];
        }];
    }
}

- (BOOL)canGoon
{
    if ([NSString isBlankString:self.oldPassdwordTextField.text])
    {
        [self showErrorMessage:@"原密码不能为空"];
        
        return NO;
    }
    if ([NSString isBlankString:self.newsPassdwordTextField.text])
    {
        [self showErrorMessage:@"新密码不能为空"];
        
        return NO;
    }
    return YES;
}

#pragma mark - 键盘的代理事件
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
    [self judgeTextFieldContent:textField.text];
    
}
-(void)judgeTextFieldContent:(NSString *)str
{
    if (![NSString matchRegularExpress:@"[A-Za-z0-9]{6,18}" inString:str])
    {
        [self.newsPassdwordTextField resignFirstResponder];
        [self.oldPassdwordTextField resignFirstResponder];
        
        [self showErrorMessage:@"密码由6-18位英文、数字组成!"];
        
    }
}
#pragma mark - 忘记密码Action
- (IBAction)forgetPassWordClick:(UIButton *)sender
{
    UserForgetPasswordController * vc = [[UIStoryboard storyboardWithName:@"Login" bundle:nil] instantiateViewControllerWithIdentifier:@"UserForgetPasswordController"];
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
    
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
