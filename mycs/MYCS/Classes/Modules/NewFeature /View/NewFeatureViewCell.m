//
//  NewFeatureViewCell.m
//  SWWY
//
//  Created by AdminZhiHua on 15/11/5.
//  Copyright © 2015年 GuoChenghao. All rights reserved.
//

#import "NewFeatureViewCell.h"
#import "UIImage+FullscreenImage.h"

static int const count = 4;

@interface NewFeatureViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *enterBtn;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@end

@implementation NewFeatureViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.enterBtn setTitle:@"进入首页" forState:UIControlStateNormal];
    [self.enterBtn.titleLabel setFont:[UIFont systemFontOfSize:20]];

    [self.enterBtn setBackgroundColor:HEXRGB(0xE7E7E7)];
    [self.enterBtn setTitleColor:HEXRGB(0x44464b) forState:UIControlStateNormal];

    self.enterBtn.layer.cornerRadius  = 6;
    self.enterBtn.layer.masksToBounds = YES;

    [self.enterBtn sizeToFit];
}

- (void)setIndexPath:(NSIndexPath *)indexPath {
    _indexPath = indexPath;

    NSString *imageName = [NSString stringWithFormat:@"newfeature_%02d", (int)(indexPath.row + 1)];

    UIImage *image = [UIImage imageForDeviceWithName:imageName];

    self.bgImageView.image = image;

    if (indexPath.row == count - 1)
    {
        [UIView animateWithDuration:0.25 animations:^{
            self.enterBtn.alpha = 1;
        }];
    }
    else
    {
        self.enterBtn.alpha = 0;
    }
}

@end
