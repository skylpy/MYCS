//
//  DoctorListTableViewCell.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "DoctorListTableViewCell.h"

#import "UIImageView+WebCache.h"

@implementation DoctorListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.VIPimageView.image =[UIImage imageNamed:@"famous"];
    self.VIPimageView.hidden = NO;
    
    self.personImage.layer.cornerRadius = self.personImage.width * 0.5;
    self.personImage.layer.masksToBounds = YES;
    self.personImage.contentMode = UIViewContentModeScaleToFill;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

-(void)setModel:(DoctorListModel *)model
{
    _model = model;
    
    [self.personImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
    
    self.nameLabel.text = model.realname;
    [self.nameLabel sizeToFit];
    self.nameLConstraintW.constant = self.nameLabel.width;
    
    self.positionLabel.text = model.jobTitleName;
    self.goodAtLabel.text =[NSString stringWithFormat:@"擅长:%@",model.goodat] ;
    
    self.selectionStyle = UITableViewCellSelectionStyleDefault;
    
    self.width = ScreenW;

}

@end
