//
//  DoctorInfoView.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "DoctorInfoView.h"

@interface DoctorInfoView ()

@end

@implementation DoctorInfoView

+ (instancetype)doctorInfoView{
    return [[[NSBundle mainBundle] loadNibNamed:@"DoctorInfoView" owner:nil options:nil]lastObject];
}

@end
