//
//  UserForgetPasswordController.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/14.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "UserForgetPasswordController.h"
#import "UIImage+Color.h"
#import "CheckCodeView.h"
#import "UserCenterModel.h"
#import "UIViewController+Message.h"
#import "NSString+Util.h"

@interface UserForgetPasswordController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneLable;

@property (weak, nonatomic) IBOutlet UITextField *codeLable;

@property (weak, nonatomic) IBOutlet UITextField *passwordLable;

@property (weak, nonatomic) IBOutlet UIButton *sendCodeBtn;

@end

@implementation UserForgetPasswordController

#pragma mark – life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条的背景颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:HEXRGB(0x47c1a8)] forBarMetrics:UIBarMetricsDefault];
    
    self.tableView.scrollEnabled = NO;
    
    self.sendCodeBtn.layer.cornerRadius = 4;
    self.sendCodeBtn.layer.masksToBounds = YES;
    
}

#pragma mark – Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 140;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 140)];
    
    footView.backgroundColor = [UIColor clearColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    //设置属性
    [button setTitle:@"确定修改" forState:UIControlStateNormal];
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

#pragma mark – CustomDelegate


#pragma mark – Event
- (IBAction)sendCodeAction:(UIButton *)button {
    
    if (!self.phoneLable.text||self.phoneLable.text.length==0) {
        [self showErrorMessage:@"请输入手机号"];
        return;
    }
    
    ///显示codeView
    NSString *phoneStr = [self.phoneLable.text trimmingWhitespaceAndNewline];
  [CheckCodeView showInView:self WithPhone:phoneStr complete:^(CheckCodeView *view, NSString *code) {
        
        if (!code||code.length == 0) return;
        
        ///请求检查输入的code是否正确
        [UserCenterModel sendCodeInUserCenterWithPhone:self.phoneLable.text validCode:code action:@"sendCode" success:^{
            
            [self cutdownWith:button];
            
        } failure:^(NSError *error) {
            
            [self showError:error];
            
        }];
        
    }];
    
}

- (void)commitAction:(UIButton *)button {
    
    if ([self canGo]) {
        
        NSString *phoneStr = [self.phoneLable.text trimmingWhitespaceAndNewline];
        NSString *codeStr = [self.codeLable.text trimmingWhitespaceAndNewline];
        NSString *passwordStr = [self.passwordLable.text trimmingWhitespaceAndNewline];
        
        [UserCenterModel forgetPasswordWithPhone:phoneStr code:codeStr newPassword:passwordStr success:^{
            
            
            [self showErrorMessage:@"密码修改成功"];
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } failure:^(NSError *error) {
            [self showError:error];
        }];

    }

}


#pragma mark - Network



#pragma mark – Private
- (void)cutdownWith:(UIButton *)button {
    
    __block int timeout=59; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:@"发送验证码" forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        }else{
            //			int minutes = timeout / 60;
            int seconds = timeout % 60;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [button setTitle:[NSString stringWithFormat:@"%@秒后重新发送",strTime] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
                
            });
            timeout--;
            
        }
    });
    
    dispatch_resume(_timer);
}

- (BOOL)canGo {
    
    if ([NSString isBlankString:self.phoneLable.text]) {
        [self showErrorMessage:@"请输入手机号"];
        return NO;
    }
    
    if ([NSString isBlankString:self.codeLable.text]) {
        [self showErrorMessage:@"请输入验证码"];
        return NO;
    }
    
    if ([NSString isBlankString:self.passwordLable.text]) {
        [self showErrorMessage:@"请输入新密码"];
        return NO;
    }
    
    return YES;
    
}


#pragma mark – Getter/Setter


@end
