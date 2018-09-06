//
//  UserInfoCell.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/17.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "UserInfoCell.h"
#import "UserInfoCellModel.h"

@interface UserInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrow;

@end

@implementation UserInfoCell

- (void)setModel:(UserInfoCellModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    self.detailLabel.text = model.detail;
    self.arrow.hidden = !model.isShowArrow;
}


@end
