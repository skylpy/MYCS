//
//  MemberDetailCell.m
//  MYCS
//
//  Created by wzyswork on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MemberDetailCell.h"

@implementation MemberDetailCell



- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(GradeModel *)model{
  
    _model = model;
    
    self.nameLabel.text = model.gradeName;
    self.yearLabel.text = [NSString stringWithFormat:@"%@年", model.year];
    self.countLabel.text = [NSString stringWithFormat:@"%@人", model.staff];
    
    switch ([model.audit integerValue])
    {
        case applyStatus_ing:
            
            [self.statusBtn setTitle:@"审核中" forState:UIControlStateNormal];
            [self.statusBtn setImage:[UIImage imageNamed:@"audit"] forState:UIControlStateNormal];
            [self.statusBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:144/255.0 blue:96/255.0 alpha:1] forState:UIControlStateNormal];
            
            break;
        case applyStatus_cross:
            
            [self.statusBtn setTitle:@"已通过" forState:UIControlStateNormal];
            [self.statusBtn setImage:[UIImage imageNamed:@"pass"] forState:UIControlStateNormal];
            [self.statusBtn setTitleColor:[UIColor colorWithRed:71/255.0 green:193/255.0 blue:170/255.0 alpha:1] forState:UIControlStateNormal];
            
            break;
        case applyStatus_reject:
            
            [self.statusBtn setTitle:@"已拒绝" forState:UIControlStateNormal];
            [self.statusBtn setImage:[UIImage imageNamed:@"applyno"] forState:UIControlStateNormal];
            [self.statusBtn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
            
            break;
        case applyStatus_overdue:
            
            [self.statusBtn setTitle:@"已过期" forState:UIControlStateNormal];
            [self.statusBtn setImage:[UIImage imageNamed:@"past"] forState:UIControlStateNormal];
            [self.statusBtn setTitleColor:[UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1] forState:UIControlStateNormal];
            
            break;
        default:
            break;
    }

}
@end
