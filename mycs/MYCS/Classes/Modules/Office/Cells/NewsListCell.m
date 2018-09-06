//
//  NewsListCell.m
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "NewsListCell.h"

#import "UIImageView+WebCache.h"

@implementation NewsListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentL.numberOfLines = 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(InfomationModel *)model
{

    _model = model;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.titlePic] placeholderImage:PlaceHolderImage];
    
    self.titleL.text = model.title;
    
    self.contentL.text = model.detail;
}

@end
