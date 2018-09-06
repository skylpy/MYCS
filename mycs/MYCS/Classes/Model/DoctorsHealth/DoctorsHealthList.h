//
//  DoctorsHealthList.h
//  MYCS
//
//  Created by GuiHua on 16/7/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface DoctorsHealthClass : JSONModel

@property (nonatomic,copy) NSString<Optional> *disease_category_id;
@property (nonatomic,copy) NSString<Optional> *category_name;
@property (nonatomic,copy) NSString<Optional> *add_time;
@property (nonatomic,copy) NSNumber<Optional> *isSelect;
@end

@interface DoctorsHealthBannar : JSONModel

@property (nonatomic,copy) NSString<Optional> *banner_id;
@property (nonatomic,copy) NSString<Optional> *category;
@property (nonatomic,copy) NSString<Optional> *img_url;
@property (nonatomic,copy) NSString<Optional> *address_url;
@property (nonatomic,copy) NSString<Optional> *is_show;
@property (nonatomic,copy) NSString<Optional> *orderId;
@property (nonatomic,copy) NSString<Optional> *add_time;

@end

@interface DoctorsHealthPhotos : JSONModel

@property (nonatomic,copy) NSString<Optional> *id;
@property (nonatomic,copy) NSString<Optional> *title;
@property (nonatomic,copy) NSString<Optional> *url;

@end

@interface DoctorsHealthDoctor : JSONModel

@property (nonatomic,copy) NSString<Optional> *uid;
@property (nonatomic,copy) NSString<Optional> *realname;
@property (nonatomic,copy) NSString<Optional> *hospital;
@property (nonatomic,copy) NSString<Optional> *sid;
@property (nonatomic,copy) NSString<Optional> *divisionName;
@property (nonatomic,copy) NSString<Optional> *jobTitle;
@property (nonatomic,copy) NSString<Optional> *imgUrl;
@property (nonatomic,copy) NSString<Optional> *doctorTitle;
@property (nonatomic,copy) NSString<Optional> *introduction;
@property (nonatomic,copy) NSString<Optional> *hospUid;
@property (nonatomic,copy) NSString<Optional> *agroup_id;

@end

@interface DoctorsHealthHosptial : JSONModel

@property (nonatomic,copy) NSString<Optional> *uid;
@property (nonatomic,copy) NSString<Optional> *realname;
@property (nonatomic,copy) NSString<Optional> *agroup_id;
@property (nonatomic,copy) NSString<Optional> *hospUid;
@property (nonatomic,copy) NSString<Optional> *sid;
@property (nonatomic,copy) NSString<Optional> *jobTitle;
@property (nonatomic,copy) NSString<Optional> *imgUrl;
@property (nonatomic,copy) NSString<Optional> *level;
@property (nonatomic,copy) NSString<Optional> *introduction;
@property (nonatomic,copy) NSString<Optional> *industry_id;
@property (nonatomic,copy) NSString<Optional> *skill;

@end

@interface DoctorsHealthRelate : JSONModel

@property (nonatomic,copy) NSString<Optional> *des_id;
@property (nonatomic,copy) NSString<Optional> *video_titile;
@property (nonatomic,copy) NSString<Optional> *video_img;

@end

@interface DoctorsHealthDetail : JSONModel

@property (nonatomic,copy) NSString<Optional> *des_id;
@property (nonatomic,copy) NSString<Optional> *video_img;
@property (nonatomic,copy) NSString<Optional> *video_url;
@property (nonatomic,copy) NSString<Optional> *video_titile;
@property (nonatomic,copy) NSString<Optional> *video_des;
@property (nonatomic,copy) NSString<Optional> *disease_category_id;
@property (nonatomic,copy) NSString<Optional> *disease_category;
@property (nonatomic,copy) NSNumber<Optional> *video_category;
@property (nonatomic,copy) NSString<Optional> *add_time;
@property (nonatomic,copy) NSNumber<Optional> *video_praise;
@property (nonatomic,copy) NSString<Optional> *video_long;
@property (nonatomic,copy) NSNumber<Optional> *video_click;
@property (nonatomic,copy) NSString<Optional> *add_uid;
@property (nonatomic,copy) NSString<Optional> *server_id;
@property (nonatomic,copy) NSNumber<Optional> *is_collect;
@property (nonatomic,copy) NSNumber<Optional> *is_praise;
@property (nonatomic,copy) NSNumber<Optional> *status;
@property (nonatomic,copy) NSString <Optional> *shareUrl;
@property (nonatomic ,strong) NSArray  * doctorData;
@property (nonatomic ,strong) NSArray  * hospitalData;
@property (nonatomic ,strong) NSArray  *videoRecommend;
@property (nonatomic ,strong) NSArray  *videoPhotos;

@end

@interface DoctorsHealthList : JSONModel

@property (nonatomic,copy) NSString<Optional> *des_id;
@property (nonatomic,copy) NSString<Optional> *video_img;
@property (nonatomic,copy) NSString<Optional> *video_url;
@property (nonatomic,copy) NSString<Optional> *video_titile;
@property (nonatomic,copy) NSString<Optional> *video_des;
@property (nonatomic,copy) NSString<Optional> *video_doctor_dep;
@property (nonatomic,copy) NSNumber<Optional> *is_praise;
@property (nonatomic,copy) NSString<Optional> *disease_category_id;
@property (nonatomic,copy) NSString<Optional> *disease_category;
@property (nonatomic,copy) NSString<Optional> *video_category;
@property (nonatomic,copy) NSString<Optional> *video_recommend;
@property (nonatomic,copy) NSString<Optional> *video_photo_titile;
@property (nonatomic,copy) NSString<Optional> *add_time;
@property (nonatomic,copy) NSString<Optional> *video_praise;
@property (nonatomic,copy) NSString<Optional> *video_long;
@property (nonatomic,copy) NSString<Optional> *video_click;
@property (nonatomic,copy) NSString<Optional> *add_uid;
@property (nonatomic,copy) NSString<Optional> *server_id;
@property (nonatomic,copy) NSString<Optional> *status;

/**
 *  @author GuiHua, 16-07-14 16:07:45
 *
 *  专访视频列表
 *  @param category 专访视频的类型 (1=>"疾病",2=>'专题',3=>'微电影',4=>'院宣视频')
 *  @param itemType  1为最新，2为热门
 *  @param diseaseCategoryId 疾病分类id
 *  @param page   当前分页，可选，默认为第一页
 *  @param success 返回数组列表
 *  @param failure <#failure description#>
 */
+(void)getListsWithCategory:(NSString *)category itemType:(NSString *)itemType diseaseCategoryId:(NSString *)diseaseCategoryId page:(int)page Success:(void (^)(NSArray *lists))success failure:(void (^)(NSError *error))failure;

/**
 *  @author GuiHua, 16-07-14 16:07:18
 *
 *  专访视频列表顶部的轮播图片
 *  @param category 专访视频的类型 (1=>"疾病",2=>'专题',3=>'微电影',4=>'院宣视频')
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)getBannarWithCategory:(NSString *)category Success:(void (^)(NSArray *lists))success failure:(void (^)(NSError *error))failure;


/**
 *  @author GuiHua, 16-07-14 16:07:32
 *
 *  疾病分类列表
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)getDoctorsHealthClassWithSuccess:(void (^)(NSArray *lists))success failure:(void (^)(NSError *error))failure;
/**
 *  @author GuiHua, 16-07-14 16:07:50
 *
 *  专访视频详情
 *  @param idstr 专访视频ID
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)getDoctorsHealthDetailWithId:(NSString *)idstr Success:(void (^)(DoctorsHealthDetail *model))success failure:(void (^)(NSError *error))failure;

@end
