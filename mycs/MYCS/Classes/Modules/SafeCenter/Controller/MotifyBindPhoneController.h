//
//  MotifyBindPhoneController.h
//  MYCS
//
//  Created by wzyswork on 16/1/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MotifyBindPhoneController : UIViewController

@property (nonatomic , strong) NSString * oldPhone;

@property (nonatomic,strong) void(^SafeCenterDataRefleshBlock)();

@end
