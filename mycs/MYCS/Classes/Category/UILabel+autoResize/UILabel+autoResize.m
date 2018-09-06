//
//  UILabel+autoResize.m
//  Starbucks
//
//  Created by Alex Peng on 8/30/13.
//  Copyright (c) 2013 FabriQate Inc. All rights reserved.
//

#import "UILabel+autoResize.h"
@implementation UILabel (autoResize)

@dynamic autoResize;

- (void)setAutoResize:(BOOL)autoResize {
    if (autoResize == YES) {
        [self setNumberOfLines:0];
        CGSize size = CGSizeMake(self.frame.size.width,MAXFLOAT);
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        CGSize labelsize = [self.text sizeWithFont:self.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
        
#pragma clang diagnostic pop
      
        if (labelsize.height>self.frame.size.height) {
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelsize.width, labelsize.height+5);
        }
    }
}

- (void)resizeWithMaxSize:(CGSize)maxSize
{
    [self setNumberOfLines:0];
    CGSize labelsize;
    if (iS_IOS7LATER) {
        labelsize = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
    } else {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        
        labelsize = [self.text sizeWithFont:self.font constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
        
#pragma clang diagnostic pop
        
    }
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, labelsize.width+20, labelsize.height+20);
}

@end
