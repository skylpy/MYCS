//
//  VideoShopCollectionViewCell.h
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DoctorModel.h"

@interface VideoShopCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *videoImageView;

@property (weak, nonatomic) IBOutlet UIButton *playNumBtn;

@property (weak, nonatomic) IBOutlet UILabel *typeLabel;

@property (weak, nonatomic) IBOutlet UIButton *praiseNumBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *praiseNumWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playNumBtnWidth;

@property (weak, nonatomic) IBOutlet UIImageView *play_imageView;

@property (copy,nonatomic) NSString *type;

@property(nonatomic,strong) DoctorVideoCenterModel * model;

@end
