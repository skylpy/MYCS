//
//  checkNewMsgAndTask.h
//  SWWY
//
//  Created by Yell on 15/5/21.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"

@interface NewMsgCountModel : JSONModel

//信箱未读数
@property (nonatomic,assign) NSString *msgCount;
//任务数
@property (nonatomic,assign) NSString *taskCount;

//未读消息个数
@property (nonatomic,copy) NSString<Optional> *unreadCount;
//评论个数
@property (nonatomic,copy) NSString<Optional> *evaluationCount;

+(void)checkUpdateWithUserID:(NSString *)userID userType:(NSString *)userType  Success:(void (^)(NewMsgCountModel *model))success failure:(void (^)(NSError *error))failure;

@end
