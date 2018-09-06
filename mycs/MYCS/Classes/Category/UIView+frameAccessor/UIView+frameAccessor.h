//
//  UIView+frameAccessor.h
//  tata
//
//  Created by Calvin on 13-7-26.
//  Copyright (c) 2013年 Maxicn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (frameAccessor)
- (CGPoint)origin;
- (void)setOrigin:(CGPoint)newOrigin;
- (CGSize)size;
- (void)setSize:(CGSize)newSize;

- (CGFloat)x;
- (void)setX:(CGFloat)newX;
- (CGFloat)y;
- (void)setY:(CGFloat)newY;

- (CGFloat)height;
- (void)setHeight:(CGFloat)newHeight;
- (CGFloat)width;
- (void)setWidth:(CGFloat)newWidth;

- (CGFloat)bottom;
- (CGFloat)right;

- (CGFloat)max_y;
- (CGFloat)max_x;
@end
