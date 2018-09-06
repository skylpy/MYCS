//
//  TaskSelectView.h
//  MYCS
//
//  Created by yiqun on 16/8/31.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskSelectView : UIView

@property (nonatomic, strong)UILabel         * titleLabel;
@property (nonatomic, strong)UIImageView     * icon;
@property (nonatomic, copy)NSString          * titleString;

- (void)setTitleString:(NSString *)titleString andColor:(UIColor *)color;

@end
