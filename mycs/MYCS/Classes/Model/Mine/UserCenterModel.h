//
//  UserCenterModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/1/22.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@class SCBModel;

@class Focus,Adpicture,UserBindModel;

@protocol UserBindModel

@end

@interface UserCenterModel : JSONModel

@property (strong, nonatomic) NSString<Optional> *industry; //行业
@property (strong, nonatomic) NSNumber<Optional> *enterType; //企业用户类型，5：企业，183：医院，185：科室，187：实验室 是PlatformType类型
@property (strong, nonatomic) NSNumber<Optional> *sid; //是否上传头像，1表示已上传，0表示未上传
@property (strong, nonatomic) NSString<Optional> *avatar; //头像，未上传的会用输出默认的头像
@property (strong, nonatomic) NSString<Optional> *topPic;//背景
@property (strong, nonatomic) NSString<Optional> *realname; //企业名称
@property (strong, nonatomic) NSString<Optional> *domain; //网址
@property (strong, nonatomic) NSString<Optional> *domainTitle; //网址 只有个有有这属性
@property (strong, nonatomic) NSString<Optional> *contact; //联系人
@property (strong, nonatomic) NSString<Optional> *mobile; //手机
@property (strong, nonatomic) NSString<Optional> *introduction; //简介
@property (strong, nonatomic) NSString<Optional> *email; //邮箱
@property (nonatomic,copy) NSString<Optional> *position;
@property (nonatomic,copy) NSArray<UserBindModel,Optional> * bind;

@property (nonatomic,copy) NSString<Optional> *placeStr;//--所在城市
@property (nonatomic,copy) NSString<Optional> *posTitle;//--职位名称
@property (nonatomic,copy) NSString<Optional> *agroup_id;//--用户角色id  名医角色--193  医院角色--183  科室角色--185
@property (nonatomic,copy) NSString<Optional> *jobTitleStr;//    --职称

@property (nonatomic,copy) NSString<Optional> *company;//    --所属公司

//  =====名医账号专有======
@property (copy,nonatomic) NSString<Optional> *name;//真实姓名
@property (copy,nonatomic) NSString<Optional> *skill;//擅长
@property (copy,nonatomic) NSString<Optional> *work_time_start;//工作开始时间
@property (copy,nonatomic) NSString<Optional> *work_time_end;//工作结束时间
@property (copy,nonatomic) NSString<Optional> *hosAuth;//  --是否通过医院验证 0--未通过 1--已通过
@property (copy,nonatomic) NSString<Optional> *divAuth;//--是否通过科室验证 0--未通过 1--已通过

//  =====名医、科室账号共有======
@property (copy,nonatomic) NSString<Optional> *hospital;// --医院名称
@property (copy,nonatomic) NSString<Optional> *divisionName;//    --科室名称


/**
 *  获取用户中心信息
 *
 *  @param userID   用户ID
 *  @param userType 用户类型
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)requestUserCenterInformationWithUserID:(NSString *)userID userType:(NSString *)userType success:(void (^)(UserCenterModel *centerModel))success failure:(void (^)(NSError *error))failure;

/**
 *  修改简介
 *
 *  @param userID       登录用户id
 *  @param userType     登录用户的类型
 *  @param introduction 新简介
 *  @param success      成功的返回
 *  @param failure      失败返回
 */
+ (void)changeIntroWithUserID:(NSString *)userID userType:(NSString *)userType introduction:(NSString *)introduction success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/**
 *  用户中心发送手机验证码
 *
 *  @param phone    手机号码
 *  @param success  成功的返回
 *  @param failure  失败返回
 */
+ (void)sendCodeInUserCenterWithPhone:(NSString *)phone validCode:(NSString *)validCode action:(NSString *)action success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/**
 *  发送手机验证码 *
 
 *  @param captchaCode   图片验证码
 *  @param phone 手机
 *  @param success  成功的返回
 *  @param failure  失败返回
 */
+(void)sendPhoneCaptchaCode:(NSString *)captchaCode Phone:(NSString *)phone andAction:(NSString *)action uccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;


/**
 *  绑定 or 修改绑定手机
 *
 action              updateMobile
 authKey           参数加密验证码
 mobile             手机号码
 code                 手机验证码
 userId               用户ID
 userType          用户类型
 device              机器码
 */
+(void)changeBindPhoneWithMobile:(NSString *)mobile Code:(NSString *)code userId:(NSString *)userId userType:(NSString *)userType uccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;


/**
 *  发送邮箱验证码
 *
 *  @param email   邮箱地址
 *  @param success 成功的返回
 *  @param failure 失败返回
 */
+ (void)sendCodeWithEmail:(NSString *)email andType:(NSString *)type success:(void (^)(void))success failure:(void (^)(NSError *error))failure;


/**
 *  绑定,修改绑定邮箱
 *
 action              updateEmail
 authKey           参数加密验证码
 email                手机号码
 code                 手机验证码
 userId               用户ID
 userType          用户类型
 device              机器码
 */
+(void)changeBindEmailWithEmail:(NSString *)email Code:(NSString *)code userId:(NSString *)userId userType:(NSString *)userType uccess:(void (^)(void))success failure:(void (^)(NSError *error))failure;


/**
 *  修改负责人
 *
 *  @param userID     登录用户id
 *  @param userType   登录用户的类型
 *  @param contacts   联系人姓名
 *  @param jobTitle   职称ID
 *  @param position   行政职位ID
 *  @param industryID 所属科室ID
 *  @param success    成功返回
 *  @param failure    失败返回
 */
+ (void)changeManagerWithUserID:(NSString *)userID userType:(NSString *)userType contacts:(NSString *)contacts jobTitle:(NSString *)jobTitle position:(NSString *)position industryID:(NSString *)industryID success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/**
 *  修改密码
 *
 *  @param userID      登录用户id
 *  @param userType    登录用户的类型
 *  @param oldPassword 旧密码
 *  @param passowrdNew 新密码
 *  @param success     成功返回
 *  @param failure     失败返回
 */
+ (void)changePasswordWithUserID:(NSString *)userID userType:(NSString *)userType oldPassword:(NSString *)oldPassword newPassword:(NSString *)passowrdNew success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/**
 *  忘记密码
 *
 *  @param phone       手机号码
 *  @param code        手机验证码
 *  @param passowrdNew 新密码
 *  @param success     成功返回
 *  @param failure     失败返回
 */
+ (void)forgetPasswordWithPhone:(NSString *)phone code:(NSString *)code newPassword:(NSString *)passowrdNew success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/**
 *  提交建议
 *
 *  @param userID  登陆用户id
 *  @param title   标题
 *  @param content 正文
 *  @param success 成功返回
 *  @param failure 失败返回
 */
+ (void)giveSuggestWithUserID:(NSString *)userID phoneNumber:(NSString *)phoneNumber suggestContent:(NSString *)content success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
/**
 *  修改公司职位
 *
 *  @param userId   userID
 *  @param userType userType
 *  @param position 公司职位
 *  @param success  成功的回调
 *  @param failure  失败的回调
 */
+ (void)editPositionWith:(NSString *)userId userType:(NSString *)userType positionName:(NSString *)position success:(void(^)(SCBModel *model))success filure:(void(^)(NSError *error))failure;

//修改所在城市
+(void)changePlaceWithUserID:(NSString *)userID userType:(NSString *)userType areaId:(NSString *)areaId success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
//修改头像
+ (void)uploadPhotoDataWithuploadPhotoData:(NSString *)imageData success:(void (^)(NSString * str))success failure:(void (^)(NSError *error))failure;
//修改背景
+ (void)uploadTopPhotoDataWithuploadPhotoData:(NSString *)imageData success:(void (^)(NSString * str))success failure:(void (^)(NSError *error))failure;
//修改工作时长
+ (void)updateWorkTimeWithUserID:(NSString *)userID userType:(NSString *)userType startTime:(NSString *)startTime endTime:(NSString *)endTime success:(void (^)(void))success failure:(void (^)(NSError *error))failure;
//修改擅长
+ (void)updateSkillWithUserID:(NSString *)userID userType:(NSString *)userType skill:(NSString *)skill success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

@end

@interface UserBindModel : JSONModel

@property (nonatomic,assign) BOOL isBindThird;
@property (nonatomic,copy) NSString<Optional> *bindType;
@property (nonatomic,copy) NSString<Optional> *thusername;

@end

@interface Param : JSONModel

@property (nonatomic, copy) NSString <Optional>*type;

@property (nonatomic, copy) NSString <Optional>*id;

@property (nonatomic, copy) NSString <Optional>*agroup_id;

@property (nonatomic, copy) NSString <Optional>*url;

//文章地址解析
+ (void)InformationClickWithCheckUrl:(NSString *)url
                             success:(void (^)(Param *pama))success
                             failure:(void (^)(NSError *error))failure;

@end

@protocol Focus <NSObject>

@end

@interface Focus : JSONModel

@property (nonatomic, copy) NSString <Optional>*linkURL;

@property (nonatomic, copy) NSString <Optional>*title;

@property (nonatomic, copy) NSString <Optional>*imageSrc;

@property (nonatomic, copy) Param *param;

@end

@interface Adpicture : JSONModel

@property (nonatomic, copy) NSString <Optional>*linkURL;

@property (nonatomic, copy) NSString <Optional>*title;

@property (nonatomic, copy) NSString <Optional>*imageSrc;

@property (nonatomic, copy) Param *param;

@end



@interface ProfileFocus : JSONModel

@property (nonatomic, strong) NSArray<Focus *> *focus;

@property (nonatomic, strong) NSArray<Adpicture *> *adPicture;

//我的-》广告列表
+ (void)profileFocusListWithSuccess:(void (^)(NSArray *focusList))success failure:(void (^)(NSError *error))failure;

+ (void)loadAdPic;

@end


