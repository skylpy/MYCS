//
//  AssessSOPProgessButton.m
//  MYCS
//
//  Created by Yell on 16/1/20.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AssessSOPProgessButton.h"

@implementation AssessSOPProgessButton

-(void)setSelected:(BOOL)selected
{
    if (selected == YES)
        [self setBackgroundColor:HEXRGB(0x47c1a9)];
    else
        [self setBackgroundColor:HEXRGB(0xf4f4f4)];

    
    [super setSelected:selected];
}


@end
