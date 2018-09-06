//
//  OrganizationMemberCell.h
//  MYCS
//
//  Created by wzyswork on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZHMemberInfo.h"

@interface OrganizationMemberCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (nonatomic,strong) ZHMemberInfo *memberInfo;

@end
