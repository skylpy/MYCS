//
//  FriendsListTableViewCell.h
//  MYCS
//
//  Created by Yell on 16/1/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "friendModel.h"

@interface FriendsListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *allowView;

@property (weak, nonatomic) IBOutlet UIImageView *newsImage;

@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@property (strong,nonatomic) FriendModel * model;


@end
