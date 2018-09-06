//
//  JoinInHospitalViewController.h
//  MYCS
//
//  Created by yiqun on 16/5/27.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskModel;
@class TaskJoinHospitalModel;
@interface JoinInHospitalViewController : UIViewController

@property (nonatomic, strong) TaskModel *taskModel;
@property (nonatomic, copy) NSString *sortType;

@property (nonatomic,copy) void(^CellClickBlock)(TaskJoinHospitalModel *model);

@end


@interface TaskHostpitalListCell : UITableViewCell

@property (nonatomic,strong) TaskJoinHospitalModel * hospitalModel;

@end