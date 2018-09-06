
//
//  ChoosePriceTypeView.m
//  MYCS
//
//  Created by wzyswork on 16/1/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ChoosePriceTypeView.h"

@implementation ChoosePriceTypeView

+ (void)showInView:(UIViewController *)view andIndex:(int)index andBlock:(void (^)(ChoosePriceTypeView *, NSInteger))block{
    
    ChoosePriceTypeView * old = [view.view viewWithTag:9999];
    [old removeFromSuperview];
    
    ChoosePriceTypeView * sheet = [[[NSBundle mainBundle] loadNibNamed:@"ChoosePriceTypeView" owner:nil options:nil] lastObject];
    sheet.tag = 9999;
    [view.view addSubview:sheet];
    [view.view bringSubviewToFront:sheet];
    sheet.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    sheet.menuBtnsBgViewTop.constant = - 123;
    
    sheet.block = block;
    
    
    [UIView animateWithDuration:0.25 animations:^{
        if (iS_IOS8LATER)
        {
            sheet.menuBtnsBgViewTop.constant = 0;
        }else
        {
          sheet.menuBtnsBgViewTop.constant = 64;
        }
        
    } completion:nil];
    
    sheet.selectBtn = sheet.menuBtns[index];
    sheet.selectBtn.selected = YES;
}

- (IBAction)muneBtnsClick:(UIButton *)sender
{
    self.selectBtn.selected = NO;
    self.selectBtn = sender;
    self.selectBtn.selected = YES;
    
    if (self.block)
    {
        self.block(self,sender.tag);
    }
    
    [self remove];
}

-(void)remove
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.menuBtnsBgViewTop.constant = - 123;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch * touch = [touches anyObject];
    
    if (touch.view == self.bgView)
    {
        [self remove];
    }
    
}
@end
