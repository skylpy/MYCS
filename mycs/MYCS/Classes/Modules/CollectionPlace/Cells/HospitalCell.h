//
//  HospitalCell.h
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CollectionModel.h"

@interface HospitalCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *introductionL;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (nonatomic,strong)CollectionHospital * model;

@end
