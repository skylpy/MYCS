//
//  LoadingView.m
//  MYCS
//
//  Created by GuiHua on 16/4/26.
//  Copyright © 2016年 GuiHua. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView

+(instancetype)shareLoadingView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:nil] lastObject];
}

@end
