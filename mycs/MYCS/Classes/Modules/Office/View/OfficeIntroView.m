//
//  OfficeIntroView.m
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "OfficeIntroView.h"

@interface OfficeIntroView ()


@end

@implementation OfficeIntroView

+ (instancetype)introView{
    
    OfficeIntroView *view = [[[NSBundle mainBundle] loadNibNamed:@"OfficeIntroView" owner:nil options:nil]lastObject];
    
    return view;
    
}

@end
