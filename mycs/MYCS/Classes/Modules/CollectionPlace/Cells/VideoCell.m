//
//  VideoCell.m
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "VideoCell.h"

#import "UIImageView+WebCache.h"

@implementation VideoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.iconImageView.contentMode = UIViewContentModeScaleToFill;
    self.titleL.numberOfLines = 2;
}

-(void)setModel:(CollectionVideo *)model{
    
    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:PlaceHolderImage];
    
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
    
    self.selectButton.selected = model.isSelect.intValue == 0?NO:YES;
    
}

@end
