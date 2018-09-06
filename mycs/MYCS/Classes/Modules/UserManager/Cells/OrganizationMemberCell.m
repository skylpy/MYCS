//
//  OrganizationMemberCell.m
//  MYCS
//
//  Created by wzyswork on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "OrganizationMemberCell.h"
#import "UIImageView+WebCache.h"

@implementation OrganizationMemberCell

- (void)setMemberInfo:(ZHMemberInfo *)memberInfo
{
    _memberInfo = memberInfo;
    
    self.nameLabel.text = memberInfo.name;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:memberInfo.avatar] placeholderImage:[UIImage imageNamed:@"zc_gr"]];
    
}

- (void)awakeFromNib
{
    
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = self.iconView.width * 0.5;
    
    self.iconView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
