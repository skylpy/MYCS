//
//  DatePickView.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickView : UIView

+ (void)showWith:(UIDatePickerMode)mode selectComplete:(void (^)(NSDate *selectDate))completeBlock;

@end
