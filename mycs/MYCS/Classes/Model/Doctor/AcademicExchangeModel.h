//
//  AcademicExchangeModel.h
//  SWWY
//
//  Created by zhihua on 15/6/30.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reply : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *lid;
@property (nonatomic,copy) NSString *from_uid;
@property (nonatomic,copy) NSString *reply_uid;
@property (nonatomic,copy) NSString *parent_id;
@property (nonatomic,copy) NSString *addTime;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *from_uname;
@property (nonatomic,copy) NSString *reply_uname;

@end

@interface AcademicExchangeModel : NSObject

@property (nonatomic,copy) NSString *id;
@property (nonatomic,copy) NSString *lid;
@property (nonatomic,copy) NSString *from_uid;
@property (nonatomic,copy) NSString *reply_uid;
@property (nonatomic,copy) NSString *parent_id;
@property (nonatomic,copy) NSString *addTime;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSArray *replyList;
@property (nonatomic,copy) NSString *from_uname;
@property (nonatomic,copy) NSString *from_upicurl;
@property (nonatomic,copy) NSString *praiseNum;
@property (nonatomic,assign) BOOL isPraise;
@property (nonatomic,assign) NSString<Optional>* showAllApply;

//-----------------------华丽的分割线----------------------------
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *viewNum;
@property (nonatomic,copy) NSString *videlUrl;
@property (nonatomic,copy) NSString <Optional>*videlUrlHd;
@property (nonatomic,copy) NSString *videoCover;
@property (nonatomic,copy) NSArray *picList;

//arget_type    评论目标类型，0--名医学术交流,4--案例资源回复，1--视频评论，2--教程评论，3--sop评论（灰色暂不启用）
+ (void)AcademicExchangeListWithTargetId:(NSString *)targetID
                                  userID:(NSString *)userID
                                    page:(int)page
                                pageSize:(int)pageSize
                              targetType:(int)targetType
                                 success:(void (^)(NSArray *list))success
                                 failure:(void (^)(NSError *error))failure;

//authKey       参数加密验证码
//action        参数值固定：add
//userId        当前登录用户id
//content        发表内容
//toEid    所属的交流话题id，默认值0则为发起交流话题，非0为话题讨论（所有回复需要传此参数）
//toUid    被回复者uid，默认值0则为回复话题,非0则为话题内回复某个用户(回复单个评论需传此参数，否则为对话题评论)
//target_type    评论目标类型，0--名医学术交流,4--案例资源回复，1--视频评论，2--教程评论，3--sop评论（灰色暂不启用）
//target_id    评论目标id,名医学术交流则为当前名医首页用户uid
+ (void)commentWithUserID:(NSString *)userid
                 conetent:(NSString *)content
                    toEid:(NSString *)edi
                    toUid:(NSString *)toUid
                reply_id:(NSString *)reply_id
               targetType:(int)targetType
                 targetID:(NSString *)targetID
                  success:(void (^)(void))success
                  failure:(void (^)(NSError *error))failure;

@end
