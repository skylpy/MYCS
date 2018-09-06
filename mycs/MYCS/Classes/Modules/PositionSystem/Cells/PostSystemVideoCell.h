//
//  PostSystemVideoCell.h
//  MYCS
//
//  Created by wzyswork on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PostSystem.h"

@interface PostSystemVideoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UILabel *videoTypeL;

@property (nonatomic,strong)PostSystemVideo * model;

@end
