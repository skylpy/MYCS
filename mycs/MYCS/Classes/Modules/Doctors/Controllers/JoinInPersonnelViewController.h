//
//  JoinInPersonnelViewController.h
//  MYCS
//
//  Created by yiqun on 16/5/27.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskDetailModel;
@class TaskJoinUserModel;
@interface JoinInPersonnelViewController : UIViewController

@property (nonatomic, strong) TaskDetailModel *detailModel;

@property (nonatomic,copy) void(^CellClickBlock)(TaskJoinUserModel *model);

@end


@class TaskJoinUserModel;
@interface TaskUsersListCell : UITableViewCell

@property (nonatomic, strong) TaskJoinUserModel *userModel;

@end