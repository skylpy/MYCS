//
//  PersonalMemberModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/2/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface PersonalMemberModel : JSONModel

@property (nonatomic,strong) NSString<Optional> *agencyId; // 机构UID
@property (nonatomic,strong) NSString<Optional> *realname; // 机构名称
@property (nonatomic,strong) NSString<Optional> *avatar; //  机构LOGO
@property (nonatomic,strong) NSNumber<Optional> *gradeTotal; // 申请机构服务总数
@property (nonatomic,strong) NSString<Optional> *gradeName; // 某项服务名称

//=========【企业、个人接口】========//
+ (void)listWithUerId:(NSString*)userId
             userType:(NSString*)userType
               action:(NSString*)action
                 page:(int)page
             pageSize:(int)pageSize
              keyword:(NSString*)keyword // 个人 企业 搜机构时传
              success:(void (^)(NSArray *list))success
              failure:(void (^)(NSError *error))failure;

@end
