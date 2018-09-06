//
//  PositionModel.h
//  MYCS
//
//  Created by AdminZhiHua on 15/11/16.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "JSONModel.h"

@interface PositionModel : JSONModel

@property (strong, nonatomic) NSString *id; //行政职位ID号
@property (strong, nonatomic) NSString *name; //行政职位名称

+ (void)requestPositionSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end
