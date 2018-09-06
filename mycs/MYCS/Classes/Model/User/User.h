//
//  User.h
//  SWWY
//
//  Created by GuoChenghao on 15/1/8.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "SCBModel.h"
/**
 *  用户类型
 */
typedef NS_ENUM(int, UserType){
    /**
     *  个人用户
     */
    UserType_personal = 1,
    /**
     *  企业员工
     */
    UserType_employee = 3,
    /**
     *  培训机构
     */
    UserType_organization = 4,
    /**
     *  企业用户
     */
    UserType_company = 5
};

/**
 *  用户的类
 */
@interface User : JSONModel

/**
 *  用户ID
 */
@property (strong, nonatomic) NSString<Optional> *uid;

/**
 *  用户姓名
 */
@property (strong, nonatomic) NSString<Optional> *username;

/**
 *  用户类型 1-个人用户 5-企业用户 3-企业员工 4-培训机构
 */
@property (assign, nonatomic) UserType userType;

/**
 *  如果登录用户为者科室管理员，或企业
 "user_staff":{
 "     enterprise_id":91,
 "     dept_id":36,
 "     enterprise_name":"红牛公司培训考核管理平台"
 },
 */
@property (nonatomic,copy) NSDictionary<Optional> *user_staff;
/**
 *  userType是3 即当员工时，如果isAdmin=1->科室管理员
 */
@property (copy, nonatomic) NSString<Optional> *isAdmin;

@property (nonatomic,copy) NSString<Optional> *agroup_id;

/**
 *  组织名
 */
@property (copy, nonatomic) NSString<Optional> *realname;

/**
 *  联系Email
 */
@property (copy, nonatomic) NSString<Optional> *email;

/**
 *  用户头像地址
 */
@property (copy, nonatomic) NSString<Optional> *userPic;

/*!
 *  @author zhihua, 16-01-26 09:01:39
 *
 *  个人中心顶部图片
 */
@property (copy, nonatomic) NSString<Optional> *topPic;

/*!
 *  @author zhihua, 16-02-03 13:02:59
 *
 *  登录令牌
 */
@property (nonatomic,copy) NSString<Optional> *loginToken;

/*!
 *  @author zhihua, 16-01-26 09:01:05
 *
 *  焦点图
 */
@property (nonatomic,strong) NSArray<Optional> *focusPic;

/*!
 * @author linzq, 2016-05-31 15:29:35
 *
 * 平台环境，DEV--开发环境，TEST--测试环境，PRODUCT--生产环境，DEFAULT--未知环境
 * 极光推送可直接用于绑定用户的tag
 */
@property (nonatomic,strong) NSString<Optional> *envTag;


/**
 *  用户登录接口
 *
 *  @param userName 用户名
 *  @param password 登录密码
 *  @param success  成功执行块，返回用户信息
 *  @param failure  失败执行块
 */
+ (void)loginWithUserName:(NSString *)userName password:(NSString *)password success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure;


/**
 *  用户注册接口
 *
 *  @param userInformation <#userInformation description#>
 *  @param success         成功执行块，返回用户信息
 *  @param failure         失败执行块
 */
+ (void)registWithUserInformation:(NSDictionary *)userInformation success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure;

/**
 *  向手机发送短信验证码
 *
 *  @param phone   目标手机号
 *  @param action  发送原因
 *  @param success 成功执行块
 *  @param failure 失败执行块
 */
+ (void)sendMobileSmsWithPhone:(NSString *)phone action:(NSString *)action success:(void (^)(void))success failure:(void (^)(NSError *error))failure;


//上传身份证照片和相关资料
+ (void)uploadIdentityCardAndMaterial:(NSString *)imageDataStr success:(void (^)(NSString *tmpId))success failure:(void(^)(NSError *error))failure;


@end
