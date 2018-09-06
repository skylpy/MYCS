//
//  CollectionModel.h
//  MYCS
//
//  Created by wzyswork on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "JSONModel.h"

@interface CollectionVideo : JSONModel
@property (nonatomic,strong) NSString<Optional>* id;
@property (nonatomic,strong) NSString<Optional>* videoId;
@property (nonatomic,strong) NSString<Optional>* describe;
@property (nonatomic,strong) NSString<Optional>* name;
@property (nonatomic,strong) NSString<Optional>* uploader;
@property (nonatomic,strong) NSString<Optional>* uploadTime;
@property (nonatomic,strong) NSString<Optional>* type;
@property (nonatomic,strong) NSString<Optional>* click;
@property (nonatomic,strong) NSString<Optional>* praiseNum;
@property (nonatomic,strong) NSString<Optional>* picurl;
@property (nonatomic,strong) NSString<Optional>* mp4url;
@property (nonatomic,strong) NSString<Optional>* duration;
@property (nonatomic,strong)NSNumber<Optional>* isSelect;
@property (nonatomic,strong) NSString<Optional>*coursePackUrl;
@end

@interface CollectionDoctor : JSONModel

@property (nonatomic,strong) NSString<Optional>* id;
@property (nonatomic,strong) NSString<Optional>* uid;
@property (nonatomic,strong) NSString<Optional>* name;
@property (nonatomic,strong) NSString<Optional>* goodat;
@property (nonatomic,strong) NSString<Optional>* jobTitle;
@property (nonatomic,strong) NSString<Optional>* imgUrl;
@property (nonatomic,strong)NSNumber<Optional>* isSelect;
@property(nonatomic,copy) NSString<Optional> *isAuth;

@end

@interface CollectionHospital : JSONModel
@property (nonatomic,strong) NSString<Optional>* id;
@property (nonatomic,strong) NSString<Optional>* imgUrl;
@property (nonatomic,strong) NSString<Optional>* realname;
@property (nonatomic,strong) NSString<Optional>* agroup_id;
@property (nonatomic,strong) NSString<Optional>* introduction;
@property (nonatomic,strong) NSString<Optional>* uid;
@property (nonatomic,strong)NSNumber<Optional>* isSelect;
@end

@interface CollectionModel : JSONModel

+(void)getCollectionHospitalDataWithUserID:(NSString *)
userId
                                   success:(void (^)(NSArray *list))success
                                   failure:(void (^)(NSError *error))failure;
+(void)getCollectionDoctorDataWithUserID:(NSString *)
userId
                                 success:(void (^)(NSArray *list))success
                                 failure:(void (^)(NSError *error))failure;
+(void)getCollectionVideoDataWithUserID:(NSString *)
userId
                                success:(void (^)(NSArray *list))success
                                failure:(void (^)(NSError *error))failure;

//type           (video || doctor || hospital)
+(void)DeleteCollectionDataWithIDS:(NSString *)Ids
                              Type:(NSString *)type
                                success:(void (^)(NSString *successStr))success
                               failure:(void (^)(NSError *error))failure;
//收藏 
//参数：
//authKey     参数加密验证码
//action        addCollect
//userId        登陆用户id
//type           收藏的类型 1.医生 4.机构  5.企业(科室，医院)
//id               收藏对应的id   //相应机构对应的uid
//device       机器码
//collect 1-收藏，0-取消收藏
+(void)AddCollectDoctorOrOfficeWithCollectId:(NSString *)collectId userId:(NSString *)userId collectType:(int)type Collect:(NSString *)collect success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure;

@end











