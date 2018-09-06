//
//  TaskCourseReleaseController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TaskModel.h"
@interface TaskCourseReleaseController : UITableViewController

@property (nonatomic,strong) TaskModel *model;
@property (nonatomic,copy) NSString *sortType;

@property (nonatomic,copy) void(^SureButtonBlock)();

@end

@interface TaskReleaseParamModel : NSObject

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *SOP;
@property (nonatomic,copy) NSString *course;
@property (nonatomic,copy) NSString *courseId;
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *dayCount;
@property (nonatomic,copy) NSString *passRate;
@property (nonatomic,copy) NSString *desc;
@property (nonatomic,copy) NSString *depId;
@property (nonatomic,copy) NSString *employeeId;
@property (nonatomic,copy) NSString *memId;

@property (nonatomic,copy) NSString *hospUid;
@end
