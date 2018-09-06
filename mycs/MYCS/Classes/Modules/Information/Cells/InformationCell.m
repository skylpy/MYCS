//
//  InformationCell.m
//  MYCS
//
//  Created by wzyswork on 16/1/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "InformationCell.h"

@implementation InformationCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.ContentL.numberOfLines = 2;
    self.ImageView.contentMode = UIViewContentModeScaleToFill;
}

- (void)setModel:(InfomationModel *)model
{
    _model = model;
    
    [self.ImageView sd_setImageWithURL:[NSURL URLWithString:model.titlePic] placeholderImage:PlaceHolderImage];
    
    self.TitleL.text = model.title;
    self.ContentL.text = model.detail;
    
}
@end
