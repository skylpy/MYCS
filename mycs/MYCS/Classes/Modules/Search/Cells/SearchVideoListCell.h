//
//  SearchVideoListCell.h
//  MYCS
//
//  Created by wzyswork on 16/1/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchVideoListCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UIButton *praiseNumBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *praiseNumBtnWidth;

@property (weak, nonatomic) IBOutlet UILabel *typeL;

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UIButton *playNumBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *playNumBtnWidth;

@end
