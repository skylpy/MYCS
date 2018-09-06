//
//  TaskSelectDepartController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/22.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskSelectDepartController : UIViewController

@property (nonatomic,copy) void(^enterItemBlock)(NSArray *);

@end
