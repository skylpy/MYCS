//
//  OfficeListCell.m
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "OfficeListCell.h"

#import "UIImageView+WebCache.h"

@interface OfficeListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *hospitalL;

@end

@implementation OfficeListCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = self.iconView.width*0.5;
    self.iconView.layer.masksToBounds = YES;
    self.iconView.contentMode = UIViewContentModeScaleToFill;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}
-(void)setModel:(OfficeUnDetailModel *)model{
  
    _model = model;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
    
    self.nameL.text = model.realname;
    
    self.hospitalL.text = model.divisionName;
}

@end
