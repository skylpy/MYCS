//
//  HeaderView.h
//  CityListWithIndex
//
//  Created by ljw on 16/7/19.
//  Copyright © 2016年 ljw. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView

@property (nonatomic,strong)UIView *headView;
@property (nonatomic, strong)UIView          * titleView;
@property (nonatomic, strong)UILabel         * titleLabel;
@property (nonatomic, copy)NSString          * titleString;

- (void)setTitleString:(NSString *)titleString;

@end
