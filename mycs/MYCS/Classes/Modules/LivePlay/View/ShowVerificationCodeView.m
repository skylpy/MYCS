//
//  ShowVerificationCodeView.m
//  MYCS
//
//  Created by GuiHua on 16/6/17.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ShowVerificationCodeView.h"
#import "UIView+Message.h"

@interface ShowVerificationCodeView ()

@property (nonatomic, copy) void (^actionBlock)(ShowVerificationCodeView *view,NSString * idStr);

@property (weak, nonatomic) IBOutlet UIButton *sureButton;

@property (weak, nonatomic) IBOutlet UITextField *FCodeTextField;

@property (weak, nonatomic) IBOutlet UITextField *TCodeTextField;

@property (weak, nonatomic) IBOutlet UITextField *THCodeTextField;

@property (weak, nonatomic) IBOutlet UITextField *FourthCodeTextField;

@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (nonatomic,strong) NSArray * dataSourse;

@property (nonatomic,copy) NSString * codeStr;

@end

@implementation ShowVerificationCodeView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.FCodeTextField.layer.borderColor = HEXRGB(0x999999).CGColor;
    self.FCodeTextField.layer.borderWidth = 0.5f;
    
    self.TCodeTextField.layer.borderColor = HEXRGB(0x999999).CGColor;
    self.TCodeTextField.layer.borderWidth = 0.5f;
    
    self.THCodeTextField.layer.borderColor = HEXRGB(0x999999).CGColor;
    self.THCodeTextField.layer.borderWidth = 0.5f;
    
    self.FourthCodeTextField.layer.borderColor = HEXRGB(0x999999).CGColor;
    self.FourthCodeTextField.layer.borderWidth = 0.5f;
    
}

+(instancetype)showInView:(UIView *)superView actionBlock:(void (^)(ShowVerificationCodeView *,NSString *))actionBlock
{
    ShowVerificationCodeView * comfirmView = [[[NSBundle mainBundle] loadNibNamed:@"ShowVerificationCodeView" owner:self options:nil] lastObject];
    
    comfirmView.actionBlock = actionBlock;
    
    comfirmView.frame = superView.frame;
    
    comfirmView.y = ScreenH;
    
    [comfirmView layoutIfNeeded];
    
    [superView addSubview:comfirmView];
    
    [comfirmView showAction];
    
    return comfirmView;
    
}

- (IBAction)buttonAction:(UIButton *)sender
{
    
    if(sender.tag == 0)
    {
        [self dissmissAcion];
    }else
    {
        if (self.actionBlock)
        {
            self.actionBlock(self,self.codeStr);
        }
    }
}
#pragma mark - Action
- (void)showAction {
    //
    [self layoutIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.y = 0;
    }];
    
    self.dataSourse = [NSArray arrayWithObjects:self.FCodeTextField,self.TCodeTextField,self.THCodeTextField,self.FourthCodeTextField, nil];
    
    [self.textField addTarget:self action:@selector(textFieldchange:) forControlEvents:UIControlEventEditingChanged];
    [self.textField becomeFirstResponder];
    if (ScreenW < 375)
    {
        self.y = -65;
    }
}
-(void)hideCodeAction
{
    self.FCodeTextField.text = nil;
    self.TCodeTextField.text = nil;
    self.THCodeTextField.text = nil;
    self.FourthCodeTextField.text = nil;
}
#pragma mark 文本框内容改变
- (void)textFieldchange:(UITextField *)textField
{
    NSString *password = textField.text;
    self.sureButton.enabled = NO;
    
    self.codeStr = nil;
    
    if (password.length >= 5)
    {
        password = [password substringWithRange:NSMakeRange(0, 4)];
        self.codeStr = password;
    }
    
    if (password.length == 4)
    {
        self.sureButton.enabled = YES;
        self.codeStr = password;
        [textField resignFirstResponder];//隐藏键盘
    }
    [self hideCodeAction];
    for (int i = 0; i < password.length; i ++)
    {
        UITextField * padText = self.dataSourse[i];
        padText.text = [password substringWithRange:NSMakeRange(i, 1)];
    }
    
}

- (void)dissmissAcion {
    [UIView animateWithDuration:0.25 animations:^{
        
        self.y = ScreenH;
        
    }completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    UITouch * touch = touches.anyObject;
    if (touch.view.tag == 10)
    {
        [self dissmissAcion];
    }
}
- (IBAction)editAction:(id)sender
{
    if (self.codeStr.length > 0)
    {
        self.textField.text = self.codeStr;
        [self hideCodeAction];
        [self textFieldchange:self.textField];
        [self.textField becomeFirstResponder];
    }
}

@end


















