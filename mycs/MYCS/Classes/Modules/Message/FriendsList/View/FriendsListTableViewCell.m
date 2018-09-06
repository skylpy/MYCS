//
//  FriendsListTableViewCell.m
//  MYCS
//
//  Created by Yell on 16/1/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "FriendsListTableViewCell.h"
#import "PersonalInformationViewController.h"
#import "UIButton+WebCache.h"
@interface FriendsListTableViewCell ()


@end
@implementation FriendsListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.newsImage.layer.cornerRadius = self.newsImage.width / 2;
    self.newsImage.clipsToBounds = YES;
}


-(void)setModel:(FriendModel *)model
{
    _model = model;
    [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.pic_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"face-h"]];
    self.nameLabel.text = model.name;
}
- (IBAction)imageBtnAction:(UIButton *)sender {
    
    if ([self.nameLabel.text isEqualToString:@"新的朋友"])return;
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"FriendsList" bundle:nil];
    PersonalInformationViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"PersonalInformationViewController"];
    controller.model = self.model;
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
