//
//  DatePickerView.h
//  MYCS
//
//  Created by GuiHua on 16/4/20.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerView : UIView

@property (nonatomic,retain) NSDateFormatter *formatter;

@property (nonatomic,strong) NSString *dateStr;

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@property (nonatomic,copy) void(^sureBlock)(NSString *dateStr);

+(void)showInView:(UIViewController *)view WithBlock:(void(^)(NSString *dateStr))sureBlock;

@end
