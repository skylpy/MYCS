//
//  AreaModel.h
//  MYCS
//
//  Created by AdminZhiHua on 15/11/15.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Province,City,Area;
@interface AreaModel : NSObject


@property (nonatomic, strong) NSArray<Province *> *provinceArr;

+ (AreaModel *)getAreaInfo;


@end
@interface Province : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, strong) NSArray<City *> *children;

@property (nonatomic, copy) NSString *text;

@end

@interface City : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *state;

@property (nonatomic, strong) NSArray<Area *> *children;

@property (nonatomic, copy) NSString *text;

@end

@interface Area : NSObject

@property (nonatomic, copy) NSString *id;

@property (nonatomic, copy) NSString *text;

@end

