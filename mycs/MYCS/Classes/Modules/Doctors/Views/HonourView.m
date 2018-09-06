//
//  HonourView.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "HonourView.h"


@interface HonourView ()


@end

@implementation HonourView

+ (instancetype)honourView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"HonourView" owner:nil options:nil]lastObject];

}

@end
