//
//  VideoCacheDownload.m
//  MYCS
//
//  Created by AdminZhiHua on 16/2/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "VideoCacheDownloadManager.h"
#import <FMDB.h>
#import "ChapterModel.h"
#import "TCBlobDownload.h"
#import "NSData+Util.h"

static FMDatabase *DB;

NSString *const CacheObjectTypeVideo = @"CacheObjectTypeVideo";
NSString *const CacheObjectTypeCourse = @"CacheObjectypeCourse";
NSString *const CacheObjectTypeSOP = @"CacheObjectTypeSOP";

@implementation VideoCacheDownloadManager

+ (void)load {
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:@"VideoCache.sqlite"];
    
    DB = [FMDatabase databaseWithPath:filePath];
    
    [self initializeVideoCacheTable];
    
    [self initializeDownloadCacheTable];
    
}

//创表t_VideoCache
+ (BOOL)initializeVideoCacheTable {
    
    if ([DB open])
    {
        //objId - 视频ID，教程ID，SOPID
        BOOL success = [DB executeUpdate:@"create table if not exists t_VideoCache (id integer primary key autoincrement,UserId text,ObjId text,Type text,FirstComplete integer,VideoCacheObj blob not null);"];
        
        return success;
    }
    
    return NO;
}

//创表t_DownloadCache
+ (BOOL)initializeDownloadCacheTable {
    
    if ([DB open])
    {
        //chapterId
        BOOL success = [DB executeUpdate:@"create table if not exists t_DownloadCache (id integer primary key autoincrement,UserId text,ObjId text,ChapterId text,Status integer,Progress double,DownloadChapter blob not null);"];
        
        return success;
    }
    
    return NO;
}

+ (BOOL)addObjectWith:(NSString *)objId cacheType:(NSString *)type object:(id)object {
    
    //查看数据库中是否已经添加,防止重复添加
    VideoCacheDownloadObject *obj = [self objectWithId:objId];
    
    if (obj.objId&&obj.obj) return NO;
    
    NSData *data = [NSData encodeWith:object key:@"VideoCache"];
    
    NSString *userId = [AppManager sharedManager].user.uid;
    if(![AppManager hasLogin]) userId = @"90909090";
    
    BOOL success =[DB executeUpdate:@"insert into t_VideoCache (UserId,ObjId,Type,FirstComplete,VideoCacheObj) values(?,?,?,?,?)",userId,objId,type,@(0),data];
    
    return success;
}

+ (VideoCacheDownloadObject *)objectWithId:(NSString *)objId {
    
    FMResultSet *set;
    
    NSString *userId = [AppManager sharedManager].user.uid;
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        set = [DB executeQuery:@"select * from t_VideoCache where ObjId = ? and UserId = ?",objId,userId];
    }else
    {
        set = [DB executeQuery:@"select * from t_VideoCache where ObjId = ? and UserId in (?,?)",objId,userId,@"90909090"];
    }
    
    VideoCacheDownloadObject *obj = [VideoCacheDownloadObject new];
    
    while ([set next]) {
        
        NSString *objId = [set stringForColumn:@"ObjId"];
        
        if (!objId) break;
        
        obj.objId = objId;
        
        NSData *data = [set dataForColumn:@"VideoCacheObj"];
        
        obj.obj = [NSData decodeWith:data key:@"VideoCache"];
        
        obj.objType = [set stringForColumn:@"Type"];
        
        break;
    }
    
    //关闭事物
    [set close];
    
    if (!obj.objId) return nil;
    
    return obj;
}

+ (BOOL)deleteObjectById:(NSString *)objId {
    
    NSString *userId = [AppManager sharedManager].user.uid;
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        BOOL success = [DB executeUpdate:@"DELETE FROM t_VideoCache WHERE ObjId = ? and UserId = ?",objId,userId];
        
        return success;
    }else
    {
        BOOL success = [DB executeUpdate:@"DELETE FROM t_VideoCache WHERE ObjId = ? and UserId in (?,?)",objId,userId,@"90909090"];
        return success;
    }
}

+ (BOOL)setObjectFirstCompleteWithId:(NSString *)objId {
    
    NSString *userId = [AppManager sharedManager].user.uid;
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        
        BOOL success = [DB executeUpdate:@"UPDATE t_VideoCache SET FirstComplete = ? WHERE ObjId = ? and UserId = ?",@(1),objId,userId];
        
        return success;
    }else
    {
        BOOL success = [DB executeUpdate:@"UPDATE t_VideoCache SET FirstComplete = ? WHERE ObjId = ? and UserId in (?,?)",@(1),objId,userId,@"90909090"];
        
        return success;
    }
}

+ (BOOL)updateCacheObjectWith:(id)obj account:(NSString *)objId {
    
    NSMutableData *data = [NSData encodeWith:obj key:@"VideoCache"];
    NSString *userId = [AppManager sharedManager].user.uid;
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        
        BOOL success = [DB executeUpdate:@"UPDATE t_VideoCache SET VideoCacheObj = ? WHERE ObjId = ?  and UserId = ?",data,objId,userId];
        
        return success;
        
    }else
    {
        BOOL success = [DB executeUpdate:@"UPDATE t_VideoCache SET VideoCacheObj = ? WHERE ObjId = ?  and UserId in (?,?)",data,objId,userId,@"90909090"];
        return success;
    }
}


+ (NSArray *)firstCompleteObjectLists {
    
    FMResultSet *set;
    
    NSString *userId = [AppManager sharedManager].user.uid;
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        set = [DB executeQuery:@"select * from t_VideoCache where FirstComplete = 1 and UserId = ? order by id desc",userId];
    }else
    {
        set = [DB executeQuery:@"select * from t_VideoCache where FirstComplete = 1 and UserId in (?,?) order by id desc",userId,@"90909090"];
    }
    
    NSMutableArray *list = [NSMutableArray array];
    
    while ([set next]) {
        
        VideoCacheDownloadObject *obj = [VideoCacheDownloadObject new];
        
        NSData *data = [set dataForColumn:@"VideoCacheObj"];
        
        obj.obj = [NSData decodeWith:data key:@"VideoCache"];
        obj.objId = [set stringForColumn:@"ObjId"];
        obj.objType = [set stringForColumn:@"Type"];
        
        [list addObject:obj];
    }
    
    //关闭事物
    [set close];
    
    return list;
}

+ (NSArray *)allObjectLists {
    
    FMResultSet *set;
    
    NSString *userId = [AppManager sharedManager].user.uid;
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        
        set = [DB executeQuery:@"select * from t_VideoCache where UserId = ? order by id desc",userId];
    }else
    {
        set = [DB executeQuery:@"select * from t_VideoCache where UserId in(?,?) order by id desc",userId,@"90909090"];
    }
    
    NSMutableArray *list = [NSMutableArray array];
    
    while ([set next]) {
        
        VideoCacheDownloadObject *obj = [VideoCacheDownloadObject new];
        
        NSData *data = [set dataForColumn:@"VideoCacheObj"];
        
        obj.obj = [NSData decodeWith:data key:@"VideoCache"];
        obj.objId = [set stringForColumn:@"ObjId"];
        obj.objType = [set stringForColumn:@"Type"];
        
        [list addObject:obj];
        
    }
    
    //关闭事物
    [set close];
    
    return list;
    
}

+ (void)deleteObjectsWith:(NSArray *)list {
    
    //chapterID数组
    NSMutableArray *array = [NSMutableArray array];
    for (VideoCacheDownloadObject *obj in list)
    {
        if ([obj.objType isEqualToString:CacheObjectTypeVideo])
        {
            [array addObject:obj.objId];
        }
        else if ([obj.objType isEqualToString:CacheObjectTypeCourse])
        {
            CourseDetail *course = obj.obj;
            
            for (ChapterModel *chapter in course.chapters)
            {
                if (chapter.isDownloadComplete)
                {
                    [array addObject:chapter.chapterId];
                }
            }
        }
        else if ([obj.objType isEqualToString:CacheObjectTypeSOP])
        {
            SopDetail *sop = obj.obj;
            
            for (SopCourseModel *course in sop.sopCourse)
            {
                for (ChapterModel *chapter in course.chapters)
                {
                    if (chapter.isDownloadComplete)
                    {
                        [array addObject:chapter.chapterId];
                    }
                }
            }
        }
        
        //删除VideoCacheDownloadObject
        [self deleteObjectById:obj.objId];
    }
    
    for (NSString *chapterId in array)
    {
        [self deleteDownloadChapterByChapterId:chapterId];
    }
    
}

//----------------------下载列表------------------------

+ (BOOL)addDownloadChapterWithId:(NSString *)objId chapterId:(NSString *)chapterId chapter:(ChapterModel *)chapter {
    
    //查看数据库中是否已经添加
    DownloadChapterObject *obj = [self downloadObjectWithChpaterId:chapterId];
    
    if (obj.objId&&obj.chapter) return NO;
    
    NSMutableData *data = [NSData encodeWith:chapter key:@"DownloadChapter"];
    
    NSString *userId = [AppManager sharedManager].user.uid;
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        BOOL success =[DB executeUpdate:@"insert into t_DownloadCache (ObjId,ChapterId,Status,Progress,DownloadChapter,UserId) values(?,?,?,?,?,?)",objId,chapterId,@(DownloadStatusWaiting),@(0),data,userId];
        
        //如果当前没有下载任务，则添加下载
        [self addToDownloadWith:chapter objId:objId];
        
        return success;
        
    }else
    {
        BOOL success =[DB executeUpdate:@"insert into t_DownloadCache (ObjId,ChapterId,Status,Progress,DownloadChapter,UserId) values(?,?,?,?,?,?)",objId,chapterId,@(DownloadStatusWaiting),@(0),data,userId];
        
        //如果当前没有下载任务，则添加下载
        [self addToDownloadWith:chapter objId:objId];
        
        return success;
    }
}

+ (DownloadChapterObject *)downloadObjectWithChpaterId:(NSString *)chapterId {
    
    FMResultSet *set;
    
    NSString *userId = [AppManager sharedManager].user.uid;
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        
        set = [DB executeQuery:@"select * from t_DownloadCache where ChapterId = ? and UserId = ?",chapterId,userId];
    }else
    {
        set = [DB executeQuery:@"select * from t_DownloadCache where ChapterId = ? and UserId in(?,?)",chapterId,userId,@"90909090"];
    }
    
    DownloadChapterObject *chapterObj = [DownloadChapterObject new];
    
    while ([set next]) {
        
        NSString *chapterId = [set stringForColumn:@"ChapterId"];
        
        if (!chapterId) break;
        
        chapterObj.chapterId = chapterId;
        chapterObj.objId = [set stringForColumn:@"ObjId"];
        
        chapterObj.status = [set intForColumn:@"Status"];
        chapterObj.progress = [set doubleForColumn:@"Progress"];
        
        NSData *data = [set dataForColumn:@"DownloadChapter"];
        
        chapterObj.chapter = [NSData decodeWith:data key:@"DownloadChapter"];
        
        break;
    }
    
    //关闭事物
    [set close];
    
    if (!chapterObj.chapterId) return nil;
    
    return chapterObj;
    
}

+ (BOOL)deleteDownloadChapterByChapterId:(NSString *)chapterId {
    
    TCBlobDownloadManager *manager = [TCBlobDownloadManager sharedInstance];
    
    if (manager.currentDownloadsCount>0)
    {
        //判断当前下载，是否是需要删除的对象
        TCBlobDownloader *downloader = [manager.operationQueue.operations firstObject];
        if ([downloader.chapterId isEqualToString:chapterId])
        {
            DownloadChapterObject *nextObj = [self nextWaitingChapterObjectByChapterId:chapterId];
            [manager cancelAllDownloadsAndRemoveFiles:NO];
            [self downloadChapterWith:nextObj];
        }
    }
    
    //移除本地文件
    DownloadChapterObject *chapterObj = [self downloadObjectWithChpaterId:chapterId];
    
    //如果当前正在下载，先取消下载
    if (chapterObj.status == DownloadStatusDowning)
    {
        TCBlobDownloadManager *manager = [TCBlobDownloadManager sharedInstance];
        [manager cancelAllDownloadsAndRemoveFiles:NO];
    }
    
    ChapterModel *model = chapterObj.chapter;
    NSString *filePath = [self cachePathWith:model];
    [self removeFile:filePath];
    
    NSString *userId = [AppManager sharedManager].user.uid;
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        
        BOOL success = [DB executeUpdate:@"DELETE FROM t_DownloadCache WHERE ChapterId = ? and UserId = ?",chapterId,userId];
        
        return success;
    }else
    {
        BOOL success = [DB executeUpdate:@"DELETE FROM t_DownloadCache WHERE ChapterId = ? and UserId in(?,?)",chapterId,userId,@"90909090"];
        return success;
    }
}

+ (BOOL)setDownloadChapterWith:(double)progress downloadStatus:(DownloadStatus)status accountChapterId:(NSString *)chapterId{
    
    NSString *userId = [AppManager sharedManager].user.uid;
    BOOL success1;
    BOOL success2;
    
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        success1 = [DB executeUpdate:@"UPDATE t_DownloadCache SET Status = ? WHERE ChapterId = ? and UserId = ?",@((int)status),chapterId,userId];
    }else
    {
        success1 = [DB executeUpdate:@"UPDATE t_DownloadCache SET Status = ? WHERE ChapterId = ? and UserId in(?,?)",@((int)status),chapterId,userId,@"90909090"];
    }
    
    if (progress<0) return success1;
    
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        success2 = [DB executeUpdate:@"UPDATE t_DownloadCache SET Progress = ? WHERE ChapterId = ? and UserId = ?",@(progress),chapterId,userId];
    }else
    {
        success2 = [DB executeUpdate:@"UPDATE t_DownloadCache SET Progress = ? WHERE ChapterId = ? and UserId in(?,?)",@(progress),chapterId,userId,@"90909090"];
    }
    
    return success1&&success2;
}

+ (NSArray *)downloadChapterList {
    
    FMResultSet *set;
    
    NSString *userId = [AppManager sharedManager].user.uid;
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        
        set = [DB executeQuery:@"select * from t_DownloadCache where UserId = ?",userId];
    }else
    {
        set = [DB executeQuery:@"select * from t_DownloadCache where UserId in(?,?)",userId,@"90909090"];
    }
    
    NSMutableArray *list = [NSMutableArray array];
    
    while ([set next]) {
        
        NSString *chapterId = [set stringForColumn:@"ChapterId"];
        
        if (!chapterId) break;
        DownloadChapterObject *chapterObj = [DownloadChapterObject new];
        chapterObj.chapterId = chapterId;
        
        NSString *objId = [set stringForColumn:@"ObjId"];
        chapterObj.objId = objId;
        
        chapterObj.status = (DownloadStatus)[set intForColumn:@"Status"];
        chapterObj.progress = [set doubleForColumn:@"Progress"];
        
        NSData *data = [set dataForColumn:@"DownloadChapter"];
        
        chapterObj.chapter = [NSData decodeWith:data key:@"DownloadChapter"];
        
        [list addObject:chapterObj];
        
    }
    
    //关闭事物
    [set close];
    
    return list;
    
}

+ (NSArray *)downloadChapterListExceptComplete {
    
    FMResultSet *set;
    
    NSString *userId = [AppManager sharedManager].user.uid;
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        
        set = [DB executeQuery:@"select * from t_DownloadCache where Status != 4 and UserId = ?",userId];
    }else
    {
        set = [DB executeQuery:@"select * from t_DownloadCache where Status != 4 and UserId in(?,?)",userId,@"90909090"];
    }
    
    NSMutableArray *list = [NSMutableArray array];
    
    while ([set next]) {
        
        NSString *chapterId = [set stringForColumn:@"ChapterId"];
        
        if (!chapterId) break;
        DownloadChapterObject *chapterObj = [DownloadChapterObject new];
        chapterObj.chapterId = chapterId;
        
        NSString *objId = [set stringForColumn:@"ObjId"];
        chapterObj.objId = objId;
        
        chapterObj.status = (DownloadStatus)[set intForColumn:@"Status"];
        chapterObj.progress = [set doubleForColumn:@"Progress"];
        
        NSData *data = [set dataForColumn:@"DownloadChapter"];
        chapterObj.chapter = [NSData decodeWith:data key:@"DownloadChapter"];
        
        [list addObject:chapterObj];
        
    }
    
    //关闭事物
    [set close];
    
    return list;
}

//如果当前没有下载任务，则添加下载
+ (void)addToDownloadWith:(ChapterModel *)chapter objId:(NSString *)objId {
    
    TCBlobDownloadManager *manager = [TCBlobDownloadManager sharedInstance];
    if (manager.currentDownloadsCount>0) return;
    
    TCBlobDownloader *downloader = [manager startDownloadWithURL:[NSURL URLWithString:chapter.mp4Url] customPath:manager.defaultDownloadPath delegate:nil];
    
    downloader.chapterId = chapter.chapterId;
    downloader.objId = objId;
    downloader.chapterName = chapter.name;
}

+ (DownloadChapterObject *)nextWaitingChapterObjectByChapterId:(NSString *)chapterId {
    
    FMResultSet *set;
    
    NSString *userId = [AppManager sharedManager].user.uid;
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        
        set = [DB executeQuery:@"select * from t_DownloadCache where ChapterId = ? and UserId = ?",chapterId,userId];
    }else
    {
        set = [DB executeQuery:@"select * from t_DownloadCache where ChapterId = ? and UserId in(?,?)",chapterId,userId,@"90909090"];
    }
    
    NSInteger orderId = -1;
    while ([set next]) {
        
        orderId = [set intForColumn:@"id"];
        
        NSString *chapId = [set stringForColumn:@"ChapterId"];
        
        if ([chapId isEqualToString:chapterId]) break;
    }
    
    [set close];
    
    //查找不到chapterI的响应记录
    if (orderId < 0) return nil;
    
    //查找ID比orderId大的正在等待的记录
    FMResultSet *set1;
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        set1 = [DB executeQuery:@"select * from t_DownloadCache where Status = 0 and id > ? and UserId = ?",@(orderId),userId];
    }else
    {
        set1 = [DB executeQuery:@"select * from t_DownloadCache where Status = 0 and id > ? and UserId in(?,?)",@(orderId),userId,@"90909090"];
    }
    
    NSMutableArray *array = [NSMutableArray array];
    
    while ([set1 next]) {
        
        DownloadChapterObject *chapterObj = [DownloadChapterObject new];
        
        chapterObj.chapterId = [set1 stringForColumn:@"ChapterId"];
        
        chapterObj.chapterId = chapterId;
        
        NSString *objId = [set1 stringForColumn:@"ObjId"];
        chapterObj.objId = objId;
        
        chapterObj.status = (DownloadStatus)[set1 intForColumn:@"Status"];
        chapterObj.progress = [set1 doubleForColumn:@"Progress"];
        
        NSData *data = [set1 dataForColumn:@"DownloadChapter"];
        
        chapterObj.chapter = [NSData decodeWith:data key:@"DownloadChapter"];
        
        [array addObject:chapterObj];
        
    }
    
    if (array.count>0) return [array firstObject];
    
    FMResultSet *set2;
    if(![AppManager hasLogin])
    {
        userId = @"90909090";
        set2 = [DB executeQuery:@"select * from t_DownloadCache where Status = 0 and UserId = ?",userId];
    }else
    {
        set2 = [DB executeQuery:@"select * from t_DownloadCache where Status = 0 and UserId in(?,?)",userId,@"90909090"];
    }
    
    NSMutableArray *list = [NSMutableArray array];
    
    while ([set2 next]) {
        
        DownloadChapterObject *chapterObj = [DownloadChapterObject new];
        
        chapterObj.chapterId = [set2 stringForColumn:@"ChapterId"];
        
        chapterObj.chapterId = chapterId;
        
        NSString *objId = [set2 stringForColumn:@"ObjId"];
        chapterObj.objId = objId;
        
        chapterObj.status = (DownloadStatus)[set2 intForColumn:@"Status"];
        chapterObj.progress = [set2 doubleForColumn:@"Progress"];
        
        NSData *data = [set2 dataForColumn:@"DownloadChapter"];
        
        chapterObj.chapter = [NSData decodeWith:data key:@"DownloadChapter"];
        
        [list addObject:chapterObj];
    }
    
    return [list firstObject];
}

+ (void)downloadChapterWith:(DownloadChapterObject *)chapterObj {
    
    if (!chapterObj) return;
    
    TCBlobDownloadManager *manager = [TCBlobDownloadManager sharedInstance];
    
    ChapterModel *model = chapterObj.chapter;
    
    TCBlobDownloader *downloader = [manager startDownloadWithURL:[NSURL URLWithString:model.mp4Url] customPath:manager.defaultDownloadPath delegate:nil];
    
    downloader.chapterId = model.chapterId;
    downloader.objId = chapterObj.objId;
    downloader.chapterName = model.name;
}

+ (NSString *)cancelCurrentDownload {
    
    TCBlobDownloadManager *manager = [TCBlobDownloadManager sharedInstance];
    
    //将当前的下载状态改为等待状态
    if (manager.currentDownloadsCount>0)
    {
        TCBlobDownloader *downloader = [manager.operationQueue.operations firstObject];
        
        NSString *chapterId = downloader.chapterId;
        
        [VideoCacheDownloadManager setDownloadChapterWith:downloader.progress downloadStatus:DownloadStatusWaiting accountChapterId:downloader.chapterId];
        
        [manager cancelAllDownloadsAndRemoveFiles:NO];
        
        return chapterId;
    }
    
    return nil;
}

+ (void)pauseCurrentDownload {
    
    TCBlobDownloadManager *manager = [TCBlobDownloadManager sharedInstance];
    
    //将当前的下载状态改为暂停状态
    if (manager.currentDownloadsCount>0)
    {
        TCBlobDownloader *downloader = [manager.operationQueue.operations firstObject];
        
        //下载下一个视频
        DownloadChapterObject *nextChapterObj = [VideoCacheDownloadManager nextWaitingChapterObjectByChapterId:downloader.chapterId];
        
        [manager cancelAllDownloadsAndRemoveFiles:NO];
        
        if (!nextChapterObj) return;
        
        [VideoCacheDownloadManager setDownloadChapterWith:downloader.progress downloadStatus:DownloadStatusPause accountChapterId:downloader.chapterId];
        
        [VideoCacheDownloadManager downloadChapterWith:nextChapterObj];
    }
    
}

+ (NSString *)cachePathWith:(ChapterModel *)model {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    NSString *fileName = [model.mp4Url lastPathComponent];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject] stringByAppendingPathComponent:@"Videos"];
    filePath = [filePath stringByAppendingPathComponent:fileName];
    
    if ([manager fileExistsAtPath:filePath])
    {
        return filePath;
    }
    
    return nil;
}

/**
 *  遍历文件夹下的所有文件并删除
 *
 *  @param filePath 文件路劲
 */
+ (void)removeFile:(NSString *)filePath
{
    
    BOOL isDirectory;
    BOOL isExits = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory];
    
    if (isExits) {
        
        if (isDirectory) {
            
            NSArray *contentFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:filePath error:nil];
            
            for (NSString *subFile in contentFiles) {
                
                NSString *file = [filePath stringByAppendingPathComponent:subFile];
                
                [[NSFileManager defaultManager] removeItemAtPath:file error:nil];
            }
            
        }else{
            
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            
        }
        
    }
    
    return;
}

+ (BOOL)clearAllTableRecord {
    
    BOOL success1 = [DB executeUpdate:@"delete from t_VideoCache"];
    BOOL success2 = [DB executeUpdate:@"delete from t_DownloadCache"];
    
    return success1&success2;
    
}

@end

@implementation VideoCacheDownloadObject


@end

@implementation DownloadChapterObject


@end
