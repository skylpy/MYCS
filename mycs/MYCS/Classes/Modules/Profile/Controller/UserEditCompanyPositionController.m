//
//  UserChangeCompanyPositionController.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/18.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "UserEditCompanyPositionController.h"
#import "UIImage+Color.h"
#import "UIViewController+Message.h"
#import "NSString+Util.h"
#import "UserCenterModel.h"
#import "AppManager.h"
#import "IQKeyboardManager.h"
@interface UserEditCompanyPositionController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *editView;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIButton *enterBtn;


@end

@implementation UserEditCompanyPositionController

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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.enterBtn.layer.cornerRadius = 6;
    self.enterBtn.layer.masksToBounds = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.editView.delegate = self;
    
    UserCenterModel *model = [AppManager sharedManager].userCenterModel;
    
    self.editView.text = model.position;
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)self.editView.text.length];
}


#pragma mark – Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
   
        return YES;
    
}
- (void)textViewDidChange:(UITextView *)textView{
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu/50",(unsigned long)textView.text.length];
    
}



#pragma mark – CustomDelegate



#pragma mark – Event
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editAction:(id)sender {
    
    if (![self validTextView]) return;
    
    if (self.editView.text.length > 50)
    {
        [self showErrorMessage:@"内容不能超过50个字"];
        return;
    }
    
    [self showLoadingHUD];
    
    NSString *position = [self.editView.text trimmingWhitespaceAndNewline];
    
    User *user = [AppManager sharedManager].user;
    
    [UserCenterModel editPositionWith:user.uid userType:[NSString stringWithFormat:@"%d",user.userType] positionName:position success:^(SCBModel *model) {
        
        [self dismissLoadingHUD];
        
        if ([model.code intValue] == 1) {
            
            [self.navigationController popViewControllerAnimated:YES];
            self.SureBlock();
        }
        
    } filure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        
        [self showError:error];
        
    }];
    
}



#pragma mark - Network



#pragma mark – Private
- (BOOL)validTextView {
    
    if ([NSString isBlankString:self.editView.text])
    {
        [self showErrorMessage:@"公司职位不能为空"];
        return NO;
    }
    
    return YES;
}


#pragma mark – Getter/Setter


@end
