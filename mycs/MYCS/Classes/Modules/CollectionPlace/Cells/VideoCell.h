//
//  VideoCell.h
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CollectionModel.h"

@interface VideoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (weak, nonatomic) IBOutlet UILabel *videoTypeL;

@property(nonatomic,strong)CollectionVideo * model;

@end
