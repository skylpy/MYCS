//
//  InputReasonController.m
//  MYCS
//
//  Created by wzyswork on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "InputReasonController.h"

@interface InputReasonController ()<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@property (strong, nonatomic) IBOutlet UIButton *OKButton;

@property (weak, nonatomic) IBOutlet UIView *inputView;

@end

@implementation InputReasonController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.inputView.layer.cornerRadius = 6;
    self.inputView.layer.masksToBounds = YES;
    
    self.textView.layer.borderColor = HEXRGB(0xcccccc).CGColor;
    self.textView.layer.borderWidth = 1;
    
    self.cancelButton.layer.borderColor = HEXRGB(0xcccccc).CGColor;
    self.cancelButton.layer.borderWidth = 1;
    
    self.OKButton.layer.borderColor = HEXRGB(0xcccccc).CGColor;
    self.OKButton.layer.borderWidth = 1;
    
    self.textView.delegate = self;
}
#pragma mark -- back Action
- (IBAction)backAction:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- sure Action
- (IBAction)sureAction:(id)sender
{
    
    if (self.textView.text == nil || self.textView.text.length == 0) {
        
        [self showErrorMessage:@"请输入内容"];
        
        return;
        
    }
    
    if (self.textView.text.length < 5 || self.textView.text.length > 1000) {
    
        [self showErrorMessage:@"输入内容长度介于5至1000之间"];
        
        return;
        
    }
    
    if (self.sureBtnBlock)
    {
        self.sureBtnBlock([self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]);
    }
    
    [self backAction:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    textField.text = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    self.textView.text = nil;
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ([touch.view isKindOfClass:[self.view class]])
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
