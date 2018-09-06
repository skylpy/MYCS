//
//  IntroductionViewController.h
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OfficeDetailModel;

@interface IntroductionViewController : UIViewController

@property (nonatomic,strong) OfficeDetailModel *model;

@property (nonatomic,assign) int type;


@end
