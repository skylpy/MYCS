//
//  SelectTableCell.h
//  MYCS
//
//  Created by yiqun on 16/8/30.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaskObject;
@interface SelectTableCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@property (retain,nonatomic)TaskObject *taskModel;

@end
