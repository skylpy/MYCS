//
//  HeadView.m
//  MYCS
//
//  Created by wzyswork on 16/2/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.searchBar.layer.cornerRadius = 4;
    self.searchBar.clipsToBounds = YES;
    
    self.width = ScreenW;
    self.height = 64;
    self.x = 0;
    self.y = 0;
}

-(void)showBlock:(void (^)(NSInteger))block
{
    _block = block;
}
- (IBAction)clickButton:(UIButton *)sender
{
    if (_block)
    {
        _block(sender.tag);
    }
    
}

+(instancetype)headView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:nil options:nil] lastObject];
}


@end
