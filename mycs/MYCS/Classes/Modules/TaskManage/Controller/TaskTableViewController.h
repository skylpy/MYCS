//
//  TaskTableViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@class TaskModel;
@interface TaskTableViewController : UIViewController

@property (nonatomic,copy) NSString * taskSort;

@property (nonatomic,copy) NSString *sortType;

@property (nonatomic,assign) int type;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,copy) void(^CellClickBlock)(TaskModel *model,NSString *sortType);

//YES代表是机构任务
@property (nonatomic,assign) BOOL isOrgTask;

@end

@interface TaskTableCell : UITableViewCell

@property (nonatomic,assign) int type;//1代表任务管理，3代表机构任务

@property (nonatomic,strong) TaskModel *model;

@property (nonatomic,copy) NSString *sortType;

@property (nonatomic,weak) TaskTableViewController * delegate;
@end