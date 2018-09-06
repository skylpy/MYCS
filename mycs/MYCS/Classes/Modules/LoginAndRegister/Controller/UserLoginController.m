//
//  UserLoginController.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/14.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "UserLoginController.h"
#import "UMengHelper.h"
#import "TencentOAuthHttp.h"
#import "UIViewController+Message.h"
#import "AppManager.h"
#import "AppDelegate.h"
#import "ConstKeys.h"
#import "UIImage+Color.h"
#import "NSString+Util.h"
#import "JPushHelper.h"
#import "UpDownButton.h"
#import "DataCacheTool.h"

@interface UserLoginController ()

@property (weak, nonatomic) IBOutlet UIView *loginView;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@property (weak, nonatomic) IBOutlet UIView *threePartLoginView;

@property (weak, nonatomic) IBOutlet UITextField *accountTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logoTopConst;

@property (weak, nonatomic) IBOutlet UpDownButton *QQLoginBtn;
@property (weak, nonatomic) IBOutlet UpDownButton *wechatLoginBtn;

@end

@implementation UserLoginController


#pragma mark – life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginView.layer.cornerRadius = 6;
    self.loginView.layer.masksToBounds = YES;
    
    self.loginBtn.layer.cornerRadius = 4;
    self.loginBtn.layer.masksToBounds = YES;
    
    self.threePartLoginView.hidden = ![UMengHelper isInstallQQPlatform];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    ///适配手机调整视图的位置
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (size.height == 480) {
        self.logoTopConst.constant = 45;
        [self.QQLoginBtn setTitle:nil forState:UIControlStateNormal];
        [self.wechatLoginBtn setTitle:nil forState:UIControlStateNormal];
    }
    else if (size.height == 568)
    {
        self.logoTopConst.constant = 60;
    }
    else if (size.height == 667)
    {
        self.logoTopConst.constant = 80;
    }
    else if (size.height == 736)
    {
        self.logoTopConst.constant = 100;
    }

    self.accountTextField.text =  [[NSUserDefaults standardUserDefaults] objectForKey:@"userAccount"];
    self.accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
}

#pragma mark – Event

- (IBAction)backAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)loginAction:(UIButton *)button {
    
    if ([self validateUserAndPassword]) {
        
        button.userInteractionEnabled = NO;
        
        NSString *user = [self.accountTextField.text trimmingWhitespaceAndNewline];
        NSString *password = [self.passwordTextField.text trimmingWhitespaceAndNewline];
        
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"userAccount"];
        
        [User loginWithUserName:user password:password success:^(User *user){
            
            [AppManager saveUserCount:user];
            [self loginSuccess];
            button.userInteractionEnabled = YES;
            
        } failure:^(NSError *error) {
            
            [self showError:error];
            button.userInteractionEnabled = YES;
            
        }];

    }
    
}

- (IBAction)tencentLoginAction:(UIButton *)button {
    
    button.userInteractionEnabled = NO;
    
    [UMengHelper tencentLoginWith:self successHandler:^(NSString *openId, NSString *token,NSString *nickName) {
        
        [TencentOAuthHttp qqOAuthLogin:openId accessToken:token nickName:nickName bundingType:@"qq" success:^(User *user) {
            
            [AppManager saveUserCount:user];
            [self loginSuccess];
            button.userInteractionEnabled = YES;
                        
        } failure:^(NSError *error) {
            [self showError:error];
            button.userInteractionEnabled = YES;
        }];
        
    }];
    
}

- (IBAction)wechatLoginAction:(UpDownButton *)sender {
    
    sender.userInteractionEnabled = NO;
    
    [UMengHelper wechatLoginWith:self successHandler:^(NSString *openId, NSString *token,NSString *nickName) {
        
        [TencentOAuthHttp qqOAuthLogin:openId accessToken:token nickName:nickName bundingType:@"wx" success:^(User *user) {
            
            [AppManager saveUserCount:user];
            [self loginSuccess];
            sender.userInteractionEnabled = YES;
            
        } failure:^(NSError *error) {
            [self showError:error];
            sender.userInteractionEnabled = YES;
        }];

    }];
    
}

#pragma mark - Network



#pragma mark – Private
- (void)loginSuccess {
    
//    ///登录成功后跳转到个人主页
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccess object:nil];
    
    [DataCacheTool initializeUserFriendTable];
    [FriendModel getFriendListsSuccess:^(NSArray *list) {
    } failure:^(NSError *error) {
        
    }];
    
}

- (BOOL)validateUserAndPassword {
    if ([NSString isBlankString:self.accountTextField.text]) {
        [self showErrorMessage:@"请输入账号"];
        return NO;
    }
    else if ([NSString isBlankString:self.passwordTextField.text])
    {
        [self showErrorMessage:@"请输入密码"];
        return NO;
    }
    return YES;
}

#pragma mark – Getter/Setter




@end
