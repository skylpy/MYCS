//
//  SopCourseModel.m
//  SWWY
//
//  Created by 黄希望 on 15-1-24.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "SopCourseModel.h"

@implementation SopCourseModel

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"course_id": @"courseId",@"pass_rate":@"passRate"}];
}

@end
