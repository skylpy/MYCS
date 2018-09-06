//
//  DoctorListTableViewCell.h
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DoctorModel.h"

@interface DoctorListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *personImage;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *VIPimageView;

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;

@property (weak, nonatomic) IBOutlet UILabel *goodAtLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLConstraintW;

@property (nonatomic,strong)DoctorListModel * model;

@end
