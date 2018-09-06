//
//  AreaModel.m
//  MYCS
//
//  Created by AdminZhiHua on 15/11/15.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "AreaModel.h"
#import "MJExtension.h"

@implementation AreaModel


+ (NSDictionary *)objectClassInArray{
    return @{@"provinceArr" : [Province class]};
}

+ (AreaModel *)getAreaInfo {
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"area.txt" ofType:nil];
    
    NSString *jsonStr = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *provinceArr = [Province objectArrayWithKeyValuesArray:jsonStr];
    
    AreaModel *model = [[AreaModel alloc] init];
    model.provinceArr = provinceArr;
    
    return model;
    
}

@end

@implementation Province

+ (NSDictionary *)objectClassInArray{
    return @{@"children" : [City class]};
}

@end


@implementation City

+ (NSDictionary *)objectClassInArray{
    return @{@"children" : [Area class]};
}

@end


@implementation Area

@end


