//
//  SearchLaboratoryCell.m
//  MYCS
//
//  Created by wzyswork on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SearchLaboratoryCell.h"

@implementation SearchLaboratoryCell

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

@end
