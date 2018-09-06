//
//  JobTitleModel.h
//  MYCS
//
//  Created by AdminZhiHua on 15/11/16.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import "JSONModel.h"

@interface JobTitleModel : JSONModel

@property (strong, nonatomic) NSString *id; //职业ID号
@property (strong, nonatomic) NSString *name; //职业名称

+ (void)requestJobsTitleSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end
