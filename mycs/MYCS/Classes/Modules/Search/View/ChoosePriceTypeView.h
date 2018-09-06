//
//  ChoosePriceTypeView.h
//  MYCS
//
//  Created by wzyswork on 16/1/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePriceTypeView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuBtns;

@property (weak, nonatomic) IBOutlet UIView *menuBtnsBgView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBtnsBgViewTop;

@property(nonatomic,strong) UIButton * selectBtn;

@property (copy, nonatomic) void (^block)(ChoosePriceTypeView *sheet, NSInteger buttonIndex);

+ (void)showInView:(UIViewController *)view andIndex:(int)index andBlock:(void (^)(ChoosePriceTypeView *, NSInteger))block;

@end
