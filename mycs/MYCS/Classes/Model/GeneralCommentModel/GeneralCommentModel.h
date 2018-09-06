//
//  GeneralCommentModel.h
//  MYCS
//
//  Created by GuiHua on 16/7/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@protocol GeneralCommentModel <NSObject>
@end

@interface GeneralCommentModel : JSONModel

@property (copy,nonatomic) NSString <Optional>*id;
@property (copy,nonatomic) NSString <Optional>*parent_id;
@property (copy,nonatomic) NSString <Optional>*text;
@property (copy,nonatomic) NSString <Optional>*time;
@property (copy,nonatomic) NSString <Optional>*uid;
@property (copy,nonatomic) NSString <Optional>*replyUid;
@property (copy,nonatomic) NSString <Optional>*reply_id;
@property (copy,nonatomic) NSString <Optional>*praiseNum;
@property (copy,nonatomic) NSString <Optional>*isPraised;
@property (copy,nonatomic) NSString <Optional>*name;
@property (copy,nonatomic) NSString <Optional>*pic;
@property (copy,nonatomic) NSString <Optional>*replyName;
@property (strong,nonatomic) NSArray<Optional> *son;
@property (strong,nonatomic) NSArray<Optional> *sons;

@property (nonatomic,copy) NSString<Optional> *expand;

/**
 *  @author GuiHua, 16-07-15 14:07:47
 *
 *  评论列表
 *  @param userId 用户id
 *  @param userType 用户类型
 *  @param action send
 *  @param pageSize
 *  @param page
 *  @param targetType 评论目标类型，0--名医学术交流，1--视频评论，2--教程评论，3--sop评论 6-- 课程评论 7-- 视频专访评论
 *  @param targetId 评论目标id，如视频则为具体那篇视频id
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+ (void)commentWithUserId:(NSString *)userId
                 userType:(NSString *)userType
                   action:(NSString *)action
                 pageSize:(int)pageSize
                     page:(int)page
              targetType :(int)targetType
               targetId:(NSString*)targetId
                  success:(void (^)(NSArray *list,NSString *count))success
                  failure:(void (^)(NSError *error))failure;
/**
 *  @author GuiHua, 16-07-15 14:07:36
 *
 *  发表评论
 *  @param userId 用户id
 *  @param userType 用户类型
 *  @param action send
 *  @param targetType targetType 评论目标类型，0--名医学术交流，1--视频评论，2--教程评论，3--sop评论 6-- 课程评论 7-- 视频专访评论
 *  @param targetId 评论目标id，如视频则为具体那篇视频id
 *  @param content 评论内容
 *  @param replyId 上一篇的目标id
 *  @param toUid 被评论人ID
 *  @param toEid 被评论的父评论ID
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+ (void)addCmtWithUserId:(NSString*)userId
                userType:(NSString*)userType
                  action:(NSString*)action
                targetType:(NSString*)targetType
                 targetId:(NSString*)targetId
                 content:(NSString*)content
                 replyId:(NSString*)replyId
                   toUid:(NSString*)toUid
                   toEid:(NSString*)toEid
                 success:(void (^)(SCBModel *model))success
                 failure:(void (^)(NSError *error))failure;
/**
 *  @author GuiHua, 16-07-15 15:07:17
 *
 *  点赞 or 收藏
 *  @param userId 用户id
 *  @param userType 用户类型
 *  @param action praise or collect
 *  @param targetType 评论目标类型，0--名医学术交流，1--视频评论，2--教程评论，3--sop评论 6-- 课程评论 7-- 视频专访评论
 *  @param targetId  点赞目标id，如视频则为具体那篇视频id
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+ (void)praiseOrCollectWithUserId:(NSString*)userId
                      userType:(NSString*)userType
                        action:(NSString*)action
                    targetType:(NSString*)targetType
                      targetId:(NSString*)targetId
                         success:(void (^)(SCBModel *model))success
                         failure:(void (^)(NSError *error))failure;
@end


















