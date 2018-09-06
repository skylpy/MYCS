//
//  DoctorCell.m
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "DoctorCell.h"

#import "UIImageView+WebCache.h"

@implementation DoctorCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.personImage.layer.cornerRadius = self.personImage.width / 2;
    self.personImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(CollectionDoctor *)model{

    _model = model;
    
    [self.personImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
    
    self.nameLabel.text = model.name;
    [self.nameLabel sizeToFit];
    self.nameLConstraintW.constant = self.nameLabel.width;
    self.positionLabel.text = model.jobTitle;
    self.goodAtLabel.text =[NSString stringWithFormat:@"擅长:%@",model.goodat] ;
    self.famousImageView.hidden = model.isAuth.integerValue == 1?NO:YES;
    
    self.selectButton.selected = model.isSelect.intValue == 0?NO:YES;
    
}
@end










