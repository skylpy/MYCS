//
//  MessageModel.h
//  SWWY
//
//  Created by GuoChenghao on 15/1/18.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
@interface MailBoxTaskListModel : JSONModel
@property (copy, nonatomic) NSString<Optional> *mid;
@property (copy, nonatomic) NSString<Optional> *msg_id;
@property (copy, nonatomic) NSString<Optional> *type;
@property (copy, nonatomic) NSString<Optional> *to_uid;
@property (copy, nonatomic) NSString<Optional> *addTime;
@property (copy, nonatomic) NSString<Optional> *title;
@property (copy, nonatomic) NSString<Optional> *content;
@property (copy, nonatomic) NSString<Optional> *from_username;
@property (copy, nonatomic) NSString<Optional> *taskId;
@property (copy, nonatomic) NSString<Optional> *taskName;
@property (copy, nonatomic) NSString<Optional> *course_id;
@property (copy, nonatomic) NSString<Optional> *note;
@property (copy, nonatomic) NSString<Optional> *add_uid;
@property (copy, nonatomic) NSString<Optional> *add_uname;
@property (copy, nonatomic) NSString<Optional> *issueTime;
@property (copy, nonatomic) NSString<Optional> *endTime;



@end
//=======================收件箱任务类======================//
@interface boxDetailTaskModel : JSONModel
@property (copy, nonatomic) NSString<Optional> *task_id;
@property (copy, nonatomic) NSString<Optional> *task_cid;
@property (copy, nonatomic) NSString<Optional> *task_cls;
@property (copy, nonatomic) NSString<Optional> *endTime;
@property (copy, nonatomic) NSString<Optional> *task_title;
@property (copy, nonatomic) NSString<Optional> *progress;
@property (copy, nonatomic) NSString<Optional> *isEnd;
@property (copy, nonatomic) NSString<Optional> *passed;
@property (copy, nonatomic) NSString<Optional> *userRate;
@property (copy, nonatomic) NSString<Optional> *rank;

@end

//=======================收件箱列表类======================//

@interface InboxListItemModel : JSONModel
@property (strong, nonatomic) NSString *modelID;
@property (assign, nonatomic) BOOL isRead;
@property (strong, nonatomic) NSNumber *addTime;
@property (strong, nonatomic) NSString *from_uid;
@property (strong, nonatomic) NSString *from_username;
@property (strong, nonatomic) NSString *title;
@property (copy,nonatomic) NSString *content;

@end

//=======================发件箱列表类======================//
@interface OutboxListItemModel : JSONModel
@property (strong, nonatomic) NSString *toUser;
@property (strong, nonatomic) NSString *msgId;
@property (strong, nonatomic) NSNumber *addTime;
@property (assign, nonatomic) BOOL recommend;
@property (strong, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@end

//=======================发件人详情类======================//
@interface SenderDetailModel : JSONModel
@property (strong, nonatomic) NSString *uname;
@property (strong, nonatomic) NSString *utype;
@end

//=======================回复对象类======================//
@protocol PostListItemModel
@end
@interface PostListItemModel : JSONModel
@property (strong, nonatomic) NSString *postId; //回复消息id，用于其他操作
@property (strong, nonatomic) NSString *content; //回复内容
@property (strong, nonatomic) NSString *postTime; //回复时间
@end

//=======================附件类======================//
@protocol AttachmentModel
@end
@interface AttachmentModel : JSONModel
@property (strong, nonatomic) NSString *attachName; //附件文件名称，带后缀
@property (strong, nonatomic) NSString *addTime; //附件上传时间
@property (strong, nonatomic) NSString *recid; //附件id
@property (strong, nonatomic) NSString *attachType; //附件后缀
@property (strong, nonatomic) NSString *attachSize; //附件大小，单位字节
@property (strong, nonatomic) NSString *fileDir; //附件路径
@end

//=======================收件箱详情类======================//
@interface InboxDetailModel : JSONModel
@property (strong, nonatomic) NSString *addTime; //发布时间，时间戳
@property (strong, nonatomic) NSArray<AttachmentModel> *attachments; //附件列表数组
@property (strong, nonatomic) NSString *content; //消息文本
@property (strong, nonatomic) NSString *course_id; //任务类消息的关联课程id
@property (strong, nonatomic) NSString *from_uid; //发送者id
@property (strong, nonatomic) NSString *from_uname; //发件人名称
@property (strong, nonatomic) NSString *modelID; //消息id，通过此id查询消息详细信息
@property (strong, nonatomic) NSArray<PostListItemModel> *postList; //消息回复列表数组
@property (strong, nonatomic) NSString *sender_detail;
@property (strong, nonatomic) NSString *taskName; //任务名称
@property (strong, nonatomic) NSString *task_id; //任务类消息的关联任务id
@property (strong, nonatomic) NSString *title; //消息标题
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *hasTask;
@property (strong, nonatomic) boxDetailTaskModel<Optional> *taskData;

@end

//=======================发件箱详情类======================//
@interface OutboxDetailModel : JSONModel
@property (strong, nonatomic) NSString *msgId;
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *content;
@property (strong, nonatomic) NSString *addTime;
@property (strong, nonatomic) NSString *receiver;
@property (strong, nonatomic) NSString *toUid;
@property (strong, nonatomic) boxDetailTaskModel<Optional> *taskData;


@end

//=======================未读消息数类======================//
@interface UnreadNumModel : JSONModel
@property (strong, nonatomic) NSNumber *general;
@property (strong, nonatomic) NSNumber *suggestions;
@property (strong, nonatomic) NSNumber *system;
@property (strong, nonatomic) NSNumber *house;
@property (strong, nonatomic) NSNumber *audition;
@property (strong, nonatomic) NSNumber *post;
@property (strong, nonatomic) NSNumber *reply;
@end


@interface MessageModel : JSONModel

/**
 *  获取收件箱列表
 *
 *  @param userID   用户ID
 *  @param userType 用户类型
 *  @param pageNo   分页页数
 *  @param pageSize 分页大小
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)requestInboxListWithUserID:(NSString *)userID userType:(NSString *)userType pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize keyword:(NSString *)keyword Success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

/**
 *  获取发件箱列表
 *
 *  @param userID   用户ID
 *  @param userType 用户类型
 *  @param pageNo   分页页数
 *  @param pageSize 分页大小
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)requestOutboxListWithUserID:(NSString *)userID userType:(NSString *)userType pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize keyword:(NSString *)keyword Success:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

/**
 *  获取收件箱详情
 *
 *  @param userID   用户ID
 *  @param userType 用户类型
 *  @param linkID   邮件ID
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)requestInboxDetailWithUserID:(NSString *)userID userType:(NSString *)userType linkID:(NSString *)linkID Success:(void (^)(InboxDetailModel *inboxDetail))success failure:(void (^)(NSError *error))failure;

/**
 *  获取发件箱详情
 *
 *  @param userID   用户ID
 *  @param userType 用户类型
 *  @param msgID    邮件ID
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)requestOutboxDetailWithUserID:(NSString *)userID userType:(NSString *)userType msgID:(NSString *)msgID Success:(void (^)(OutboxDetailModel *outboxDetail))success failure:(void (^)(NSError *error))failure;

/**
 *  删除邮件
 *
 *  @param userID   登陆用户id
 *  @param userType 登录用户的类型
 *  @param linkIDs   删除的消息ID，多个可以用半角逗号隔开，如： 11,222,333
 *  @param from     发件箱 传@"send" ，收件箱 传 nil
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)deleteMessageWithUserID:(NSString *)userID userType:(NSString *)userType linkIDs:(NSString *)linkIDs from:(NSString *)from success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/**
 *  发消息
 *
 *  @param userID        登陆用户id
 *  @param userType      登录用户的类型
 *  @param userIDs       收件人UID，多个的话用半角逗号分开，如：11,22,33
 *  @param departmentIDs 若选择部门，传部门ID，若上级部门勾选，将下级部门的ID一并传过来，半角逗号分开
 *  @param title         消息标题
 *  @param content       消息内容
 *  @param success       成功返回
 *  @param failure       失败返回
 */
+ (void)sendMessageWithUserID:(NSString *)userID userType:(NSString *)userType userIDs:(NSString *)userIDs departmentIDs:(NSString *)departmentIDs title:(NSString *)title content:(NSString *)content sendType:(int)sendType success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/**
 *  回复消息
 *
 *  @param userID   登陆用户id
 *  @param userType 登录用户的类型
 *  @param linkID   回复的消息ID
 *  @param toUid    收件箱消息详情中from_uid
 *  @param title    回复标题
 *  @param content  回复内容
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)replyMessageWithUserID:(NSString *)userID userType:(NSString *)userType linkID:(NSString *)linkID toUid:(NSString *)toUid title:(NSString *)title content:(NSString *)content success:(void (^)(void))success failure:(void (^)(NSError *error))failure;

/**
 *  未读消息数
 *
 *  @param userID   登陆用户id
 *  @param userType 登录用户类型
 *  @param success  成功返回
 *  @param failure  失败返回
 */
+ (void)unReadMessageNumberWithUserID:(NSString *)userID userType:(NSString *)userType success:(void (^)(UnreadNumModel *unreadNum))success failure:(void (^)(NSError *error))failure;

//获取未读列表
+ (void)MailBoxTaskListSuccess:(void (^)(NSArray *list))success failure:(void (^)(NSError *error))failure;

@end
