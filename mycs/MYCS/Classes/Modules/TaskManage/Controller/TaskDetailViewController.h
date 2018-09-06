//
//  TaskDetailViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskModel;
@interface TaskDetailViewController : UIViewController

@property (nonatomic, strong) TaskModel *taskModel;
@property (nonatomic, copy) NSString *sortType;

@end

@class TaskJoinUserModel;
@interface TaskUserListCell : UITableViewCell

@property (nonatomic, strong) TaskJoinUserModel *userModel;

@end
