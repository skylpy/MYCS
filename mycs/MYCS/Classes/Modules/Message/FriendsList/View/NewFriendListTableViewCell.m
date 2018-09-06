//
//  NewFriendListTableViewCell.m
//  MYCS
//
//  Created by Yell on 16/1/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "NewFriendListTableViewCell.h"
#import "UIButton+WebCache.h"
#import "UIView+Message.h"
@interface NewFriendListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *acceptBtn;
@property (weak, nonatomic) IBOutlet UILabel *checkContentLabel;

@end

@implementation NewFriendListTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

-(void)setModel:(FriendModel *)model
{
    _model = model;
    [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.pic_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"face-h"]];
    self.nameLabel.text = model.name;
    self.checkContentLabel.text = model.check_content;
    
    switch (model.addStatus.intValue) {
        case 1:
            [self.acceptBtn setTitle:@"已接受" forState:UIControlStateDisabled];
            [self.acceptBtn setTitleColor:HEXRGB(0xd1d1d1) forState:UIControlStateDisabled];
            self.acceptBtn.backgroundColor = [UIColor whiteColor];
            self.acceptBtn.enabled = NO;
            break;
        case 2:
            [self.acceptBtn setTitle:@"已添加" forState:UIControlStateDisabled];
            [self.acceptBtn setTitleColor:HEXRGB(0xd1d1d1) forState:UIControlStateDisabled];
            self.acceptBtn.backgroundColor = [UIColor whiteColor];
            self.acceptBtn.enabled = NO;
            break;
        case 3:
            [self.acceptBtn setTitle:@"接受" forState:UIControlStateNormal];
            [self.acceptBtn setTitleColor:HEXRGB(0x666666) forState:UIControlStateNormal];
            self.acceptBtn.backgroundColor = HEXRGB(0xf6f6f6);
            self.acceptBtn.enabled = YES;
            break;
        case 4:
            [self.acceptBtn setTitle:@"等待接受" forState:UIControlStateDisabled];
            [self.acceptBtn setTitleColor:HEXRGB(0xd1d1d1) forState:UIControlStateDisabled];
            self.acceptBtn.backgroundColor = [UIColor whiteColor];
            self.acceptBtn.enabled = NO;
            break;
    
        default:
            break;
    }
}

- (IBAction)acceptAction:(UIButton *)sender {
    [self showLoading];
    [FriendModel addFriendWithFriendId:self.model.friendId demand:@"accept" checkcontent:nil Success:^{
        [self showSuccessWithStatus:@"添加成功"];
        [[AppDelegate sharedAppDelegate].rootNavi popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewsFriends" object:nil];
        
    } failure:^(NSError *error) {
        [self showErrorMessage:@"添加失败"];

    }];
     
     
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
