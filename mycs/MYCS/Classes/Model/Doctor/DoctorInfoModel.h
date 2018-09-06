//
//  DoctorInfoModel.h
//  SWWY
//
//  Created by zhihua on 15/6/27.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ExtraInfo : JSONModel

@property (nonatomic,copy) NSString *company;
@property (nonatomic,copy) NSString *contactPhone;
@property (nonatomic,copy) NSString *division;
@property (nonatomic,copy) NSString *divisionName;
@property (nonatomic,copy) NSString *endTime;
@property (nonatomic,copy) NSString *goodat;
@property (nonatomic,copy) NSString *hospital;
@property (nonatomic,copy) NSString *job;
@property (nonatomic,copy) NSString *jobName;
@property (nonatomic,copy) NSString *jobTitle;
@property (nonatomic,copy) NSString *personalType;
@property (nonatomic,copy) NSString<Optional> *position;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *startTime;
@property (nonatomic,copy) NSString *workPlace;

@end

@interface Education : JSONModel

//@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *start_time;//--开始时间
@property (nonatomic,copy) NSString *end_time;//--结束时间
@property (nonatomic,copy) NSString *school;//--学校名称
@property (nonatomic,copy) NSString *major;//--专业
@property (nonatomic,copy) NSString *degree;//--学位

@end

@interface Honour : JSONModel

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *sid;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *inputtime;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *imgUrl;//--荣耀封面图片路径

@end

@interface Treatise : JSONModel

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *sid;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *inputtime;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *imgUrl;//--专著封面图片路径

@end

@interface DoctorInfoModel : JSONModel

@property (nonatomic,copy) NSString *realname;//--昵称、名称
@property (nonatomic,copy) NSString *uid;
@property (nonatomic,copy) NSString *email;
@property (nonatomic,copy) NSString *imgUrl;
@property (nonatomic,copy) NSString *perQrCode;
@property (nonatomic,copy) NSString *gender;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *qq;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *avatar;
@property (nonatomic,copy) NSString *area_id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *logo;
@property (nonatomic,copy) NSString *introduction;//--个人简介
@property (nonatomic,copy) NSString *maxSizeCount;
@property (nonatomic,copy) NSString *buyVideoSize;
@property (nonatomic,copy) NSString *ico;
@property (nonatomic,copy) ExtraInfo *extraInfo;//extraInfo
@property (nonatomic,copy) NSString *birthday;
@property (nonatomic,copy) NSString *idcardNum;
@property (nonatomic,copy) NSString *question;
@property (nonatomic,copy) NSString <Optional>*agroup_id;
@property (nonatomic,copy) NSString *postcode;
@property (nonatomic,copy) NSString *home_id;
@property (nonatomic,copy) NSString *graduateSchool;
@property (nonatomic,copy) NSString *education;
@property (nonatomic,copy) NSString *company;
@property (nonatomic,copy) NSString *is_collect;
@property (nonatomic,copy) NSString *occupation;
@property (nonatomic,copy) NSString<Optional> *position;
@property (nonatomic,copy) NSString *revenue;
@property (nonatomic,copy) NSString *skill;//--擅长
@property (nonatomic,copy) NSString *work_time_start;
@property (nonatomic,copy) NSString *work_time_end;
@property (nonatomic,copy) NSString *click;
@property (nonatomic,copy) NSString *myurl;//个人名片
@property (nonatomic,copy) NSString *placeStr;//--所在城市
@property (nonatomic,copy) NSString *jobTitle;//--职称
@property (nonatomic,copy) NSString<Optional> *posTitle;//--行政职位
@property (nonatomic,copy) NSString *hospital;//--医院名称
@property (nonatomic,copy) NSString *divisionName;//--所属科室
@property (nonatomic,assign) BOOL isAuthByHos;//--是否医院认证通过，0--未通过，1--已通过
@property (nonatomic,assign) BOOL isAuthByDiv;//--是否科室认证通过，0--未通过，1--已通过
@property (nonatomic,copy) NSArray *eduList;
@property (nonatomic,copy) NSArray *honourList;
@property (nonatomic,copy) NSArray *treatiseList;

+ (void)doctorInfoWithDoctorUid:(NSString *)uid success:(void (^)(DoctorInfoModel *doctorInfo))success failure:(void (^)(NSError *))failure;

@end

