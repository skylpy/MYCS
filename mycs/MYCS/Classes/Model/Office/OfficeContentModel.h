//
//  OfficeModel.h
//  SWWY
//
//  Created by Yell on 15/7/12.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface OfficeDetailHonourListModel : JSONModel

@property(nonatomic,copy) NSString<Optional>  *id;
@property(nonatomic,copy) NSString<Optional>  *uid;
@property(nonatomic,copy) NSString<Optional>  *sid;
@property(nonatomic,copy) NSString<Optional>  *title;
@property(nonatomic,copy) NSString<Optional>  *inputtime;
@property(nonatomic,copy) NSString<Optional>  *content;
@property(nonatomic,copy) NSString<Optional>  *lid;
@property(nonatomic,copy) NSString<Optional>  *imgUrl;


@end

@interface OfficeDetailIndustryModel : JSONModel

@property(nonatomic,copy) NSString<Optional> *entity;

@end

@interface OfficeDetailUserModel : JSONModel

@property(nonatomic,copy) NSString<Optional> *entity;

@end

@interface OfficeDetailModel : JSONModel

@property(nonatomic,copy) NSString<Optional> *realname;
@property(nonatomic,copy) NSString<Optional>  *sid;
@property(nonatomic,copy) NSString<Optional>  *email;
@property(nonatomic,copy) NSString<Optional>  *imgUrl;
@property(nonatomic,copy) NSString<Optional>  *perQrCode;
@property(nonatomic,copy) NSString<Optional>  *uid;
@property(nonatomic,copy) NSString<Optional>  *contacts;
@property(nonatomic,copy) NSString<Optional>  *phone;
@property(nonatomic,copy) NSString<Optional>  *scale;
@property(nonatomic,copy) NSString<Optional>  *address;
@property(nonatomic,copy) NSString<Optional>  *title;
@property(nonatomic,copy) NSString<Optional>  *mobile;
@property(nonatomic,copy) NSString<Optional>  *area_id;
@property(nonatomic,copy) NSString<Optional>  *industry_id;
@property(nonatomic,copy) NSString<Optional>  *shortCode;
@property(nonatomic,copy) NSString<Optional>  *businessLicense;
@property(nonatomic,copy) NSString<Optional>  *addIp;
@property(nonatomic,copy) NSString<Optional>  *addTime;
@property(nonatomic,copy) NSString<Optional>  *adm_id;
@property(nonatomic,copy) NSString<Optional>  *checkTime;
@property(nonatomic,copy) NSString<Optional>  *state;
@property(nonatomic,copy) NSString<Optional>  *remarks;
@property(nonatomic,copy) NSString<Optional>  *introduction;
@property(nonatomic,copy) NSString<Optional>  *logo;
@property(nonatomic,copy) NSString<Optional>  *ico;
@property(nonatomic,copy) NSString<Optional>  *banners;
@property(nonatomic,copy) NSString<Optional>  *maxStaffCount;
@property(nonatomic,copy) NSString<Optional>  *maxSizeCount;
@property(nonatomic,copy) NSString<Optional>  *buyVideoSize;
@property(nonatomic,copy) NSString<Optional>  *extraInfo;
@property(nonatomic,copy) NSString<Optional>  *question;
@property(nonatomic,copy) NSString<Optional>  *contactEmail;
@property(nonatomic,copy) NSString<Optional>  *is_collect;
@property(nonatomic,assign) BOOL platformAuth;
@property(nonatomic,copy) NSString<Optional>  *levelStr;
@property(nonatomic,copy) OfficeDetailUserModel<Optional>  *user;
@property(nonatomic,copy) OfficeDetailIndustryModel<Optional>  *industry;
@property(nonatomic,copy) NSString<Optional>  *placeStr;
@property(nonatomic,copy) NSArray<Optional>  *honourList;
//科室专属
@property(nonatomic,copy) NSString<Optional>  *divisionName;
@property(nonatomic,assign) BOOL isAuthByHos;
@property(nonatomic,assign) BOOL isAuthByDiv;

//在医院前提下，1表示学院，
@property(nonatomic,copy) NSString<Optional>  *isAcademy;

@end

@interface OfficeUnDetailModel : NSObject

@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *sid;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *industry_id;
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,copy) NSString *divisionName;

+ (void)OfficeListsWithUid:(NSString *)checkUid
                      page:(int)page
                  pageSize:(int)pageSize
                   success:(void (^)(NSArray *officeLists))success
                   failure:(void (^)(NSError *error))failure;

@end


@interface OfficeContentModel : JSONModel

+ (void)OfficeDetailWithUid:(NSString *)checkUid success:(void (^)(OfficeDetailModel *model))success failure:(void (^)(NSError *error))failure;


@end
