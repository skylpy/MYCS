//
//  OfficeModel.h
//  MYCS
//
//  Created by AdminZhiHua on 15/11/15.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface OfficeModel : JSONModel

@property (strong, nonatomic) NSString *industryId; //科室ID号
@property (strong, nonatomic) NSString *industryName; //科室名称

+ (void)getOfficeListSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end
