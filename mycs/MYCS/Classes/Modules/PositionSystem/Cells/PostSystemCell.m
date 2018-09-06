//
//  PostSystemCell.m
//  MYCS
//
//  Created by wzyswork on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "PostSystemCell.h"

@implementation PostSystemCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(PostSystem *)model
{
    _model = model;
    
    self.nameL.text = model.deptName;
    self.sopCountL.text = model.sopCount;
    [self.sopCountL sizeToFit];
    self.sopCountLWidth.constant = self.sopCountL.width;
    
    self.coureCountL.text  =model.courseCount;
    [self.coureCountL sizeToFit];
    self.coureCountLWidth.constant = self.coureCountL.width;
    
    self.parentNameL.text = [NSString stringWithFormat:@"所属部门：%@",model.parentName];
}
@end
