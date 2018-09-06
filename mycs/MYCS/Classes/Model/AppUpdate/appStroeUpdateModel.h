//
//  appStroeUpdateModel.h
//  SWWY
//
//  Created by Yell on 15/5/27.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface appStroeUpdateModel : JSONModel
//esultCount=1;results
@property (copy,nonatomic) NSString *resultCount;
@property (strong,nonatomic) NSDictionary *results;

@end
