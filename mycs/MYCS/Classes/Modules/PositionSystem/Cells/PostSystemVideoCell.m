//
//  PostSystemVideoCell.m
//  MYCS
//
//  Created by wzyswork on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "PostSystemVideoCell.h"

#import "UIImageView+WebCache.h"

@implementation PostSystemVideoCell

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    self.titleL.numberOfLines = 2;
    self.iconImageView.contentMode = UIViewContentModeScaleToFill;
}

-(void)setModel:(PostSystemVideo *)model
{
    
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:PlaceHolderImage];
    
    self.titleL.text = model.name;
    
    if ([model.type isEqualToString:@"video"])
    {
        self.videoTypeL.text = @"视频";
    }
    else if ([model.type isEqualToString:@"course"])
    {
        self.videoTypeL.text = @"教程";
    }
    else if ([model.type isEqualToString:@"sop"])
    {
        self.videoTypeL.text = @"SOP";
    }

    self.selectBtn.selected = model.isSelect.integerValue == 0 ? NO : YES;
}
@end
