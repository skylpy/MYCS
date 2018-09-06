//
//  ExamDeatilController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/20.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,TaskType) {
    TaskTypeCommom,
    TaskTypeSOP
};

@interface ExamDeatilController : UIViewController

@property (nonatomic,copy) NSString *taskId;
@property (nonatomic,copy) NSString *employeeId;
@property (nonatomic,assign) TaskType taskType;

@end

