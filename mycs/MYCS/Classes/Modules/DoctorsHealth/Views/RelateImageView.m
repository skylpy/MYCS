//
//  RelateImageView.m
//  MYCS
//
//  Created by GuiHua on 16/7/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "RelateImageView.h"
#import "DoctorsHealthList.h"
#import "UIImageView+WebCache.h"

@implementation RelateImageView

+ (instancetype)relateImageView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"RelateImageView" owner:nil options:nil] lastObject];
}

-(void)setImageArrs:(NSArray *)imageArrs
{
    _imageArrs = imageArrs;
    self.numberL.text = [NSString stringWithFormat:@"%lu",(unsigned long)imageArrs.count];
    
    int count = imageArrs.count > 3 ? 3:(int)imageArrs.count;
    
    for (int i=0 ;i < count ; i ++)
    {
        DoctorsHealthPhotos *model = imageArrs[i];
        UIImageView *im = self.imageViewArrs[i];
        model.url = [model.url stringByReplacingOccurrencesOfString:@"|" withString:@"%7C"];
        [im sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:PlaceHolderImage];
        UITapGestureRecognizer *tapImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        im.userInteractionEnabled = YES;
        [im addGestureRecognizer:tapImageView];
        
    }
    
}
-(void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIImageView *im = (UIImageView *)tap.view;
    
    if (self.tapImageViewblock && self.imageArrs.count != 0)
    {
        self.tapImageViewblock(im,im.tag);
    }
}
- (IBAction)ClickAll:(UIButton *)sender
{
    if (self.tapImageViewblock && self.imageArrs.count != 0)
    {
        self.tapImageViewblock([self.imageViewArrs firstObject],0);
    }
}

@end
