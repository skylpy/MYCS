//
//  HosOffEntListModel.h
//  SWWY
//
//  Created by zhihua on 15/7/16.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HosOffEntListModel : NSObject


@property (nonatomic, copy) NSString *imgUrl;

@property (nonatomic, copy) NSString *uid;

@property (nonatomic, copy) NSString *industry_id;

@property (nonatomic, copy) NSString *skill;

@property (nonatomic, copy) NSString *realname;

@property (nonatomic, copy) NSString *sid;

@property (nonatomic, copy) NSString *divisionName;

@property (nonatomic, copy) NSString *levelStr;

+ (void)HosOffEntListWithAction:(NSString *)action
                      page:(int)page
                  pageSize:(int)pageSize
                   success:(void (^)(NSArray *list))success
                   failure:(void (^)(NSError *error))failure;


@end
