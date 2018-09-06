//
//  UILabel+Attr.m
//  MYCS
//
//  Created by wzyswork on 15/12/28.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "UILabel+Attr.h"

@implementation UILabel (Attr)
- (void)attrInRange:(NSRange)range{
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    [text addAttribute: NSForegroundColorAttributeName value: [UIColor colorWithRed:83/255.0 green:129/255.0 blue:197/255.0 alpha:0.9] range: range];
    
    [self setAttributedText: text];
}

- (void)attrInAnswerRange:(NSRange)range{
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithAttributedString: self.attributedText];
    [text addAttribute: NSForegroundColorAttributeName value: [UIColor blackColor] range: range];
    
    [self setAttributedText: text];
}
@end
