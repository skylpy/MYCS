//
//  RelateVideoCell.m
//  MYCS
//
//  Created by GuiHua on 16/7/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "RelateVideoCell.h"
#import "UIImageView+WebCache.h"

@implementation RelateVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.borderWidth = 1;
    self.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
}

-(void)setModel:(DoctorsHealthRelate *)model
{

    _model = model;
    self.detailL.text = model.video_titile;
    [self.urlImageView sd_setImageWithURL:[NSURL URLWithString:model.video_img] placeholderImage:PlaceHolderImage];
}

@end
