//
//  TaskNoticeUserController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskDetailModel;
@interface TaskNoticeUserController : UIViewController

@property (nonatomic,copy) NSString *taskId;
@property (nonatomic,strong) TaskDetailModel *detailModel;
@property (nonatomic,strong)NSString * sort;

@end

@class TaskJoinUserModel;
@interface TaskSelectUserCell : UITableViewCell

@property (nonatomic,strong) TaskJoinUserModel *model;


@end
