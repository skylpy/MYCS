//
//  updateModel.h
//  SWWY
//
//  Created by Yell on 15/5/13.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "SCBModel.h"
#import "appStroeUpdateModel.h"

@interface UpdateModel : JSONModel

@property (nonatomic,copy) NSString *version;
@property (nonatomic,copy) NSString *typ;
@property (nonatomic,copy) NSString *up_time;
@property (nonatomic,copy) NSString *msg;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *force;
@property (nonatomic,copy) NSString *match;

+(void)checkUpdateInServerSuccess:(void (^)(UpdateModel *model))success failure:(void (^)(NSError *error))failure;

+(void)checkUpdateInAppStoreSuccess:(void (^)(appStroeUpdateModel*contentInStore))success failure:(void (^)(NSError * error))failure;

@end
