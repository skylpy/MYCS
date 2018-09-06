//
//  TaskGovDetailViewController.h
//  MYCS
//
//  Created by yiqun on 16/5/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskModel;
@interface TaskGovDetailViewController : UIViewController

@property (nonatomic, strong) TaskModel *taskModel;
@property (nonatomic, copy) NSString *sortType;

@end
