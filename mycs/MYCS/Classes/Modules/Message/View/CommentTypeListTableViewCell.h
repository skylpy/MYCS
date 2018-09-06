//
//  CommentTypeListTableViewCell.h
//  MYCS
//
//  Created by Yell on 16/2/2.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTypeListTableViewCell : UITableViewCell
@property (copy,nonatomic) NSString *messageCount;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UIView *redView;


@end
