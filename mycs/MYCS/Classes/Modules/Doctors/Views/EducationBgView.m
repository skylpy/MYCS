//
//  EducationBgView.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "EducationBgView.h"

@interface EducationBgView ()

@end

@implementation EducationBgView

+ (instancetype)educationBgView{
    return [[[NSBundle mainBundle] loadNibNamed:@"EducationBgView" owner:nil options:nil]lastObject];
}

@end
