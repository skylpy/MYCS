//
//  NSMutableAttributedString+Attr.m
//  SWWY
//
//  Created by 黄希望 on 15-1-22.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "NSMutableAttributedString+Attr.h"

@implementation NSMutableAttributedString (Attr)

+ (NSMutableAttributedString *)string:(NSString *)strimg value1:(id)aValue_1 range1:(NSRange)aRange_1 value2:(id)aValue_2 range2:(NSRange)aRange_2 font:(float)aFont {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:strimg];

    if (aValue_1)
    {
        if ([aValue_1 isKindOfClass:[UIColor class]])
        {
            [str addAttribute:NSForegroundColorAttributeName value:aValue_1 range:aRange_1];
            [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:aFont] range:aRange_1];
        }
        else if ([aValue_1 isKindOfClass:[UIFont class]])
        {
            [str addAttribute:NSFontAttributeName value:aValue_1 range:aRange_1];
        }
    }

    if (aValue_2)
    {
        if ([aValue_2 isKindOfClass:[UIColor class]])
        {
            [str addAttribute:NSForegroundColorAttributeName value:aValue_2 range:aRange_2];
            [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:aFont] range:aRange_2];
        }
        else if ([aValue_2 isKindOfClass:[UIFont class]])
        {
            [str addAttribute:NSFontAttributeName value:aValue_2 range:aRange_2];
        }
    }
    return str;
}

- (void)setAttrColor:(UIColor *)color inRange:(NSRange)range {
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)setFontSize:(CGFloat)fontSize inRange:(NSRange)range {
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    [self addAttribute:NSFontAttributeName value:font range:range];
}

//UILabel转换颜色
+(NSMutableAttributedString *)transitionString:(NSString *)titles andStr:(NSString *)changeStr{
    
    NSString *SponsorString = [NSString stringWithFormat:@"%@: %@",titles,changeStr];
    NSMutableAttributedString *paintString = [[NSMutableAttributedString alloc] initWithString:SponsorString];
    
    [paintString addAttribute:NSForegroundColorAttributeName
                        value:HEXRGB(0x47c1a8)
                        range:[SponsorString
                               rangeOfString:changeStr]];
    return paintString;
}
+(NSMutableAttributedString *)relaTransitionString:(NSString *)titles andStr:(NSString *)changeStr{
    
    NSString *SponsorString = [NSString stringWithFormat:@"%@",titles];
    NSMutableAttributedString *paintString = [[NSMutableAttributedString alloc] initWithString:SponsorString];
    
    [paintString addAttribute:NSForegroundColorAttributeName
                        value:HEXRGB(0x47c1a8)
                        range:[SponsorString
                               rangeOfString:changeStr]];
    return paintString;
}

@end
