//
//  MediaPlayerViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MeidaPlayType) {
    MeidaPlayTypeVideo  = -1,
    MeidaPlayTypeCourse = 0,
    MeidaPlayTypeSOP    = 1
};

typedef NS_ENUM(NSUInteger, MediaPlayStatus) {
    MediaPlayStatusUnknow,
    MediaPlayStatusPlay,
    MediaPlayStatusPause,
    MediaPlayStatusCache,
    MediaPlayStatusFinish
};

@class VideoDetail, CourseDetail, SopDetail, ChapterModel,DoctorsHealthDetail;

@interface MediaPlayerViewController : UIViewController

@property (nonatomic, assign) MediaPlayStatus status;

//是否需要上传学习日志
@property (nonatomic, assign) BOOL needToUploadLog;

//判断是否播放缓存文件，如果是则暂停下载任务
@property (nonatomic, assign) BOOL comeFromCacheFile;

//活动ID
@property (nonatomic,copy) NSString *activityId;

//是否从活动进入,YES代表是，
@property (nonatomic,assign,getter=isActivity) BOOL activity;

//参数有则传具体参数，没有则传nil
+ (instancetype)showWith:(UIViewController *)baseVC coursePackArray:(NSArray *)coursePackArray videoDetail:(VideoDetail *)videoDetail courseDetail:(CourseDetail *)courseDetail sopDetail:(SopDetail *)sopDetail chapter:(ChapterModel *)chapter DoctorsHealthDetail:(DoctorsHealthDetail*)doctorsHealthDetail isTask:(BOOL)isTask isPreview:(BOOL)preview previewTips:(NSString *)previewTips;

//播放缓存视频
//+ (instancetype)showWith:(UIViewController *)baseVC cacheChapter:(VideoCacheChapter *)chapter;

@end
