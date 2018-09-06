//
//  waitToDoTaskParam.m
//  SWWY
//
//  Created by zhihua on 15/4/22.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "waitToDoTaskParam.h"

@implementation waitToDoTaskParam

- (NSString *)device{
    
    if (!_device) {
        _device = @"3";
    }
    return _device;
    
}

@end
