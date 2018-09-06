//
//  UITableView+UITableView_Util.m
//  SFPay
//
//  Created by white on 14-11-24.
//  Copyright (c) 2014年 SF. All rights reserved.
//

#import "UITableView+UITableView_Util.h"

@implementation UITableView (UITableView_Util)
@dynamic autoResize;

- (void)setAutoResize:(BOOL)autoResize{
    if (autoResize) {
        [self reloadData];
        CGRect rt = self.frame;
        rt.size.height = self.contentSize.height;
        self.frame = rt;
    }
}
-(void)removeNoDataTipsView
{
    
    UIView * view = [self viewWithTag:88888888];
    [view removeFromSuperview];
}
-(void)setNoDataTipsView:(NSInteger)topY;
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, topY, ScreenW, ScreenH)];
    [footerView addSubview:[self noDataTips]];
    footerView.backgroundColor = [UIColor clearColor];
    footerView.tag = 88888888;
    self.tableFooterView = footerView;
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

