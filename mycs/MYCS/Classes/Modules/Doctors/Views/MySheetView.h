//
//  MySheetView.h
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MySheetView;

@interface MySheetView : UIView

@property (copy, nonatomic) void (^block)(MySheetView *sheet, NSInteger buttonIndex);

+ (void)showInView:(UIViewController *)view andBlock:(void (^)(MySheetView *, NSInteger))block;

@end
