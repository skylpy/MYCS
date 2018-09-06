//
//  BaseInfoView.h
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseInfoView : UIView

@property (weak, nonatomic) IBOutlet UILabel *nickNameL;

@property (weak, nonatomic) IBOutlet UILabel *addressL;

@property (weak, nonatomic) IBOutlet UILabel *gootAtL;

@property (weak, nonatomic) IBOutlet UILabel *introductionL;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introductionConstraintH;
//
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introductionConstraintT;
//
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introductionTopWithContentL;
//
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *googAtConstraintH;

@property (nonatomic,assign) CGFloat baseViewHeight;

+ (instancetype)baseInfoView;

@end
