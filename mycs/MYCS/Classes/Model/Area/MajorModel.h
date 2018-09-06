//
//  MajorModel.h
//  MYCS
//
//  Created by AdminZhiHua on 15/11/16.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "JSONModel.h"

@protocol MajorModel

@end

@interface MajorModel : JSONModel

@property (strong, nonatomic) NSString *modelID;
@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSArray<MajorModel, Optional> *children;

+ (void)requestMajorSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end
