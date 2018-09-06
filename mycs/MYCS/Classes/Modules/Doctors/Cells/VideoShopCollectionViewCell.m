//
//  VideoShopCollectionViewCell.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "VideoShopCollectionViewCell.h"

#import "UIImage+blur.h"
#import "UIImageView+WebCache.h"

@interface VideoShopCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *playImageView;

@end

@implementation VideoShopCollectionViewCell

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    self.videoImageView.contentMode = UIViewContentModeScaleToFill;
}
-(void)setType:(NSString *)type
{
    self.typeLabel.font = [UIFont boldSystemFontOfSize:12];
    self.praiseNumBtn.titleLabel.textAlignment =NSTextAlignmentCenter;
    self.playNumBtn.titleLabel.textAlignment =NSTextAlignmentCenter;
    self.playImageView.width = self.width;
    
    _type = type;
    
    if ([_type isEqualToString:@"video"])
    {
        self.typeLabel.text = @"视频";
        
    }else if([_type isEqualToString:@"course"])
    {
        self.typeLabel.text = @"教程";
        
    }else if([_type isEqualToString:@"sop"])
    {
        self.typeLabel.text = @"SOP";
    }
    
    self.layer.borderColor = RGBCOLOR(225, 225, 225).CGColor;
    self.layer.borderWidth = 1;
}
-(void)setModel:(DoctorVideoCenterModel *)model{

    [self.videoImageView sd_setImageWithURL:[NSURL URLWithString: model.coverUrl]placeholderImage:PlaceHolderImage];
    
    [self.playNumBtn setTitle:model.viewNum forState:UIControlStateNormal];
    
    //CGSize size = [self.playNumBtn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGSize size = [self.playNumBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    
    self.playNumBtnWidth.constant = size.width + 35;
    
    for (UIView * view in self.subviews)
    {
        if (view.tag == 999)
        {
            [view removeFromSuperview];
        }
    }
    
    //内容
    UILabel * contentL = ({
        
        UILabel * contentL = [UILabel new];
        
        contentL.frame = CGRectMake(5, 85, self.width - 10, 45);
        
        contentL.tag = 999;
        
        contentL.font = [UIFont systemFontOfSize:13];
        
        contentL.textColor = HEXRGB(0x000000);
        
        contentL.numberOfLines = 2;
        
        contentL.text = model.title;
        
        contentL;
        
    });
    
    [self addSubview:contentL];
    self.type = model.type;
    [self.praiseNumBtn setTitle:model.praiseNum forState:UIControlStateNormal];
    
//    CGSize size1 = [self.praiseNumBtn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGSize size1 = [self.praiseNumBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    self.praiseNumWidth.constant = size1.width + 35;
}
@end
