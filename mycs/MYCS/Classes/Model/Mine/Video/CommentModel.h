//
//  CommentModel.h
//  SWWY
//
//  Created by 黄希望 on 15-1-25.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "SCBModel.h"


@protocol commentReplyListModel <NSObject>
@end

@interface commentReplyListModel : JSONModel

@property (copy,nonatomic) NSString *id;
@property (copy,nonatomic) NSString *lid;
@property (copy,nonatomic) NSString *from_uid;//被回复用户id
@property (copy,nonatomic) NSString *reply_uid;//回复用户id
@property (copy,nonatomic) NSString *parent_id;
@property (copy,nonatomic) NSString *addTime;
@property (copy,nonatomic) NSString *content;//回复内容
@property (copy,nonatomic) NSString *from_uname;//被回复用户名字
@property (copy,nonatomic) NSString *reply_uname;//回复用户名字

@end


@interface commentListModel : JSONModel

@property (copy,nonatomic) NSString *addTime;       //评论时间
@property (copy,nonatomic) NSString *content;       //评论内容
@property (copy,nonatomic) NSString *from_uid;       //评论人id
@property (copy,nonatomic) NSString *from_uname;       //评论人名字
@property (copy,nonatomic) NSString *from_upicurl;  //评论人头像
@property (copy,nonatomic) NSString *lid;       //评论id
@property (copy,nonatomic) NSString *parent_id;
@property (copy,nonatomic) NSString *praiseNum;
@property (copy,nonatomic) NSString *isPraise;       //评论人id
@property (strong,nonatomic) NSArray<commentReplyListModel> *replyList;       //回复

@property (nonatomic,copy) NSString<Optional> *expand;

//--用户标签，0-无 1-人物 2-医生 3-名医 4-专家
@property (nonatomic,assign) int from_personTag;

@end
@protocol CommentModel @end

@interface CommentSendModel : JSONModel

@property (strong,nonatomic) NSString *id;       //评论id
@property (strong,nonatomic) NSString *text;            //评论内容
@property (assign,nonatomic) NSTimeInterval createTime;      //评论时间
@property (strong,nonatomic) NSString *pic;             //评论者图像
@property (strong,nonatomic) NSString *uid;             //评论者uid
@property (strong,nonatomic) NSString *name;            //评论者昵称

@end


@interface CommentModel : JSONModel
@property (strong,nonatomic) NSString *commentId;       //评论id
@property (strong,nonatomic) NSString *text;            //评论内容
@property (assign,nonatomic) NSTimeInterval createTime;      //评论时间
@property (strong,nonatomic) NSString *pic;             //评论者图像
@property (strong,nonatomic) NSString *uid;             //评论者uid
@property (assign,nonatomic) int peak;                  //当前评论北电赞次数
@property (assign,nonatomic) int trample;               //当前点赞的回复总数
@property (strong,nonatomic) NSString *name;            //评论者昵称
@property (strong,nonatomic) NSString *time;            //"2015-02-06 17:40:37"
/**
 *  评论列表接口
 *
 *  @param userId      登陆用户id
 *  @param userType    登录用户的类型
 *  @param action      参数值固定：appList
 *  @param pageSize    每页个数
 *  @param page        页码
 *  @param commentType 评论类型
 *  @param commentCId  评论cid
 *  @param success     成功执行块
 *  @param failure     失败执行块
 */
+ (void)commentWithUserId:(NSString *)userId
                 userType:(NSString *)userType
                   action:(NSString *)action
                 pageSize:(int)pageSize
                     page:(int)page
              commentType:(int)commentType
               commentCId:(NSString*)commentCId
                  success:(void (^)(NSArray *list))success
                  failure:(void (^)(NSError *error))failure;


/*
 ====发表评论====
 userId        登陆用户id
 userType      登录用户的类型
 authKey       参数加密验证码
 action        参数值固定：appSend
 comment_type  评论类型
 comment_cid   评论cid
 content       评论内容
 replyId       默认不传或传0，当回复某条评论时，将评论的ID赋给此参数
 */


+ (void)addCmtWithUserId:(NSString*)userId
                userType:(NSString*)userType
                  action:(NSString*)action
                cmt_type:(NSString*)cmt_type
                 cmt_cid:(NSString*)cmt_cid
                 content:(NSString*)content
                 replyId:(NSString*)replyId
                 success:(void (^)(CommentModel *model))success
                 failure:(void (^)(NSError *error))failure;


//新接口
+ (void)addCmtWithcmt_type:(NSString*)cmt_type
                   cmt_cid:(NSString*)cmt_cid
                   content:(NSString*)content
                     toEid:(NSString*)toEid
                     toUid:(NSString*)toUid
                   success:(void (^)(SCBModel *model))success
                   failure:(void (^)(NSError *error))failure;

+ (void)getCommentWithcmt_type:(NSString*)cmt_type
                       cmt_cid:(NSString*)cmt_cid
                          page:(NSString*)page
                       replyId:(NSString *)replyId
                       success:(void (^)(NSArray *listArr))success
                       failure:(void (^)(NSError *error))failure;

//视频点赞接口
+ (void)praiseChangeWithcmt_type:(NSString*)cmt_type
                         cmt_cid:(NSString*)cmt_cid
                         success:(void (^)(SCBModel *model))success
                         failure:(void (^)(NSError *error))failure;
@end
