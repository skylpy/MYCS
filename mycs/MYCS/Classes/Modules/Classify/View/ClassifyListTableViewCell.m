//
//  ClassifyListTableViewCell.m
//  MYCS
//
//  Created by Yell on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ClassifyListTableViewCell.h"
@interface ClassifyListTableViewCell()


@end

@implementation ClassifyListTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    if (selected)
    {
        self.nameLabel.textColor = HEXRGB(0xf66060);
        self.colorView.backgroundColor = HEXRGB(0xf66060);
    }
    else
    {
    
        self.nameLabel.textColor = HEXRGB(0x666666);
    }
    
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
