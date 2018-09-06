//
//  UserEditSkillController.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/18.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "UserEditSkillController.h"
#import "AppManager.h"
#import "UIViewController+Message.h"
#import "NSString+Util.h"
#import "IQKeyboardManager.h"
@interface UserEditSkillController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *editView;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIButton *enterBtn;


@end

@implementation UserEditSkillController
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
    
    self.editView.text = model.skill;
    self.countLabel.text = [NSString stringWithFormat:@"%lu/300",(unsigned long)self.editView.text.length];
}


#pragma mark – Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
   
            return YES;
    
}
- (void)textViewDidChange:(UITextView *)textView{
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu/300",(unsigned long)textView.text.length];
    
}


#pragma mark – CustomDelegate



#pragma mark – Event
- (IBAction)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editAction:(id)sender {
    
    if (![self validTextView]) return;
    
    [self showLoadingHUD];
    
    User *user = [AppManager sharedManager].user;
    
    NSString *skill = [self.editView.text trimmingWhitespaceAndNewline];
    
    [UserCenterModel updateSkillWithUserID:user.uid userType:[NSString stringWithFormat:@"%d", user.userType] skill:skill  success:^{
        [self dismissLoadingHUD];
        self.SureBlock();
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        [self dismissLoadingHUD];
        [self showError:error];
        
    }];
    
}

#pragma mark - Network



#pragma mark – Private
- (BOOL)validTextView {
    
    if ([NSString isBlankString:self.editView.text])
    {
        [self showErrorMessage:@"个人擅长不能为空"];
        return NO;
    }
    
    return YES;
}


#pragma mark – Getter/Setter




@end
