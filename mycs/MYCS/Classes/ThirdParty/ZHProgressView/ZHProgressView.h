//
//  ZHProgressView.h
//  SWWY
//
//  Created by zhihua on 15/5/3.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZHProgressView : UIView

/**
 *  比例的字体大小
 */
@property (nonatomic,assign) int fontSize;

/**
 *  圆弧的厚度
 */
@property (nonatomic,assign) int lineWith;

/**
 *  总大小
 */
@property (nonatomic,assign) float totalProgress;

/**
 *  当前的大小
 */
@property (nonatomic,assign) float currentProgress;

/**
 * 进度圈的颜色
 */
@property (nonatomic,strong) UIColor *radiusColor;


@end
