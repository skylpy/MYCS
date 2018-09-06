//
//  DoctorModel.h
//  SWWY
//
//  Created by Yell on 15/6/19.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface DoctorListModel : JSONModel
//=======================名医列表类======================//

@property(nonatomic,copy) NSString *uid;
@property(nonatomic,copy) NSString *userType;
@property(nonatomic,copy) NSString *username;
@property(nonatomic,copy) NSString *realname;
@property(nonatomic,copy) NSString *mobile;
@property(nonatomic,copy) NSString *address;
@property(nonatomic,copy) NSString *sid;
@property(nonatomic,copy) NSString *email;
@property(nonatomic,copy) NSString *imgUrl;
@property(nonatomic,copy) NSString *jobTitleName;
@property(nonatomic,copy) NSString *isAuth;
@property(nonatomic,copy) NSString *goodat;
@property(nonatomic,copy) NSString *hospital;
@property(nonatomic,copy) NSString *divisionName;
@property(nonatomic,assign) BOOL isAuthByHos;
@property(nonatomic,assign) BOOL isAuthByDiv;

@end

@interface DoctorVideoCenterModel : JSONModel

@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *praiseNum;
@property(nonatomic,copy) NSString *viewNum;
@property(nonatomic,copy) NSString *addTime;
@property(nonatomic,copy) NSString *coverUrl;
@property(nonatomic,copy) NSString *type;


@end

@interface DoctorModel : JSONModel


//名医列表
+ (void)doctorListsWithpage:(int)page
                   pageSize:(int)pageSize
                   UserID:(NSString *)userId
                   keyWord:(NSString *)keyWord
                  fromCache:(BOOL)isFromeCache
                    success:(void (^)(NSArray *list))success
                    failure:(void (^)(NSError *error))failure;

//科室、医院 名医列表接口
+ (void)doctorListsWithcheckID:(NSString *)checkID
                          page:(int)page
                   pageSize:(int)pageSize
                    success:(void (^)(NSArray *list))success
                    failure:(void (^)(NSError *error))failure;


//名医里的视频中心
+ (void)doctorVideoCenterWithDoctorUid:(NSString *)uid agroup_id:(NSString *)agroup_id
                               success:(void (^)(NSArray *list))success
                               failure:(void (^)(NSError *error))failure;
@end
