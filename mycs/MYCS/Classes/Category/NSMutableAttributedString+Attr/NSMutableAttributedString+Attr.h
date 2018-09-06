//
//  NSMutableAttributedString+Attr.h
//  SWWY
//
//  Created by 黄希望 on 15-1-22.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Attr)

+ (NSMutableAttributedString *)string:(NSString *)str value1:(id)aValue_1 range1:(NSRange)aRange_1 value2:(id)aValue_2 range2:(NSRange)aRange_2 font:(float)aFont;

- (void)setAttrColor:(UIColor *)color inRange:(NSRange)range;

- (void)setFontSize:(CGFloat)fontSize inRange:(NSRange)range;

//UILabel转换颜色
+(NSMutableAttributedString *)transitionString:(NSString *)titles andStr:(NSString *)changeStr;
+(NSMutableAttributedString *)relaTransitionString:(NSString *)titles andStr:(NSString *)changeStr;
@end
