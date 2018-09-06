//
//  StudyRecordTableViewCell.m
//  MYCS
//
//  Created by wzyswork on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "StudyRecordTableViewCell.h"

@implementation StudyRecordTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.timeLabel.numberOfLines = 0;
    self.nameLabel.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
