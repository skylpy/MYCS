//
//  ChapterModel.m
//  SWWY
//
//  Created by 黄希望 on 15-1-24.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "ChapterModel.h"
#import "MJExtension.h"

@implementation ChapterModel
MJCodingImplementation

+ (BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

+(JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{@"id":@"chapterId"}];
}

@end
