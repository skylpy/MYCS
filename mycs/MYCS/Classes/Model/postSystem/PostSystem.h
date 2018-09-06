//
//  PostSystem.h
//  MYCS
//
//  Created by wzyswork on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "JSONModel.h"


@interface PostSystemVideo : JSONModel

@property (nonatomic,strong) NSString<Optional> *sopId;
@property (nonatomic,strong) NSString<Optional> *courseId;
@property (nonatomic,strong) NSString<Optional> * id;
@property (nonatomic,strong) NSString<Optional> *click;
@property (nonatomic,strong) NSString<Optional> *addTime;
@property (nonatomic,strong) NSString<Optional> *name;
@property (nonatomic,strong) NSString<Optional> *introduction;
@property (nonatomic,strong) NSString<Optional> *praiseNum;
@property (nonatomic,strong) NSString<Optional> *picUrl;
@property (nonatomic,strong) NSString<Optional> *duration;
@property (nonatomic,strong) NSString<Optional> *uploader;
@property (nonatomic,strong) NSString<Optional> *type;
@property (nonatomic,strong) NSNumber<Optional> * isSelect;
@end

@interface PostSystem : JSONModel
@property (nonatomic,strong) NSString<Optional> * deptId;
@property (nonatomic,strong) NSString<Optional> *deptName;
@property (nonatomic,strong) NSString<Optional> *parentName;
@property (nonatomic,strong) NSString<Optional> *courseCount;//教程总数
@property (nonatomic,strong) NSString<Optional> *sopCount;//视频总数

//
//authKey     参数加密验证码
//action        getDeptCount
//userId        登陆用户id
//device       机器码
//岗位体系首页
+(void)getPostSystemDataWithUserID:(NSString *)userId
                            DeptID:(NSString *)deptId
                              page:(int)page
                          pageSize:(int)pageSize
                        success:(void (^)(NSArray *list))success
                        failure:(void (^)(NSError *error))failure;
//authKey     参数加密验证码
//action        getAllList
//userId        登陆用户id
//deptId       来源部门
//device       机器码
//岗位体系详情
+(void)getPostSystemVideoDataWithUserID:(NSString *)
                                           userId
                                 DeptId:(NSString *)deptId
                                   page:(int)page
                               pageSize:(int)pageSize
                           success:(void (^)(NSArray *List))success
                           failure:(void (^)(NSError *error))failure;
//authKey     参数加密验证码
//action        delDepRecord
//ids           可以传单个id，也可以传以","连接的id字符串
//device        机器码
+(void)DeletePostSystemDataWithIDS:(NSString *)Ids success:(void (^)(NSString *))success failure:(void (^)(NSError *))failure;
@end















