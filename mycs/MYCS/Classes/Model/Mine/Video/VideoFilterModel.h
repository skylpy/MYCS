//
//  VideoFilterModel.h
//  SWWY
//
//  Created by 黄希望 on 15-1-25.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EnumDefine.h"

@interface VideoFilterModel : NSObject

@property (assign,nonatomic) FromType fromType;
@property (assign,nonatomic) Paper paper;
@property (assign,nonatomic) IntPerm intPerm;
@property (assign,nonatomic) ExtPerm extPerm;

@end
