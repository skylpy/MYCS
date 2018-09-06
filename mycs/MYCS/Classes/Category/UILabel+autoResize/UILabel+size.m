//
//  UILabel+size.m
//  SWWY
//
//  Created by 黄希望 on 15-1-15.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "UILabel+size.h"

@implementation UILabel (size)

- (CGSize)labelContentSize{
    if(self.text.length > 0 && [self.text characterAtIndex: self.text.length - 1] == '\n' ){
        self.text = [NSString stringWithFormat:@"%@%@", self.text,@" "];
    }
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    CGSize size = [self.text sizeWithFont:self.font
                        constrainedToSize:CGSizeMake(self.frame.size.width,100000)
                            lineBreakMode:NSLineBreakByWordWrapping];
    
#pragma clang diagnostic pop
    
    return size;
}

@end
