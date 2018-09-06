//
//  DataCacheTool.h
//  SWWY
//
//  Created by zhihua on 15/7/23.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendModel.h"

@class PlayRecordModel, UserAnswer;
@interface DataCacheTool : NSObject

+ (BOOL)saveDataWithDic:(NSDictionary *)dict userID:(NSString *)userID authKey:(NSString *)authkey;

+ (NSDictionary *)getDataWithUserID:(NSString *)userID authKey:(NSString *)authkey;

//清除http缓存、播放记录、好友列表
+ (BOOL)clearAllTableRecord;

//好友表方法
+ (BOOL)initializeUserFriendTable;

+ (NSArray *)getAllFriendData;

+ (BOOL)saveFriendDataWithModel:(FriendModel *)model Initial:(NSString *)initial;

+ (BOOL)deleteFriendDataWithfriendId:(NSString *)friendId;

+ (NSArray *)getFriendDataWithName:(NSString *)name;

+ (FriendModel *)getFriendDataWithfriendId:(NSString *)friendId;

+ (BOOL)clearFriendData;

//播放记录
+ (BOOL)addPlayRecord:(PlayRecordModel *)model;

+ (NSMutableArray *)playRecordsWith:(int)page pageSize:(int)size;

//播放进度记录
+ (BOOL)addPlayDurationWithChpaterId:(NSString *)chapterId duration:(NSTimeInterval)duration userAnswer:(UserAnswer *)answer logId:(NSString *)logId;

+ (NSTimeInterval)playDurationInfoWithChapterId:(NSString *)chapterId find:(void (^)(NSTimeInterval duration, UserAnswer *answer, NSString *logId))block;

+ (BOOL)deletePlayDurationWithChapterId:(NSString *)chapterId;

//保存启动图Model
+ (BOOL)saveAdpictureDataWithModel:(Param *)param AdImageURL:(NSString *)adImageURL;

//获取启动图model
+ (Param *)getAdpictureModel;

//获取启动图URL
+ (NSString *)getAdpictureAdImageURL;
//删除启动图本地缓存
+ (BOOL)clearAdpictureData;

@end
