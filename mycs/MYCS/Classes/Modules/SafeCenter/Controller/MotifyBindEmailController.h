//
//  MotifyBindEmailController.h
//  MYCS
//
//  Created by wzyswork on 16/1/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MotifyBindEmailController : UIViewController

@property (nonatomic,strong) NSString * oldEamil;

@property (nonatomic,strong) void(^SafeCenterDataRefleshBlock)();

@end
