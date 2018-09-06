//
//  VideoDownloadingController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/2/2.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoDownloadingController : UIViewController

@end

@class TCBlobDownloader,DownloadChapterObject;
@interface VideoDownLoadCell : UITableViewCell

@property (nonatomic,strong) TCBlobDownloader *downloader;
@property (nonatomic,strong) DownloadChapterObject *chapterObj;

@property (nonatomic,copy) void(^chooseBtnAction)(DownloadChapterObject *cacheChapter,BOOL choose);

@property (nonatomic,assign) BOOL expand;
@property (nonatomic,assign) BOOL choose;

@end
