//
//  UserAvartCell.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/17.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "UserAvartCell.h"
#import "UserInfoCellModel.h"
#import "UIImageView+WebCache.h"

@interface UserAvartCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation UserAvartCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.avartView.layer.cornerRadius = self.avartView.width*0.5;
    self.avartView.layer.masksToBounds = YES;
    
    self.avartView.contentMode = UIViewContentModeScaleToFill;
    
}

- (void)setModel:(UserInfoCellModel *)model {
    _model = model;
    
    self.titleLabel.text = model.title;
    
    if ([AppManager sharedManager].user.userPic)
    {
        
        [self.avartView sd_setImageWithURL:[NSURL URLWithString:[AppManager sharedManager].user.userPic] placeholderImage:[UIImage imageNamed:@"face-h"]];
    }else
    {
        
        [self.avartView setImage:[UIImage imageWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userPic"]]];
    }
}
@end



