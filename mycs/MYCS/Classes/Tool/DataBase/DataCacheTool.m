//
//  DataCacheTool.m
//  SWWY
//
//  Created by zhihua on 15/7/23.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "DataCacheTool.h"
#import <FMDB.h>
#import "PlayRecordModel.h"
#import "NSData+Util.h"
#import "TaskPaperViewController.h"

#define kFriend @"friend"
#define kPlayRecord @"PlayRecord"
#define kPlayDuration @"PlayDuration"

static FMDatabase *_db;

@implementation DataCacheTool

+ (void)initialize {
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"Data.sqlite"];

    _db = [FMDatabase databaseWithPath:filePath];

    [self initializeHTTPCaceTable];
    [self initializePlayRecordTable];
    [self initializePlayDurationTable];
    [self initializeUserFriendTable];
    [self initializeAdpictureTable];
}

#pragma mark - 网络请求缓存表
+ (BOOL)initializeHTTPCaceTable {
    if ([_db open])
    {
        BOOL success = [_db executeUpdate:@"create table if not exists t_Cache (id integer primary key autoincrement,userID text,authkey text,dict blob not null);"];

        return success;
    }

    return NO;
}

+ (BOOL)saveDataWithDic:(NSDictionary *)dict userID:(NSString *)userID authKey:(NSString *)authkey {
    if (!dict)
    {
        return NO;
    }
    //将网络请求返回的json数据，转为NSData
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];

    //插入数据库
    BOOL success = [_db executeUpdate:@"insert into t_Cache (userID,authkey,dict) values(?,?,?)", userID, authkey, data];
    return success;
}

+ (NSDictionary *)getDataWithUserID:(NSString *)userID authKey:(NSString *)authkey {
    FMResultSet *set;

    //获取最后插入的记录
    set = [_db executeQuery:@"select * from t_Cache where userID = ? and authkey = ? order by id desc limit 0,1", userID, authkey];

    NSDictionary *dict;

    while ([set next])
    {
        NSData *data = [set dataForColumn:@"dict"];
        dict         = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];

        break;
    }

    [set close];

    return dict;
}

+ (BOOL)clearAllTableRecord {
    BOOL success1 = [_db executeUpdate:@"delete from t_Cache"];
    BOOL success2 = [_db executeUpdate:@"delete from t_PlayRecord"];
    [self clearFriendData];
    return success1 & success2;
}

#pragma mark - 好友数据库表
+ (BOOL)initializeUserFriendTable {
    if ([_db open])
    {
        BOOL success = [_db executeUpdate:@"create table if not exists t_Friend  (friendId integer primary key,userId text,name text,initial text,friendModel blob);"];
        return success;
    }

    return NO;
}

+ (BOOL)saveFriendDataWithModel:(FriendModel *)model Initial:(NSString *)initial {
    NSMutableData *data = [NSData encodeWith:model key:kFriend];

    if (![AppManager hasLogin]) {
        return NO;
    }
    NSError *error;
    BOOL success = [_db executeUpdate:@"replace into t_Friend (friendId,userId,name,initial,friendModel) values(?,?,?,?,?)" values:@[ model.friendId, [AppManager sharedManager].user.uid, model.name, initial, data ] error:&error];
    return success;
}

+ (BOOL)deleteFriendDataWithfriendId:(NSString *)friendId {
    BOOL success = [_db executeUpdate:@"delete from t_Friend where friendId = ? and userId = ?", friendId, [AppManager sharedManager].user.uid];

    return success;
}

+ (NSArray *)getAllFriendData {
    FMResultSet *set;

    set = [_db executeQuery:@"select * from t_Friend where userId = ? order by initial", [AppManager sharedManager].user.uid];

    NSMutableArray *ListArr = [NSMutableArray array];

    FriendGroupModel *groupModel;
    while ([set next])
    {
        if ([[set stringForColumn:@"initial"] isEqualToString:groupModel.sort])
        {
            NSData *data = [set dataForColumn:@"friendModel"];

            FriendModel *friend = [NSData decodeWith:data key:kFriend];

            [groupModel.fans addObject:friend];
        }
        else
        {
            if (groupModel.fans.count)
                [ListArr addObject:groupModel];

            groupModel = [[FriendGroupModel alloc] init];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"

            groupModel.fans = [NSMutableArray array];

#pragma clang diagnostic pop

            groupModel.sort = [set stringForColumn:@"initial"];

            NSData *data = [set dataForColumn:@"friendModel"];

            FriendModel *friend = [NSData decodeWith:data key:kFriend];

            [groupModel.fans addObject:friend];
        }
    }

    [set close];

    if (groupModel != nil)
        [ListArr addObject:groupModel];

    return ListArr;
}

+ (NSArray *)getFriendDataWithName:(NSString *)name {
    FMResultSet *set = [_db executeQuery:[NSString stringWithFormat:@"select * from t_Friend where name like '%%%@%%' and userId = %@ ", name, [AppManager sharedManager].user.uid]];

    NSMutableArray *ListArr = [NSMutableArray array];

    while ([set next])
    {
        NSData *data = [set dataForColumn:@"friendModel"];

        FriendModel *friend = [NSData decodeWith:data key:kFriend];

        [ListArr addObject:friend];
    }

    [set close];

    return ListArr;
}

+ (FriendModel *)getFriendDataWithfriendId:(NSString *)friendId {
    FMResultSet *set;

    set = [_db executeQuery:[NSString stringWithFormat:@"select * from t_Friend where friendId = %@ and userId = %@", friendId, [AppManager sharedManager].user.uid]];

    FriendModel *model = [[FriendModel alloc] init];

    while ([set next])
    {
        NSData *data = [set dataForColumn:@"friendModel"];

        model = [NSData decodeWith:data key:kFriend];
    }

    [set close];

    return model;
}

+ (BOOL)clearFriendData {
    BOOL success = [_db executeUpdate:@"delete from t_Friend"];
    return success;
}

#pragma mark - 播放记录表
+ (BOOL)initializePlayRecordTable {
    if ([_db open])
    {
        BOOL success = [_db executeUpdate:@"create table if not exists t_PlayRecord (id integer primary key autoincrement,videoId text,model blob not null);"];

        return success;
    }

    return NO;
}

+ (BOOL)addPlayRecord:(PlayRecordModel *)model {
    //插入数据库
    PlayRecordModel *lastModel = [self lastRecordModel];
    //判断最近插入的记录是否同一个视频

    if ([lastModel.video_id isKindOfClass:[NSNumber class]])
    {
        NSString *numberStr = [NSString stringWithFormat:@"%@", lastModel.video_id];
        if ([numberStr isEqualToString:model.video_id]) return NO;
    }
    else if ([lastModel.video_id isKindOfClass:[NSString class]])
    {
        if ([lastModel.video_id isEqualToString:model.video_id]) return NO;
    }

    NSMutableData *data;
    data = [NSData encodeWith:model key:kPlayRecord];

    //插入数据库
    BOOL success = [_db executeUpdate:@"insert into t_PlayRecord (videoId,model) values(?,?)", model.video_id, data];
    return success;

    return YES;
}

//获取最近插入的记录
+ (PlayRecordModel *)lastRecordModel {
    FMResultSet *set;
    set = [_db executeQuery:@"select * from t_PlayRecord order by id desc limit 0,1"];

    PlayRecordModel *model;
    while ([set next])
    {
        NSData *modelData = [set dataForColumn:@"model"];

        model = [NSData decodeWith:modelData key:kPlayRecord];

        break;
    }

    [set close];
    if (!model && model.video_id) return nil;

    return model;
}

+ (NSMutableArray *)playRecordsWith:(int)page pageSize:(int)size {
    int start = (page - 1) * size;

    FMResultSet *set;
    set = [_db executeQuery:@"select * from t_PlayRecord order by id desc limit ?,?", @(start), @(size)];

    NSMutableArray *list = [NSMutableArray array];
    while ([set next])
    {
        PlayRecordModel *model;
        NSData *modelData = [set dataForColumn:@"model"];

        model = [NSData decodeWith:modelData key:kPlayRecord];

        [list addObject:model];
    }

    [set close];

    return list;
}

#pragma mark - 播放进度的记录
+ (BOOL)initializePlayDurationTable {
    if ([_db open])
    {
        BOOL success = [_db executeUpdate:@"create table if not exists t_PlayDuration (id integer primary key autoincrement,UserId text,ChapterId text,Duration double,AnswerModel blob);"];

        //添加新字段
        if (![_db columnExists:@"LogId" inTableWithName:@"t_PlayDuration"])
        {
            [_db executeUpdate:@"ALTER TABLE t_PlayDuration ADD COLUMN LogId text"];
        }

        return success;
    }

    return NO;
}

+ (BOOL)addPlayDurationWithChpaterId:(NSString *)chapterId duration:(NSTimeInterval)duration userAnswer:(UserAnswer *)answer logId:(NSString *)logId {
    [self deletePlayDurationWithChapterId:chapterId];

    NSData *data = [NSData encodeWith:answer key:kPlayDuration];

    NSString *userId = [AppManager sharedManager].user.uid;

    //插入数据库
    BOOL success = [_db executeUpdate:@"insert into t_PlayDuration (UserId,ChapterId,Duration,AnswerModel,LogId) values(?,?,?,?,?)", userId, chapterId, @(duration), data, logId];

    return success;
}

+ (NSTimeInterval)playDurationInfoWithChapterId:(NSString *)chapterId find:(void (^)(NSTimeInterval, UserAnswer *, NSString *))block {
    NSString *userId = [AppManager sharedManager].user.uid;

    FMResultSet *set;
    set = [_db executeQuery:@"select * from t_PlayDuration where UserId = ? and ChapterId = ?", userId, chapterId];

    UserAnswer *answer;
    NSTimeInterval duration = 0.0;
    NSString *logId;

    while ([set next])
    {
        NSData *modelData = [set dataForColumn:@"AnswerModel"];
        answer            = [NSData decodeWith:modelData key:kPlayDuration];
        duration          = [set doubleForColumn:@"Duration"];
        logId             = [set stringForColumn:@"LogId"];
    }

    [set close];

    if (block)
    {
        block(duration, answer, logId);
    }

    return duration;
}

+ (BOOL)deletePlayDurationWithChapterId:(NSString *)chapterId {
    BOOL success = [_db executeUpdate:@"delete from t_PlayDuration where ChapterId = ? and userId = ?", chapterId, [AppManager sharedManager].user.uid];

    return success;
}

#pragma mark - 启动图记录表
+ (BOOL)initializeAdpictureTable {
    if ([_db open])
    {
        BOOL success = [_db executeUpdate:@"create table if not exists t_Adpicture (id integer primary key autoincrement,adImageURL text,paramModel blob);"];

        return success;
    }

    return NO;
}

+ (BOOL)saveAdpictureDataWithModel:(Param *)param AdImageURL:(NSString *)adImageURL {
    NSMutableData *data = [NSData encodeWith:param key:@"t_Adpicture"];

    NSError *error;
    BOOL success = [_db executeUpdate:@"replace into t_Adpicture (id,adImageURL,paramModel) values(?,?,?)" values:@[ @(1990), adImageURL, data ] error:&error];

    return success;
}

//获取启动图model
+ (Param *)getAdpictureModel {
    FMResultSet *set;
    set = [_db executeQuery:@"select * from t_Adpicture"];

    Param *model;
    while ([set next])
    {
        NSData *modelData = [set dataForColumn:@"paramModel"];

        model = [NSData decodeWith:modelData key:@"t_Adpicture"];

        break;
    }

    [set close];

    return model;
}

//获取启动图URL
+ (NSString *)getAdpictureAdImageURL {
    FMResultSet *set;
    set = [_db executeQuery:@"select * from t_Adpicture"];

    NSString *str;
    while ([set next])
    {
        str = [set stringForColumn:@"adImageURL"];

        break;
    }

    [set close];

    return str;
}

+ (BOOL)clearAdpictureData {
    BOOL success = [_db executeUpdate:@"delete from t_Adpicture"];
    return success;
}

@end
