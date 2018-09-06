//
//  SearchFriendListTableViewCell.m
//  MYCS
//
//  Created by Yell on 16/1/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SearchFriendListTableViewCell.h"
#import "UIButton+WebCache.h"
@interface SearchFriendListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation SearchFriendListTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
}

-(void)setModel:(FriendModel *)model
{
    _model = model;
    [self.imageBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_model.pic_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"face-h"]];
    self.nameLabel.text = _model.name;
}


- (IBAction)imageBtnAction:(UIButton *)sender {
    
    if ([self.deleagte respondsToSelector:@selector(SearchFriendListTableViewCellClick:)])
    {
        
        [self.deleagte SearchFriendListTableViewCellClick:self.model];
        return;
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
