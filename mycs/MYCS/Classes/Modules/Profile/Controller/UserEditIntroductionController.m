//
//  UserEidtIntroductionController.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/18.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "UserEditIntroductionController.h"
#import "UIImage+Color.h"
#import "UIViewController+Message.h"
#import "NSString+Util.h"
#import "UserCenterModel.h"
#import "AppManager.h"
#import "IQKeyboardManager.h"
@interface UserEditIntroductionController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *editView;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIButton *enterBtn;


@end

@implementation UserEditIntroductionController

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
    
    self.editView.text = model.introduction;
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
    if (self.editView.text.length > 300)
    {
        [self showErrorMessage:@"内容不能超过300个字"];
        return;
    }
    
    [self showLoadingHUD];
    
    NSString *introduction = [self.editView.text trimmingWhitespaceAndNewline];
    
    User *user = [AppManager sharedManager].user;
    
    [UserCenterModel changeIntroWithUserID:user.uid userType:[NSString stringWithFormat:@"%d", user.userType] introduction:introduction success:^{
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
            [self showErrorMessage:[NSString stringWithFormat:@"%@不能为空",self.title]];
        
        return NO;
    }
    
    return YES;
}


#pragma mark – Getter/Setter

@end
