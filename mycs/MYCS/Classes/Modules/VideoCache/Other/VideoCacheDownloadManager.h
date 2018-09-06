//
//  VideoCacheDownload.h
//  MYCS
//
//  Created by AdminZhiHua on 16/2/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoDetail.h"
#import "CourseDetail.h"
#import "SopDetail.h"

extern NSString *const CacheObjectTypeVideo;
extern NSString *const CacheObjectTypeCourse;
extern NSString *const CacheObjectTypeSOP;

typedef NS_ENUM(NSInteger,DownloadStatus) {
    DownloadStatusWaiting = 0,
    DownloadStatusPause = 1,
    DownloadStatusDowning = 2,
    DownloadStatusError = 3,
    DownloadStatusComplete = 4
};

@class ChapterModel,VideoCacheDownloadObject,DownloadChapterObject;
@interface VideoCacheDownloadManager : NSObject

//向数据库中添加数据
+ (BOOL)addObjectWith:(NSString *)objId cacheType:(NSString *)type object:(id)object;

//根据ID获取数据
+ (VideoCacheDownloadObject *)objectWithId:(NSString *)objId;

//更新数据,把数据的第一个章节下载完成设置yes
+ (BOOL)setObjectFirstCompleteWithId:(NSString *)objId;

//更新数据
+ (BOOL)updateCacheObjectWith:(id)obj account:(NSString *)objId;

//获取第一个章节下载完成的数据
+ (NSArray *)firstCompleteObjectLists;

//获取所有数据
+ (NSArray *)allObjectLists;

//根据VideoCacheDownloadObject来删除数据
+ (void)deleteObjectsWith:(NSArray *)list;

//--------------------下载列表--------------------

//添加需要下载的章节模型
+ (BOOL)addDownloadChapterWithId:(NSString *)objId chapterId:(NSString *)chapterId chapter:(ChapterModel *)chapter;

//根据ID获取下载的章节
+ (DownloadChapterObject *)downloadObjectWithChpaterId:(NSString *)chapterId;

//删除数据
+ (BOOL)deleteDownloadChapterByChapterId:(NSString *)chapterId;

//设置下载的状态
+ (BOOL)setDownloadChapterWith:(double)progress downloadStatus:(DownloadStatus)status accountChapterId:(NSString *)chapterId;

//获取所有添加的下载列表
+ (NSArray *)downloadChapterList;

//除了下载完成的下载列表
+ (NSArray *)downloadChapterListExceptComplete;

//获取下一个等待下载的记录
+ (DownloadChapterObject *)nextWaitingChapterObjectByChapterId:(NSString *)chapterId;

//添加下载
+ (void)downloadChapterWith:(DownloadChapterObject *)chapterObj;

//取消当前下载
+ (NSString *)cancelCurrentDownload;

//暂停当前下载
+ (void)pauseCurrentDownload;

//清除所有表记录
+ (BOOL)clearAllTableRecord;

@end

@interface VideoCacheDownloadObject : NSObject

@property (nonatomic,strong) NSString *objId;
@property (nonatomic,strong) NSString *objType;
//VideoDetail,CourseDetail,SOPDetail模型
@property (nonatomic,strong) id obj;

@end

@interface DownloadChapterObject : NSObject

//VideoDetail,CourseDetail,SOPDetail的ID
@property (nonatomic,copy) NSString *objId;
@property (nonatomic,copy) NSString *chapterId;
@property (nonatomic,assign) DownloadStatus status;
@property (nonatomic,assign) CGFloat progress;

@property (nonatomic,strong) ChapterModel *chapter;

@end

