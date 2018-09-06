//
//  SearchNewFriendTableViewCell.m
//  MYCS
//
//  Created by Yell on 16/1/11.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SearchNewFriendTableViewCell.h"
#import "AddFriendVerifyViewController.h"
#import "UIButton+WebCache.h"
@interface SearchNewFriendTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation SearchNewFriendTableViewCell


-(void)setModel:(FriendModel *)model
{
    [super awakeFromNib];
    _model = model;
    [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:model.pic_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"face-h"]];
    self.nameLabel.text = model.name;
    if (model.isfriend) {
        self.addBtn.backgroundColor = [UIColor whiteColor];
        self.addBtn.enabled = NO;
    }else
    {
        self.addBtn.backgroundColor = HEXRGB(0xf6f6f6);
        self.addBtn.enabled = YES;

    }
}

- (IBAction)addAciton:(UIButton *)sender {
    
    AddFriendVerifyViewController *Vc = [[UIStoryboard storyboardWithName:@"AddFriendVerifyViewController" bundle:nil]instantiateViewControllerWithIdentifier:@"AddFriendVerifyViewController"];
    Vc.model = self.model;
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:Vc animated:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(UITableViewCellSelectionStyle)selectionStyle
{
    return UITableViewCellSelectionStyleNone;
}

@end
