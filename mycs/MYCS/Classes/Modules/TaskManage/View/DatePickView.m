//
//  DatePickView.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "DatePickView.h"
#import "NSDate+Util.h"

@interface DatePickView ()

@property (weak, nonatomic) IBOutlet UIView *toolView;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (nonatomic, copy) void (^completeBlock)(NSDate *selectDate);

@property (nonatomic, assign) UIDatePickerMode pickerMode;


@end

@implementation DatePickView

+ (void)showWith:(UIDatePickerMode)mode selectComplete:(void (^)(NSDate *selectDate))completeBlock {
    DatePickView *view = [[[NSBundle mainBundle] loadNibNamed:@"DatePickView" owner:nil options:nil] lastObject];

    view.pickerMode    = mode;
    view.completeBlock = completeBlock;

    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;

    view.frame = keyWindow.bounds;

    [keyWindow addSubview:view];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.datePickView.minimumDate = [NSDate date];
    self.datePickView.timeZone    = [NSTimeZone systemTimeZone];

    //使用KVO来监听系统的时间的变化
    [self.datePickView addTarget:self action:@selector(dataDidChange:) forControlEvents:UIControlEventValueChanged];

    [self layoutIfNeeded];

    //显示动画
    self.toolView.transform = CGAffineTransformMakeTranslation(0, 250);
    [UIView animateWithDuration:0.25 animations:^{
        self.toolView.transform = CGAffineTransformIdentity;
    }];
}

- (IBAction)cancelAction:(UIButton *)button {
    [UIView animateWithDuration:0.25 animations:^{
        self.toolView.transform = CGAffineTransformMakeTranslation(0, 250);
    }
        completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
}

- (IBAction)sureAction:(UIButton *)button {
    if (self.completeBlock)
    {
        self.completeBlock(self.datePickView.date);
    }

    [self cancelAction:nil];
}

- (void)dataDidChange:(UIDatePicker *)picker {
    NSString *formatString;

    if (self.pickerMode == UIDatePickerModeDate)
    {
        formatString = @"yyyy-MM-dd";
    }
    else if (self.pickerMode == UIDatePickerModeDateAndTime)
    {
        formatString = @"yyyy-MM-dd  HH:mm";
    }
    else if (self.pickerMode == UIDatePickerModeTime)
    {
        formatString = @"HH:mm";
    }
    else if (self.pickerMode == UIDatePickerModeCountDownTimer)
    {
        formatString = @"HH:mm";
    }

    NSDate *date         = picker.date;
    NSString *dateStr    = [NSDate dateToString:date format:formatString];
    self.titleLabel.text = dateStr;
}

#pragma mark - Getter&Setter
- (void)setPickerMode:(UIDatePickerMode)pickerMode {
    _pickerMode = pickerMode;

    self.datePickView.datePickerMode = pickerMode;
}

@end
