//
//  WorkView.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "WorkView.h"

@interface WorkView ()

@end

@implementation WorkView

+ (instancetype)workView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"WorkView" owner:nil options:nil]lastObject];

}

@end
