//
//  ChoosePersonCell.m
//  MYCS
//
//  Created by wzyswork on 16/1/11.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ChoosePersonCell.h"

@implementation ChoosePersonCell

- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];
    [self.chooseBtn setImage:[UIImage imageNamed:@"multiple_m"] forState:UIControlStateNormal];
    [self.chooseBtn setImage:[UIImage imageNamed:@"multiple_select"] forState:UIControlStateSelected];
    
    self.lbTitle.textColor = [UIColor blackColor];
    self.lbTitle.font = [UIFont systemFontOfSize:14];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
