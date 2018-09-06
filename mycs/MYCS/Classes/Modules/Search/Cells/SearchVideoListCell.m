//
//  SearchVideoListCell.m
//  MYCS
//
//  Created by wzyswork on 16/1/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SearchVideoListCell.h"

@implementation SearchVideoListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.titleL.font = [UIFont systemFontOfSize:12];
    self.titleL.numberOfLines = 2;
    self.layer.borderWidth = 1;
    self.layer.borderColor = HEXRGB(0x999999).CGColor;
    self.iconImageView.contentMode = UIViewContentModeScaleToFill;
}

@end
