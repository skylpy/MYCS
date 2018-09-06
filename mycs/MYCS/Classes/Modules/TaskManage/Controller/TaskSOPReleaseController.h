//
//  TaskSOPReleaseController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TaskModel.h"

@interface TaskSOPReleaseController : UITableViewController

@property (nonatomic,copy) NSString *sortType;

@property (nonatomic,strong) TaskModel *model;

@property (nonatomic,copy) void(^SureButtonBlock)();

@end

@interface TaskObjectButton : UIButton

@end