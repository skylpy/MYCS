//
//  LiveListModel.h
//  MYCS
//
//  Created by GuiHua on 16/8/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface LiveURLModel : JSONModel

@property (nonatomic,copy) NSString <Optional> *up;
@property (nonatomic,copy) NSString <Optional> *m3u8;

@end

@interface LiveDetail : JSONModel
@property (nonatomic,copy) NSString <Optional> *pk;
@property (nonatomic,copy) NSString <Optional> *stream_id;
@property (nonatomic,copy) NSString <Optional> *cuid;
@property (nonatomic,copy) NSString <Optional> *anchor;
@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *cate_id;
@property (nonatomic,assign) int ext_permission;
@property (nonatomic,copy) NSString <Optional> *check_word;
@property (nonatomic,copy) NSString <Optional> *chat_server_path;
@property (nonatomic,copy) NSString <Optional> *anchor_intro;
@property (nonatomic,copy) NSString <Optional> *cover_id;
@property (nonatomic,copy) NSString <Optional> *detail;
@property (nonatomic,assign) int status;
@property (nonatomic,assign) int online;
@property (nonatomic,copy) NSString <Optional> *create_time;
@property (nonatomic,copy) NSString <Optional> *live_time;
@property (nonatomic,copy) NSString <Optional> *end_time;
@property (nonatomic,copy) NSString <Optional> *last_update;
@property (nonatomic,copy) NSString <Optional> *img;
@property (nonatomic,copy) NSString <Optional> *cate_name;
@property (nonatomic,copy) NSString <Optional> *realname;
@property (nonatomic,copy) NSString <Optional> *room_id;
@end

@interface LiveListModel : JSONModel
@property (nonatomic,copy) NSString <Optional> *pk;
@property (nonatomic,copy) NSString <Optional> *stream_id;
@property (nonatomic,copy) NSString <Optional> *cuid;
@property (nonatomic,copy) NSString <Optional> *anchor;
@property (nonatomic,copy) NSString <Optional> *title;
@property (nonatomic,copy) NSString <Optional> *cate_id;
@property (nonatomic,assign) int ext_permission;//1-所有人，2-需要登录，3-验证
@property (nonatomic,copy) NSString <Optional> *check_word;
@property (nonatomic,copy) NSString <Optional> *chat_server_path;
@property (nonatomic,copy) NSString <Optional> *anchor_intro;
@property (nonatomic,copy) NSString <Optional> *cover_id;
@property (nonatomic,copy) NSString <Optional> *detail;
@property (nonatomic,assign) int status;//直播状态（'1:未开始', '2:直播中', '3:已取消', '4:已结束'）
@property (nonatomic,copy) NSString <Optional> *online;
@property (nonatomic,copy) NSString <Optional> *create_time;
@property (nonatomic,copy) NSString <Optional> *live_time;
@property (nonatomic,copy) NSString <Optional> *end_time;
@property (nonatomic,copy) NSString <Optional> *last_update;
@property (nonatomic,copy) NSString <Optional> *img;
@property (nonatomic,copy) NSString <Optional> *status_str;
@property (nonatomic,copy) NSString <Optional> *live_time_str;
@property (nonatomic,copy) NSString <Optional> *start_time_str;
@property (nonatomic,copy) NSString <Optional> *end_time_str;
@property (nonatomic,copy) NSString <Optional> *cate_str;
@property (nonatomic,copy) NSString <Optional> *id_str;
@property (nonatomic,copy) NSString <Optional> *realname;
@property (nonatomic,copy) NSString <Optional> *shareUrl;
/**
 *  @author GuiHua, 16-08-19 15:08:39
 *
 *  直播列表请求
 *  @param status 直播状态（'1:未开始', '2:直播中', '3:已取消', '4:已结束'）
 *  @param action list
 *  @param sort manage || client 管理与客户端
 *  @param page 当前分页，可选，默认为第一页
 *  @param pageSize 分页数据页记录数，可选，默认使用web端配置
 *  @param success 返回数组列表
 *  @param failure 返回错误信息
 */
+(void)requestListDataWithStatus:(NSString *)status
                          Action:(NSString *)action
                            Sort:(NSString *)sort
                            Page:(int)page
                        PageSize:(int)pageSize
                         Success:(void (^)(NSArray *list))success
                         Failure:(void (^)(NSError *error))failure;

/**
 *  @author GuiHua, 16-08-19 16:08:39
 *
 *  发布或者修改直播
 *  @param roomId 直播房间id（空为发布，不为空则为修改）
 *  @param cateId 科室名称
 *  @param anchorIntro 所属单位
 *  @param anchor 主讲人
 *  @param liveTime 直播时间（int）
 *  @param title 标题
 *  @param coverId 封面图片id
 *  @param detail 直播简介
 *  @param extPermission 直播权限（1: 所有人 2: 需登录 3: 需验证）
 *  @param checkWord 3: 需验证 对应验证码
 *  @param action save
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)releaseLiveWithRoomId:(NSString *)roomId
                      CateId:(NSString *)cateId
                 AnchorIntro:(NSString *)anchorIntro
                      anchor:(NSString *)anchor
                    liveTime:(NSString *)liveTime
                       tilte:(NSString *)title
                     coverId:(NSString *)coverId
                   checkWord:(NSString *)checkWord
                      detail:(NSString *)detail
               extPermission:(NSString *)extPermission
                      action:(NSString *)action
                     Success:(void (^)(SCBModel *model))success
                     Failure:(void (^)(NSError *error))failure;
/**
 *  @author GuiHua, 16-08-22 10:08:55
 *
 *  视频直播详情
 *  @param roomId 直播房间ID
 *  @param action   detail
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)requestLiveDetailWithRoomId:(NSString *)roomId
                            action:(NSString *)action
                           Success:(void (^)(LiveDetail *model))success
                           Failure:(void (^)(NSError *error))failure;
/**
 *  @author GuiHua, 16-08-22 15:08:47
 *
 *  删除直播
 *  @param roomId 直播房间ID
 *  @param action del
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)deleteLiveDetailWithRoomId:(NSString *)roomId
                           action:(NSString *)action
                          Success:(void (^)(SCBModel *model))success
                          Failure:(void (^)(NSError *error))failure;
/**
 *  @author GuiHua, 16-09-01 15:09:34
 *
 *  修改直播状态
 *  @param roomId 直播房间id
 *  @param action  status
 *  @param status 直播状态（'1:直播中'，‘2:结束直播’）
 *  @param success
 *  @param failure
 */
+(void)changeLiveStatusWithRoomId:(NSString *)roomId
                           action:(NSString *)action
                           status:(NSString *)status
                          Success:(void (^)(SCBModel *model))success
                          Failure:(void (^)(NSError *error))failure;

/**
 *  @author GuiHua, 16-08-22 15:08:42
 *
 *  验证验证码
 *  @param roomId 房间ID
 *  @param checkWord 验证码
 *  @param action  check
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
+(void)checkCheckWordWithRoomId:(NSString *)roomId
                      checkWord:(NSString *)checkWord
                         action:(NSString *)action
                        Success:(void (^)(SCBModel *model))success
                        Failure:(void (^)(NSError *error))failure;
/**
 *  @author GuiHua, 16-08-31 17:08:46
 *
 *  禁言
 *  @param userID 用户id
 *  @param liveID 直播id
 *  @param success
 *  @param failure
 */
+(void)silentWith:(NSString *)userID
              and:(NSString *)liveID
          Success:(void (^)(SCBModel *model))success
          Failure:(void (^)(NSError *error))failure;

+(void)getPushUrl:(NSString *)roomId
          Success:(void (^)(LiveURLModel *model))success
          Failure:(void (^)(NSError *error))failure;

@end









