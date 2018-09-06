//
//  TaskDetailModel.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Detail,Chapters,TaskJoinUser,TaskJoinUserModel;
@interface TaskDetailModel : NSObject

@property (nonatomic, strong) Detail *detail;

@property (nonatomic, strong) TaskJoinUser *user;

+ (void)taskDetailWith:(NSString *)taskId memberTaskId:(NSString *)memberTaskId sort:(NSString *)sort success:(void(^)(TaskDetailModel *detailModel))success failure:(void(^)(NSError *error))failure;

@end


@interface Detail : NSObject

@property (nonatomic, copy) NSString *courseName;

@property (nonatomic, copy) NSString *category;

@property (nonatomic, assign) NSInteger taskTotal;

@property (nonatomic, assign) NSInteger click;

@property (nonatomic, copy) NSString *videoPic;

@property (nonatomic, assign) NSInteger issueTime;

@property (nonatomic, strong) NSArray<Chapters *> *chapters;

@property (nonatomic, assign) NSInteger courseId;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) NSInteger endTime;

@property (nonatomic, assign) NSInteger pass_rate;

@property (nonatomic, copy) NSString *taskName;

@property (nonatomic, copy) NSString *duration;

@property (nonatomic, copy) NSString *userTaskId;

@property (nonatomic, assign) NSInteger status;

@property (nonatomic, copy) NSString *mp4Url;

@property (nonatomic, assign) NSInteger passNum;

@end

@interface Chapters : NSObject

@property (nonatomic, strong) NSArray *papers;

@property (nonatomic, assign) NSInteger videoId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *mp4Url;

@end

@interface TaskJoinUser : NSObject

@property (nonatomic, assign) NSInteger total;

@property (nonatomic, strong) NSArray<TaskJoinUserModel *> *list;

@end

@interface TaskJoinUserModel : NSObject

@property (nonatomic, assign) NSInteger passed;

@property (nonatomic, copy) NSString *realname;

@property (nonatomic, copy) NSString *user_id;

@property (nonatomic, copy) NSString *username;

@property (nonatomic, copy) NSString *rank;

@property (nonatomic, assign) NSInteger taskStatus;

@property (nonatomic, assign) NSInteger userRate;

@property (nonatomic,assign,getter=isSelected) BOOL select;


+ (void)userJoinListWith:(NSString *)taskId Sort:(NSString *)sort page:(NSInteger)page requestType:(NSString *)type success:(void(^)(NSMutableArray *list))success failure:(void(^)(NSError *error))failure;

@end

@interface TaskJoinHospitalModel : NSObject

@property (nonatomic,copy)NSString * uid;
@property (nonatomic,copy)NSString * realname;

+ (void)hospitalJoinListWith:(NSString *)taskId Sort:(NSString *)sort page:(NSInteger)page taskType:(NSString *)taskType success:(void(^)(NSMutableArray *list))success failure:(void(^)(NSError *error))failure;

@end


