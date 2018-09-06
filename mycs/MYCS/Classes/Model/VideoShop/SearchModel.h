//
//  SearchModel.h
//  SWWY
//
//  Created by Yell on 15/7/4.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
@interface searchAllVideoDataModel : JSONModel
@property(nonatomic,copy) NSString<Optional> *id;
@property(nonatomic,copy) NSString<Optional> *video_id;
@property(nonatomic,copy) NSString<Optional> *title;
@property(nonatomic,copy) NSString<Optional> *videocover;
@property(nonatomic,copy) NSString<Optional> *upload_uid;
@property(nonatomic,copy) NSString<Optional> *click;
@property(nonatomic,copy) NSString<Optional> *up;
@property(nonatomic,copy) NSString<Optional> *lid;
@property(nonatomic,copy) NSString<Optional> *picurl;

@end

@interface searchAllcourseDataModel : JSONModel
@property(nonatomic,copy) NSString<Optional> *server_id;
@property(nonatomic,copy) NSString<Optional> *courseId;
@property(nonatomic,copy) NSString<Optional> *name;
@property(nonatomic,copy) NSString<Optional> *title;
@property(nonatomic,copy) NSString<Optional> *up;
@property(nonatomic,copy) NSString<Optional> *picurl;
@property(nonatomic,copy) NSString<Optional> *lid;
@property(nonatomic,copy) NSString<Optional> *viewers;
@property(nonatomic,copy) NSString<Optional> *click;
@end


@interface searchAllsopDataModel : JSONModel

@property(nonatomic,copy) NSString<Optional> *id;
@property(nonatomic,copy) NSString<Optional> *name;
@property(nonatomic,copy) NSString<Optional> *server_id;
@property(nonatomic,copy) NSString<Optional> *up;
@property(nonatomic,copy) NSString<Optional> *picUrl;
@property(nonatomic,copy) NSString<Optional> *click;
@property(nonatomic,copy) NSString<Optional> *lid;
@property(nonatomic,copy) NSString<Optional> *title;

@end

@interface searchAllDoctorDataModel : JSONModel



@property(nonatomic,copy) NSString<Optional> *uid;
@property(nonatomic,copy) NSString<Optional> *sid;
@property(nonatomic,copy) NSString<Optional> *realname;
@property(nonatomic,copy) NSString<Optional> *imgUrl;
@property(nonatomic,copy) NSString<Optional> *jobTitleName;
@property(nonatomic,copy) NSString<Optional> *isAuth;
@property(nonatomic,copy) NSString<Optional> *goodat;
@property(nonatomic,copy) NSString<Optional> *hospital;
@property(nonatomic,copy) NSString<Optional> *divisionName;
@property(nonatomic,copy) NSString<Optional> *isAuthByHos;
@property(nonatomic,copy) NSString<Optional> *isAuthByDiv;

@end

@interface searchAllOfficeDataModel : JSONModel

@property(nonatomic,copy) NSString<Optional> *uid;
@property(nonatomic,copy) NSString<Optional> *sid;
@property(nonatomic,copy) NSString<Optional> *realname;
@property(nonatomic,copy) NSString<Optional> *industry_id;
@property(nonatomic,copy) NSString<Optional> *imgUrl;
@property(nonatomic,copy) NSString<Optional> *divisionName;
@property(nonatomic,copy) NSString<Optional> *skill;
@property(nonatomic,copy) NSString<Optional> *introduction;
@property(nonatomic,copy) NSString<Optional> *hospital;
@property(nonatomic,copy) NSString<Optional> *isAuthByHos;
@property(nonatomic,copy) NSString<Optional> *hospUid;
@property(nonatomic,copy) NSString<Optional> *platformAuth;

@end

@interface searchAllHospitalDataModel : JSONModel

@property(nonatomic,copy) NSString<Optional> *uid;
@property(nonatomic,copy) NSString<Optional> *sid;
@property(nonatomic,copy) NSString<Optional> *realname;
@property(nonatomic,copy) NSString<Optional> *industry_id;
@property(nonatomic,copy) NSString<Optional> *imgUrl;
@property(nonatomic,copy) NSString<Optional> *levelStr;
@property(nonatomic,copy) NSString<Optional> *skill;

@end


@interface searchAllLabDataModel : JSONModel

@property(nonatomic,copy) NSString<Optional> *uid;
@property(nonatomic,copy) NSString<Optional> *sid;
@property(nonatomic,copy) NSString<Optional> *realname;
@property(nonatomic,copy) NSString<Optional> *industry_id;
@property(nonatomic,copy) NSString<Optional> *imgUrl;
@property(nonatomic,copy) NSString<Optional> *skill;

@end

@interface searchAllEnterpriseDataModel : JSONModel

@property(nonatomic,copy) NSString<Optional> *uid;
@property(nonatomic,copy) NSString<Optional> *sid;
@property(nonatomic,copy) NSString<Optional> *realname;
@property(nonatomic,copy) NSString<Optional> *industry_id;
@property(nonatomic,copy) NSString<Optional> *imgUrl;
@property(nonatomic,copy) NSString<Optional> *skill;

@end

@interface searchAllNewsDataModel : JSONModel

@property(nonatomic,copy) NSString<Optional> *uid;
@property(nonatomic,copy) NSString<Optional> *sid;
@property(nonatomic,copy) NSString<Optional> *username;
@property(nonatomic,copy) NSString<Optional> *title;
@property(nonatomic,copy) NSString<Optional> *subTitle;
@property(nonatomic,copy) NSString<Optional> *keyword;
@property(nonatomic,copy) NSString<Optional> *detail;
@property(nonatomic,copy) NSString<Optional> *titlePic;
@property(nonatomic,copy) NSString<Optional> *linkURL;


@end

@interface searchAllBaseDataListModel : JSONModel

@property(nonatomic,copy) NSString *total;
@property(nonatomic,strong) NSMutableArray *list;

@end

@interface searchAllModel :JSONModel

@property (nonatomic,strong) searchAllBaseDataListModel *videoData;
@property (nonatomic,strong) searchAllBaseDataListModel *courseData;
@property (nonatomic,strong) searchAllBaseDataListModel *sopData;
@property (nonatomic,strong) searchAllBaseDataListModel *doctorData;
@property (nonatomic,strong) searchAllBaseDataListModel *officeData;
@property (nonatomic,strong) searchAllBaseDataListModel *hosData;
@property (nonatomic,strong) searchAllBaseDataListModel *enterpriseData;
@property (nonatomic,strong) searchAllBaseDataListModel *labData;
@property (nonatomic,strong) searchAllBaseDataListModel *newsData;



@end

@interface HotHistoryListItemModel : JSONModel
@property (strong, nonatomic) NSMutableArray *list; //热搜列表
@end
@interface HotSearchListItemModel : JSONModel
@property (strong, nonatomic) NSMutableArray *list; //热搜列表
@end

@interface SearchModel : JSONModel

//获取热搜列表
+ (void)getHotSearchListSuccess:(void (^)(HotSearchListItemModel *model))success  failure:(void (^)(NSError *error))failure;
//获取历史列表
+ (void)getHistoryListSuccess:(void (^)(HotHistoryListItemModel *model))success  failure:(void (^)(NSError *error))failure;
//获取全文搜索列表
+(void)SearhAllListWithKeyWord:(NSString *)keyWord Success:(void(^)(NSMutableDictionary * ListDict))Success failure:(void(^)(NSError *error))failure;
//更多搜索视频
+(void)SearhVideoWithKeyWord:(NSString *)keyWord type:(int)type page:(NSString *)page priceType:(NSString *)prcieType Success:(void(^)(NSMutableArray * ListArr))Success failure:(void(^)(NSError *error))failure;
//更多搜索其他
+(void)SearhOtherWithKeyWord:(NSString *)keyWord type:(int)type page:(NSString *)page Success:(void(^)(NSMutableArray * ListArr))Success failure:(void(^)(NSError *error))failure;
@end
