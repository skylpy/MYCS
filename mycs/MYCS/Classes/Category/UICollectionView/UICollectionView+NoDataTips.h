//
//  UICollectionView+NoDataTips.h
//  MYCS
//
//  Created by GuiHua on 16/7/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UICollectionView (NoDataTips)


/**
 *	@brief	当列表无内容时为空，不显示分隔线,提示无数据
 */
-(void)setNoDataTipsView:(NSInteger)topY;

-(void)removeNoDataTipsView;

@end
