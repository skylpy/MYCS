//
//  EducationBgView.h
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EducationBgView : UIView

@property (weak, nonatomic) IBOutlet UIView *educationView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *educationViewH;

+ (instancetype)educationBgView;

@end
