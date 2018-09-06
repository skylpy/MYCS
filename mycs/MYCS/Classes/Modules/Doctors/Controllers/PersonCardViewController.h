//
//  PersonCardViewController.h
//  MYCS
//
//  Created by wzyswork on 16/1/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DoctorInfoModel.h"

@interface PersonCardViewController : UIViewController

@property (nonatomic,copy) void(^backBlok)();

@property (nonatomic,strong) DoctorInfoModel *doctorInfo;

@property (nonatomic,assign) BOOL isFullScreen;

@end
