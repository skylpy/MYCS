//
//  VideoSpaceModel.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoSpaceModel : NSObject

@property (nonatomic,copy) NSString<Optional> *name;
@property (nonatomic,copy) NSString<Optional> *id;
@property (nonatomic,copy) NSString<Optional> *click;
@property (nonatomic,copy) NSString<Optional> *addTime;//教程上存时间
@property (nonatomic,copy) NSString<Optional> *introduction;
@property (nonatomic,copy) NSString<Optional> *praiseNum;
@property (nonatomic,copy) NSString<Optional> *image;//教程图片
@property (nonatomic,copy) NSString<Optional> *type;
@property (nonatomic,copy) NSString<Optional> *duration;
@property (nonatomic,copy) NSString<Optional> *uploader;
@property (nonatomic,copy) NSString<Optional> *cateName;
@property (nonatomic,copy) NSString<Optional> *uploadTime;//SOP和视频上存时间
@property (nonatomic,copy) NSString<Optional> *picUrl;//SOP图片
@property (nonatomic,copy) NSString<Optional> *up;
@property (nonatomic,copy) NSString<Optional> *picurl;//视频图片
@property (nonatomic,copy) NSString<Optional> *mp4url;//视频MP4

///  视频空间
+ (void)videoListWith:(NSString *)urlPath Id:(NSString *)idstr vipId:(NSString *)vipIdStr keyword:(NSString *)keyword action:(NSString *)action page:(NSInteger)page Success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end

///  选择分类模型
@interface ClassModel : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *text;
@property (nonatomic,copy) NSString *hasChild;
@property (nonatomic,copy) NSArray<ClassModel *> *children;

@property (nonatomic,assign,getter=isSelect) BOOL select;
//自定义套餐
+ (void)classListWithSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;
//列表分类
+ (void)classListCategoryWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure;

//直播科室
+ (void)classOfficeListWithSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;
@end


///  选择来源模型
@class SourceChildren;
@interface SourceModel : NSObject

@property (nonatomic, copy) NSString *deptId;

@property (nonatomic, assign) NSInteger listOrder;

@property (nonatomic, strong) NSArray<SourceChildren *> *children;

@property (nonatomic, copy) NSString *deptName;

@property (nonatomic, assign) NSInteger enterprise_uid;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *hasChild;

@property (nonatomic, assign) NSInteger parent_id;

@property (nonatomic, strong) NSArray *user_staff;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *state;

+ (void)sourceListWithSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end


@interface SourceChildren : NSObject

@property (nonatomic, copy) NSString *deptId;

@property (nonatomic, assign) NSInteger listOrder;

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *deptName;

@property (nonatomic, assign) NSInteger enterprise_uid;

@property (nonatomic, copy) NSString *text;

@property (nonatomic, assign) NSInteger parent_id;

@property (nonatomic, strong) NSArray *user_staff;

@end

