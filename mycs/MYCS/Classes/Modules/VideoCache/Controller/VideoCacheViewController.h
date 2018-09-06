//
//  VideoCacheViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/2/2.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoCacheViewController : UIViewController

@end

@class TCBlobDownloader,DownloadChapterObject,VideoCacheDownloadObject;
@interface VideoCachingCell : UITableViewCell

@property (nonatomic,strong) TCBlobDownloader *downloader;

@property (nonatomic,assign) NSInteger downloadCount;

@property (nonatomic,strong) DownloadChapterObject *chapterObj;

@property (nonatomic,assign,getter=isDownloadError) BOOL downloadError;

@end

@interface VideoCachedCell : UITableViewCell

//@property (nonatomic,strong) VideoCacheObject *object;
//
@property (nonatomic,copy) void(^chooseBtnBlock)(VideoCacheDownloadObject *object,BOOL choose);
@property (nonatomic,strong) VideoCacheDownloadObject *object;

@property (nonatomic,assign) BOOL expand;
@property (nonatomic,assign) BOOL choose;

@end