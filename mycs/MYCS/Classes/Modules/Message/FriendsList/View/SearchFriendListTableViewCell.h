//
//  SearchFriendListTableViewCell.h
//  MYCS
//
//  Created by Yell on 16/1/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"


@protocol SearchFriendListTableViewCellDelegate <NSObject>

-(void)SearchFriendListTableViewCellClick:(FriendModel *)model;

@end

@interface SearchFriendListTableViewCell : UITableViewCell

@property (nonatomic,strong) FriendModel * model;

@property (nonatomic,weak)id<SearchFriendListTableViewCellDelegate> deleagte;

@end
