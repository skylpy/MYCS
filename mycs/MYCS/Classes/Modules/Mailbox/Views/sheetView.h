//
//  sheetView.h
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class sheetView;

@interface sheetView : UIView

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;

@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (copy, nonatomic) void (^block)(sheetView *sheet, NSInteger buttonIndex);

- (void)showView:(UIViewController *)view andY:(NSInteger)y SheetBlock:(void (^)(sheetView *sheet, NSInteger buttonIndex))block;

+(instancetype)getSheetView;

@end
