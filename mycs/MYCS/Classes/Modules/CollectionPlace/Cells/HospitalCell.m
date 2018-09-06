//
//  HospitalCell.m
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "HospitalCell.h"

#import "UIImageView+WebCache.h"

@implementation HospitalCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.iconImageView.layer.cornerRadius = self.iconImageView.width / 2;
    self.iconImageView.clipsToBounds = YES;
    
    self.introductionL.numberOfLines = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(CollectionHospital *)model{

    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
    
    self.nameL.text = model.realname;
    self.introductionL.text = model.introduction;
    
    self.selectButton.selected = model.isSelect.intValue == 0?NO:YES;
}
@end








