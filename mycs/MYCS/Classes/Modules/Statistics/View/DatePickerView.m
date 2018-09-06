//
//  DatePickerView.m
//  MYCS
//
//  Created by GuiHua on 16/4/20.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "DatePickerView.h"

@implementation DatePickerView

-(void)awakeFromNib
{
    [super awakeFromNib];
    _formatter = [[NSDateFormatter alloc] init];
    _formatter.dateFormat = @"yyyy-MM-dd";

    NSDate * nowDate=[NSDate date];
    [self.datePicker setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-CN"]];
    self.datePicker.maximumDate = nowDate;
    
    self.dateStr = [NSString string];
    self.dateStr = [_formatter stringFromDate:nowDate];
    
}
- (IBAction)chooseDateAction:(UIDatePicker *)sender
{
    NSDate *selectedDate = sender.date;
    
    self.dateStr = [_formatter stringFromDate:selectedDate];
}

+(void)showInView:(UIViewController *)view WithBlock:(void (^)(NSString *))sureBlock
{
    DatePickerView *pickView = [[[NSBundle mainBundle] loadNibNamed:@"DatePickerView" owner:nil options:nil]lastObject];
    
    pickView.sureBlock = sureBlock;
    
    pickView.frame = [UIScreen mainScreen].bounds;
    
    pickView.y = ScreenH;
    
    [view.navigationController.view addSubview:pickView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        pickView.y = 0;
        
    } completion:^(BOOL finished) {
        
        
    }];
}


- (IBAction)sureAction:(UIButton *)sender
{
    if (self.sureBlock)
    {
        self.sureBlock(self.dateStr);
    }
    
    [self removeSelfFromSuperview];
}

- (IBAction)cancelAction:(UIButton *)sender
{
    
    if (self.sureBlock)
    {
        self.sureBlock(nil);
    }
    
    [self removeSelfFromSuperview];
}

-(void)removeSelfFromSuperview{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.y = ScreenH;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

@end









