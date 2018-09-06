//
//  UIImage+blur.h
//  SWWY
//
//  Created by Yell on 15/6/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (blur)

- (UIImage *)imgWithLightAlpha:(CGFloat)alpha radius:(CGFloat)radius colorSaturationFactor:(CGFloat)colorSaturationFactor;
// 2.封装好,供外界调用的
- (UIImage *)imgWithBlur;

+ (UIImage *)imageWithOrignWith:(NSString *)imageName;

@end
