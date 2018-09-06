//
//  UserEditResponserController.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/18.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "UserEditResponserController.h"
#import "NSString+Util.h"
#import "UIViewController+Message.h"
#import "AppManager.h"
#import "IQKeyboardManager.h"

@interface UserEditResponserController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *responserTextField;
@property (weak, nonatomic) IBOutlet UITextField *positionTextField;

@end

@implementation UserEditResponserController

- (void)viewWillAppear:(BOOL)animated
{
//    [super viewWillAppear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
//    [super viewWillDisappear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    
}

#pragma mark – life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.responserTextField.delegate = self;
    self.positionTextField.delegate = self;
    
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
- (void)commitAction:(UIButton *)button {
    
    if (![self validateResponser]) return;
    if (![self validatePosition]) return;
    
    [self showLoadingHUD];
    
    [UserCenterModel changeManagerWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] contacts:self.responserTextField.text jobTitle:self.positionTextField.text position:@"" industryID:@"" success:^{
        
        [self dismissLoadingHUD];
        self.SureResponserBlock();
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        [self dismissLoadingHUD];
        [self showError:error];
    }];
    
}
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Network



#pragma mark – Private
///校验密码格式
- (BOOL)validateResponser {
    
    NSString *responser = [self.responserTextField.text trimmingWhitespaceAndNewline];
    self.responserTextField.text = responser;
    
    if ([NSString isBlankString:responser])
    {
        [self showErrorMessage:@"请输入平台负责人"];
        return NO;
    }
    
    if (![NSString matchRegularExpress:@"\\w{2,50}" inString:self.responserTextField.text]) {
        
        [self showErrorMessage:@"负责人要求由2至50位中文、英文、数字组成"];
        
        return NO;
    }
    return YES;
}

- (BOOL)validatePosition {
    
    NSString *position = [self.positionTextField.text trimmingWhitespaceAndNewline];
    self.positionTextField.text = position;
    
    if ([NSString isBlankString:position])
    {
        [self showErrorMessage:@"请输入职称"];
        return NO;
    }
    if (![NSString matchRegularExpress:@"\\w{2,30}" inString:self.positionTextField.text]) {
        
        [self showErrorMessage:@"职称要求由2至30位中文、英文、数字组成"];
        
        return NO;
    }

    
    return YES;
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark – Getter/Setter



@end
