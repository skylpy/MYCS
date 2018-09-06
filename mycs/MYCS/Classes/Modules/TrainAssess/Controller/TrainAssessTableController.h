//
//  TrainAssessTableController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MJRefresh.h"

typedef NS_ENUM(NSUInteger,AssessTaskType)
{
    AssessTypeTaskCourse,
    AssessTaskTypeSOP
};

@class WaitToDoTask;
@interface TrainAssessTableController : UIViewController

@property (nonatomic,assign) AssessTaskType type;

@property (nonatomic,copy) NSString * taskStatus;

@property (nonatomic,assign) NSInteger page;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataBase;

@property (nonatomic,copy) void(^cellAction)(WaitToDoTask *model);

@end

@interface TrainAssessListCell : UITableViewCell

@property (nonatomic,strong) WaitToDoTask * model;

@end
