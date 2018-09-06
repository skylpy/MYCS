//
//  TaskDescViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskDescViewController.h"
#import "NSString+Util.h"

@interface TaskDescViewController ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *placeHolderLabel;
@property (weak, nonatomic) IBOutlet UITextView *editTextView;

@end

@implementation TaskDescViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (self.descString) {
        self.editTextView.text = self.descString;
        self.placeHolderLabel.hidden = YES;
    }
    
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Action 
- (IBAction)completeAction:(id)sender {
    
    if (self.editCompleteBlock) {
        
        NSString *desc = [self.editTextView.text trimmingWhitespaceAndNewline];
        
        if (desc.length>0&&desc.length<=200)
        {
            self.editCompleteBlock(desc);
            
        }else if(desc.length>200)
        {
            [self showErrorMessage:@"字数限制在1-200"];
            
            return;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Delegate
- (void)textViewDidChange:(UITextView *)textView {
    
    self.placeHolderLabel.hidden = textView.text.length==0?NO:YES;
    
}

#pragma mark - getter和setter

@end
