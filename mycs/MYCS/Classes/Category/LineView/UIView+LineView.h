//
//  UIView+LineView.h
//  test
//
//  Created by AdminZhiHua on 15/12/7.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, LineViewType) {
    LineViewTypeNone = 0,
    LineViewTypeTop = 1,
    LineViewTypeLeft = 1 << 1,
    LineViewTypeBottom = 1 << 2,
    LineViewTypeRight = 1 << 3
};

@interface UIView (LineView)

@property (nonatomic,assign) LineViewType lineType;

/*!
 *  @author zhihua, 15-12-07 13:12:54
 *
 *  设置线条的颜色，建议先设置颜色再调用添加方法
 */
@property (nonatomic,strong) UIColor *lineColor;

- (void)addLineWithLineType:(LineViewType)type;

@end
