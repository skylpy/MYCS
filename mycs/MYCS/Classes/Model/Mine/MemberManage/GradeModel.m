//
//  GradeModel.m
//  SWWY
//
//  Created by GuoChenghao on 15/2/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "GradeModel.h"

@implementation GradeModel

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"memberID"}];
}

@end
