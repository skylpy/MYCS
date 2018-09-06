//
//  PostSystemCell.h
//  MYCS
//
//  Created by wzyswork on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PostSystem.h"

@interface PostSystemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *sopCountL;

@property (weak, nonatomic) IBOutlet UILabel *coureCountL;

@property (weak, nonatomic) IBOutlet UILabel *parentNameL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sopCountLWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *coureCountLWidth;

@property (nonatomic,strong) PostSystem * model;

@end
