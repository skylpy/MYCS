//
//  UITableView+UITableView_Util.h
//  SFPay
//
//  Created by white on 14-11-24.
//  Copyright (c) 2014年 SF. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (UITableView_Util)

/**
 *	@brief	自动调整表格的高度
 */
@property (nonatomic,setter=setAutoResize:) BOOL autoResize;

/**
 *	@brief	当列表无内容时为空，不显示分隔线,提示无数据
 */
-(void)setNoDataTipsView:(NSInteger)topY;
-(void)removeNoDataTipsView;
@end
