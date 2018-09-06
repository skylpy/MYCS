//
//  CommitCommentViewController.m
//  MYCS
//  业界评价
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "CommitCommentViewController.h"

#import "DoctorCommentModel.h"
#import "IQKeyboardManager.h"

@interface CommitCommentViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeHolder;

@property (weak, nonatomic) IBOutlet UIView *startView;

@property (weak, nonatomic) IBOutlet UITextView *textField;

@property (weak, nonatomic) IBOutlet UILabel *accountL;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *commitBtn;

@property (nonatomic,assign) int score;

@end

@implementation CommitCommentViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    
    [super viewWillDisappear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.textField.delegate = self;
    self.title = @"业界评价";
    
}

#pragma mark - *** UITextView Delegate ***
- (void)textViewDidChange:(UITextView *)textView{
    
    self.placeHolder.hidden = textView.text.length == 0?NO:YES;
    
    self.accountL.text = [NSString stringWithFormat:@"%lu/500",(unsigned long)textView.text.length];
    
    if (textView.text.length > 500)
    {
        
        [self showErrorMessage:@"评价内容长度在10-500之间!"];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    return YES;
}

#pragma mark - *** 星级评价 Action ***
- (IBAction)startAction:(UIButton *)sender
{
    
    for (UIButton *startBtn in self.startView.subviews)
    {
        
        startBtn.selected = NO;
    }
    
    for (UIButton *startBtn in self.startView.subviews)
    {
        if (startBtn.tag <= sender.tag)
        {
            startBtn.selected = YES;
        }
    }
    
}
#pragma mark - *** backAction ***
- (IBAction)backAction:(id)sender
{
    
    [self.view endEditing:YES];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - *** 提交 Action ***
- (IBAction)responseRightButton:(id)sender
{
    self.commitBtn.enabled = NO;
    [self.view endEditing:YES];
    
    for (UIButton *btn in self.startView.subviews)
    {
        if (btn.selected)
        {
            if (btn.tag>self.score)
            {
                self.score = (int)btn.tag;
            }
        }
    }
    
    if (self.score==0)
    {
        [self showErrorMessage:@"请选择评价级别!"];
        self.commitBtn.enabled = YES;
        
        return;
    }
    
    NSString *content = [self.textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (content == 0)
    {
        [self showErrorMessage:@"请输入评价内容!"];
        self.commitBtn.enabled = YES;
        
        return;
    }else if (content.length<10||content.length>500)
    {
        [self showErrorMessage:@"评价内容长度在10-500之间!"];
        self.commitBtn.enabled = YES;
        
        return;
    }
    
    [self showLoadingHUD];
    
    [DoctorCommentModel commitCommentWithUserId:[AppManager sharedManager].user.uid toUid:self.uid content:content score:self.score success:^(SCBModel *model) {
        
        [self dismissLoadingHUD];
        
        [self showSuccessWithStatusHUD:@"评价成功!"];
        
        if ([self.delegate respondsToSelector:@selector(commitSuccess)])
        {
            [self.delegate commitSuccess];
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self backAction:nil];
            self.commitBtn.enabled = YES;
        });
        
    } failure:^(NSError *error) {
        
        self.commitBtn.enabled = YES;
        
        [self dismissLoadingHUD];
        
        [self showError:error];
    }];
    
}


@end
