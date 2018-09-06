//
//  FeedBackViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "FeedBackViewController.h"
#import "CustomTextField.h"
#import "UserCenterModel.h"
#import "UIViewController+Message.h"
#import "NSString+Util.h"

@interface FeedBackViewController ()

@property (weak, nonatomic) IBOutlet CustomTextField *phoneTextField;

@property (weak, nonatomic) IBOutlet UITextView *contentView;

@end

@implementation FeedBackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.phoneTextField.marginLeft = 15;
    
}

#pragma mark - Action 
- (IBAction)commitAction:(id)sender {
    
    if (![self validateContent]) return;
    
    NSString *phone = [self.phoneTextField.text trimmingWhitespaceAndNewline];
    NSString *content = [self.contentView.text trimmingWhitespaceAndNewline];
    
    if (phone == nil) phone = @"";
    
    [UserCenterModel giveSuggestWithUserID:[AppManager sharedManager].user.uid phoneNumber:phone suggestContent:content success:^{
        
        [self showSuccessWithStatusHUD:@"提交成功"];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
    }];

}

- (BOOL)validateContent {
    
    if (self.contentView.text.length == 0)
    {
        [self showErrorMessage:@"请输入意见或建议"];
        return NO;
    }
    
    if (self.phoneTextField.text.length > 0)
    {
        return [self validatePhoneNumber];
    }
    
    return YES;
}

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


@end
