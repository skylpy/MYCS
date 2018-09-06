//
//  CommentTypeListTableViewCell.m
//  MYCS
//
//  Created by Yell on 16/2/2.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "CommentTypeListTableViewCell.h"
@interface CommentTypeListTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *countLabel;


@end

@implementation CommentTypeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.redView.layer.cornerRadius = self.redView.height/2;
}


-(void)setMessageCount:(NSString *)messageCount
{
    _messageCount = messageCount;
    self.redView.hidden = messageCount.intValue>0?NO:YES;
    if (messageCount.intValue>99)
        self.countLabel.text = @"99+";
    else
        self.countLabel.text = messageCount;


}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
}

@end
