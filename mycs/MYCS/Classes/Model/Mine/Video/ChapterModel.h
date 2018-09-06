//
//  ChapterModel.h
//  SWWY
//
//  Created by 黄希望 on 15-1-24.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import "JSONModel.h"
#import "PaperModel.h"

@protocol ChapterModel @end

@interface ChapterModel : JSONModel

@property (strong,nonatomic) NSString *duration;            // 章节时长
@property (strong,nonatomic) NSString *chapterId;           // 章节ID
@property (strong,nonatomic) NSString<Optional> *mp4Url;    // mp4地址
@property (nonatomic,copy) NSString<Optional> *m3u8;
@property (strong,nonatomic) NSString<Optional> *picUrl;    // 对应上级图片地址，要手动设置
@property (strong,nonatomic) NSString<Optional> *mp4UrlHd;    // mp4地址
@property (nonatomic,copy) NSString<Optional> *m3u8Hd;
//是否播放高清视频
@property (nonatomic,assign,getter=isChangeHD) BOOL changeHD;
@property (strong,nonatomic) NSString *name;                // 章节标题
@property (assign,nonatomic) int paperCount;                // paperCount
@property (strong,nonatomic) NSString<Optional> *videoId;
@property (strong,nonatomic) NSArray<PaperModel> *papers;
@property (assign,nonatomic) NSInteger ListIndex;

//新增字段
@property (nonatomic,assign) BOOL cando;
@property (nonatomic,assign) BOOL passStatus;
@property (nonatomic,copy) NSString *chapter_rate;

@property (nonatomic,copy) NSString *fileSize;
@property (nonatomic,assign,getter=isDownloadComplete) BOOL downloadComplete;

@end
