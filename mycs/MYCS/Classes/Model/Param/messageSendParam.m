//
//  messageSendParam.m
//  SWWY
//
//  Created by zhihua on 15/4/22.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "messageSendParam.h"

@implementation messageSendParam

- (NSString *)action{
    if (!_action) {
        _action = @"send";
    }
    return _action;
}

@end
