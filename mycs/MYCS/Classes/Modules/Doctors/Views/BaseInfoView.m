//
//  BaseInfoView.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "BaseInfoView.h"

@interface BaseInfoView ()

@end

@implementation BaseInfoView


+ (instancetype)baseInfoView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"BaseInfoView" owner:nil options:nil]lastObject];
    
}


@end
