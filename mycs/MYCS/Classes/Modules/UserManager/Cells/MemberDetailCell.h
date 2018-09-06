//
//  MemberDetailCell.h
//  MYCS
//
//  Created by wzyswork on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberInfo.h"
@interface MemberDetailCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@property (strong, nonatomic) IBOutlet UILabel *yearLabel;

@property (strong, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UIButton *statusBtn;

@property (strong, nonatomic) IBOutlet UIView *lineView;

@property (strong, nonatomic)GradeModel * model;

@end
