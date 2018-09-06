//
//  SCBModel.h
//  zlds
//
//  Created by GuoChengHao on 14-7-4.
//  Copyright (c) 2014年 qt. All rights reserved.
//

#import "JSONModel.h"
#import "APIClient.h"
#import "ConstKeys.h"

@interface SCBModel : JSONModel

@property (strong, nonatomic) NSString *code;
@property (strong, nonatomic) NSString<Optional> *msg;
@property (strong, nonatomic) NSDictionary<Optional> *data;

+ (void)BGET:(NSString *)URLString
  parameters:(id)parameters
     encrypt:(BOOL)encrypt
     success:(void (^)(SCBModel *model))success
     failure:(void (^)(NSError *error))failure;

+ (void)BPOST:(NSString *)URLString
   parameters:(id)parameters
      encrypt:(BOOL)encrypt
      success:(void (^)(SCBModel *model))success
      failure:(void (^)(NSError *error))failure;

@end
