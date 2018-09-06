//
//  InfomactionViewController.h
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DoctorInfoModel.h"

typedef enum {
    
    ButtonTypeHonour,
    ButtonTypeTreatise
    
}ButtonType;

@interface InfomactionViewController : UIViewController

@property (nonatomic,strong) DoctorInfoModel *doctorInfo;

@end
