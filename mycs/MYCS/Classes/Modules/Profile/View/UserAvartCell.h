//
//  UserAvartCell.h
//  MYCS
//
//  Created by AdminZhiHua on 15/11/17.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfoCellModel;
@interface UserAvartCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avartView;

@property (nonatomic,strong) UserInfoCellModel *model;

@end
