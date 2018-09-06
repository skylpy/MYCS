//
//  UICollectionView+NoDataTips.m
//  MYCS
//
//  Created by GuiHua on 16/7/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "UICollectionView+NoDataTips.h"

@implementation UICollectionView (NoDataTips)

-(void)removeNoDataTipsView
{

    UIView * view = [self viewWithTag:88888888];
    [view removeFromSuperview];
}

-(void)setNoDataTipsView:(NSInteger)topY
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, topY, ScreenW, ScreenH)];
    [footerView addSubview:[self noDataTips]];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.tag = 88888888;
    [self addSubview: footerView];
}

//搜索没有结果的提示
-(UILabel *)noDataTips{
    
    UILabel * label = ({
        
        UILabel * label = [UILabel new];
        
        [label setText:@"没有相关数据！"];
        
        label.frame = CGRectMake(0, 20, ScreenW, 40);
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = [UIFont systemFontOfSize:14];
        
        label.textColor = HEXRGB(0x999999);
        
        label;
    });
    
    return label;
}


@end
