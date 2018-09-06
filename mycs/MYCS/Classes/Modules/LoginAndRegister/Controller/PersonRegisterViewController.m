//
//  PersonRegisterTableViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/3/3.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "PersonRegisterViewController.h"
#import "CheckCodeView.h"
#import "NSString+Util.h"
#import "UIImage+Color.h"
#import "JPushHelper.h"
#import "ConstKeys.h"

@interface PersonRegisterViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;


@end

@implementation PersonRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    
}

- (void)buildUI {
    
    self.tableView.tableFooterView = [UIView new];
    self.sendCodeButton.layer.cornerRadius = 2;
    self.sendCodeButton.layer.masksToBounds = YES;
    
    [self.sendCodeButton setBackgroundImage:[UIImage imageWithColor:HEXRGB(0x47c1a8)] forState:UIControlStateNormal];
    [self.sendCodeButton setBackgroundImage:[UIImage imageWithColor:HEXRGB(0x999999)] forState:UIControlStateDisabled];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
}

#pragma mark - Action
- (void)commitAction:(UIButton *)button {
    
    if (![self validateUseName]) return;
    if (![self validatePhoneNumber]) return;
    if (![self valideteCode]) return;
    if (![self validatePassword]) return;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionary];
    param[@"regType"] = @(1);
    param[@"username"] = self.usernameTextField.text;
    param[@"phone"] = self.phoneTextField.text;
    param[@"phoneCode"] = self.codeTextField.text;
    param[@"password"] = self.passwordTextField.text;
    
    [self showLoadingWithStatusHUD:@"提交注册"];
    
    [User registWithUserInformation:param success:^(User *user) {
        
        NSLog(@"%@",user);
        [self showSuccessWithStatusHUD:@"注册成功"];

        [self registerSuccessWith:user];
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        [self showError:error];
        
    }];
    
}

//保存帐号，跳转到首页
- (void)registerSuccessWith:(User *)user {
    
    ///给极光推送设置tag和别名
    [JPushHelper setTag:user.envTag alias:user.uid];
    
    [AppManager saveUserCount:user];
    
    //发送登录成功的通知
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccess object:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)sendCondeButtonAction:(UIButton *)sender {
    
    if (![self validatePhoneNumber]) return;
    
    [self.view endEditing:YES];
    
    ///弹出验证码
   [CheckCodeView showInView:self WithPhone:self.phoneTextField.text complete:^(CheckCodeView *view, NSString *code) {
        
        if (!code||code.length == 0) return;
        
        [UserCenterModel sendCodeInUserCenterWithPhone:self.phoneTextField.text validCode:code action:@"send" success:^{
            
            [self cutdownWith:sender];
            
        } failure:^(NSError *error) {
            
            [self showError:error];
            
        }];
        
    }];
    
}

- (void)cutdownWith:(UIButton *)button {
    
    button.enabled = NO;
    
    __block int timeout=89; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                button.enabled = YES;
            });
        }else{
            //			int minutes = timeout / 60;
            int seconds = timeout % 90;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:[NSString stringWithFormat:@"剩余%@秒",strTime] forState:UIControlStateDisabled];
                button.enabled = NO;
                
            });
            timeout--;
            
        }
    });
    
    dispatch_resume(_timer);
}

#pragma mark - Private
///校验手机号码格式是否正确
- (BOOL)validatePhoneNumber {
    
    NSString *phone = [self.phoneTextField.text trimmingWhitespaceAndNewline];
    self.phoneTextField.text = phone;
    
    if (![NSString matchRegularExpress:@"1[3578]\\d{9}" inString:phone]) {
        
        [self showErrorMessage:@"手机号码格式不正确!"];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)validateUseName {
    
    NSString *username = [self.usernameTextField.text trimmingWhitespaceAndNewline];
    self.usernameTextField.text = username;

    if (![NSString matchRegularExpress:@"^[A-Za-z]{3,20}+$" inString:username])
    {
        [self showErrorMessage:@"用户名为3-20位英文"];
        return NO;
    }
    
    return YES;
}

- (BOOL)validatePassword {
    
    NSString *username = [self.passwordTextField.text trimmingWhitespaceAndNewline];
    self.passwordTextField.text = username;
    
    if (![NSString matchRegularExpress:@"^[A-Za-z0-9]{3,18}+$" inString:username])
    {
        [self showErrorMessage:@"密码为3-18位英文或数字"];
        return NO;
    }
    
    return YES;
    
}


- (BOOL)valideteCode {
    
    NSString *code = [self.codeTextField.text trimmingWhitespaceAndNewline];
    self.codeTextField.text = code;
    
    if (!code||code.length == 0)
    {
        [self showErrorMessage:@"请输入验证码"];
        return NO;
    }
    
    return YES;

}

#pragma mark - Table view data source
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return ScreenH < 568 ? 80 : 140 ;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, ScreenH < 568 ? 80 : 140)];//140
    
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //设置属性
    [button setTitle:@"提交" forState:UIControlStateNormal];
    button.backgroundColor = HEXRGB(0x47c1a8);
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    
    //设置frame
    button.frame = CGRectMake(0, 0, self.view.width-20, 35);
    button.center = footView.center;
    
    //设置圆角
    button.layer.cornerRadius = 6;
    button.layer.masksToBounds = YES;
    
    [footView addSubview:button];
    
    [button addTarget:self action:@selector(commitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return footView;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


}

#pragma mark - TextFieldDelegate

@end
