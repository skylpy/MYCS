//
//  MediaPlayerViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MediaPlayerViewController.h"
#import "LanscapeNaviController.h"
#import "VideoDetail.h"
#import "CourseDetail.h"
#import "SopDetail.h"
#import "MediaControl.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "NSTimer+Blocks.h"
#import "NSTimer+Addition.h"
#import "TaskPaperViewController.h"
#import "Question.h"
#import "PaperAlertView.h"
#import "StudyLogTool.h"
#import "VideoCacheDownloadManager.h"
#import "DataCacheTool.h"
#import "NSDate+Util.h"
#import "UIAlertView+Block.h"
#import "ZFBrightnessView.h"
#import "CoursePackModel.h"
#import "DoctorsHealthList.h"

@interface MediaPlayerViewController ()

@property (nonatomic, strong) VideoDetail *videoDetail;
@property (nonatomic, strong) CourseDetail *courseDetail;
@property (nonatomic, strong) SopDetail *sopDetail;
@property (nonatomic ,strong) DoctorsHealthDetail *doctorHealthDetail;

@property (nonatomic, copy) ChapterModel *chapter;

@property (nonatomic, strong) NSArray *coursePackArray;

@property (nonatomic, strong) MediaControl *mediaControl;
@property (atomic, strong) id<IJKMediaPlayback> player;

@property (nonatomic, assign) MeidaPlayType type;

//任务
@property (nonatomic, assign) BOOL isTask;

//记录试题弹出时间的数组
@property (nonatomic, strong) NSMutableDictionary *timeSpotsDic;

//添加定时器，判断试题弹出
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UserAnswer *userAnswer;

//开始播放的时间戳
@property (nonatomic, copy) NSString *startTime;

//提交上一个章节播放时返回的logId
@property (nonatomic, copy) NSString *logId;

//是否预览
@property (nonatomic, assign, getter=isPreview) BOOL preview;
//预览的提示
@property (nonatomic, copy) NSString *previewTips;
//预览的定时器
@property (nonatomic, strong) NSTimer *previewTimer;

@property (nonatomic, copy) NSString *downloadId;

//断点播放
@property (nonatomic, assign) BOOL breakpointPlay;

@property (nonatomic, assign, getter=isChapterPass) BOOL chapterPass;

//定时保存播放位置
@property (nonatomic, strong) NSTimer *logTimer;

//判断是否播放缓存文件，如果是则暂停下载任务
@property (nonatomic, assign, getter=isPlayCacheFile) BOOL playCacheFile;

//观看时间定时器
@property (nonatomic,strong) NSTimer *viewTimer;

//真实观看时长+答题时间(每个试卷的答题时间总和)   不计算暂停/拖动的时间
@property (nonatomic,assign) NSTimeInterval viewTime;

@property (nonatomic, assign, getter=isHasChapter) BOOL hasChapter;

@end

@implementation MediaPlayerViewController

+ (instancetype)showWith:(UIViewController *)baseVC coursePackArray:(NSArray *)coursePackArray videoDetail:(VideoDetail *)videoDetail courseDetail:(CourseDetail *)courseDetail sopDetail:(SopDetail *)sopDetail chapter:(ChapterModel *)chapter DoctorsHealthDetail:(DoctorsHealthDetail *)doctorsHealthDetail isTask:(BOOL)isTask isPreview:(BOOL)preview previewTips:(NSString *)previewTips{
    //创建视频播放控制器
    MediaPlayerViewController *mediaPlayerVC = [MediaPlayerViewController new];
    mediaPlayerVC.view.backgroundColor       = [UIColor blackColor];
    
    //给属性赋值
    if (courseDetail || sopDetail)
    {
        mediaPlayerVC.hasChapter = YES;
    }else
    {
        
        mediaPlayerVC.hasChapter= NO;
    }
    mediaPlayerVC.preview         = preview;
    mediaPlayerVC.previewTips     = previewTips;
    mediaPlayerVC.coursePackArray = coursePackArray;
    mediaPlayerVC.isTask          = isTask;
    mediaPlayerVC.videoDetail     = videoDetail;
    mediaPlayerVC.courseDetail    = courseDetail;
    mediaPlayerVC.sopDetail       = sopDetail;
    mediaPlayerVC.chapter         = chapter;
    mediaPlayerVC.doctorHealthDetail = doctorsHealthDetail;
    
    if (doctorsHealthDetail)
    {
        //视频专访不需要，其他默认需要上传日志，如果不需要，则手动设置为NO
        mediaPlayerVC.needToUploadLog = NO;
    }else
    {
        //视频专访不需要，其他默认需要上传日志，如果不需要，则手动设置为NO
        mediaPlayerVC.needToUploadLog = YES;
    }
    
    
    //创建横屏导航控制器
    LanscapeNaviController *lansNavi = [[LanscapeNaviController alloc] init];
    [lansNavi addChildViewController:mediaPlayerVC];
    
    [baseVC presentViewController:lansNavi animated:YES completion:nil];
    
    return mediaPlayerVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //添加通知的监听
    [self installMovieNotificationObservers];
    
    [self.mediaControl showNoFade];
    
    [self configMeidaPlayerAction];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    //MediaControl赋值，显示选集
    [ZFBrightnessView sharedBrightnesView];
}

#pragma mark - Action
- (void)dismissMediaPlayer:(void(^)())complete {
    [self destoryPlayer];
    [self destoryTimer];
    
    //移除通知
    [self removeMovieNotificationObservers];
    
    //移除MediaControl
    [self.mediaControl cancelDelayedEvent];
    
    //上传退出日志
    [self studyLogExit];
    
    [self.mediaControl removeFromSuperview];
    self.mediaControl = nil;
    
    [self resumeDownloadTask];
    
    [self dismissViewControllerAnimated:YES completion:complete];
}

- (void)savePlayDuration {
    //非任务或者章节通过不保存答题时间
    if (!self.isTask) return;
    if (self.isChapterPass) return;
    
    NSTimeInterval position;
    position = self.player.currentPlaybackTime;
    
    if (position < 3) return;
    
    [DataCacheTool addPlayDurationWithChpaterId:self.chapter.chapterId duration:position userAnswer:self.userAnswer logId:self.logId];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    self.mediaControl.isShowing ? [self.mediaControl hide] : [self.mediaControl showAndFade];
//}

//暂停下载任务
- (void)pauseDownloadTask {
    //获取正在下载的章节ID
    NSString *chapterId = [VideoCacheDownloadManager cancelCurrentDownload];
    
    if (self.downloadId) return;
    self.downloadId = chapterId;
}

//开始下载任务
- (void)resumeDownloadTask {
    if (!self.downloadId) return;
    
    //添加下载
    DownloadChapterObject *chapterObj = [VideoCacheDownloadManager downloadObjectWithChpaterId:self.downloadId];
    
    [VideoCacheDownloadManager downloadChapterWith:chapterObj];
}

- (void)configMeidaPlayerAction {
    __weak typeof(self) weakSelf = self;
    //返回按钮的点击
    self.mediaControl.backButtonAction = ^(UIButton *btn) {
        [weakSelf savePlayDuration];
        [weakSelf dismissMediaPlayer:nil];
    };
    
    //播放按钮的点击
    self.mediaControl.playButtonAction = ^(UIButton *btn) {
        BOOL isPlaying = [weakSelf.player isPlaying];
        
        if (isPlaying)
        {
            [weakSelf.player pause];
            weakSelf.status = MediaPlayStatusPause;
        }
        else
        {
            [weakSelf.player play];
        }
    };
    
    //播放下一集按钮的点击
    self.mediaControl.nextButtonAction = ^(UIButton *btn) {
        [weakSelf playNextChapterOfCourseOrSop];
    };
    
    //选集按钮的点击
    self.mediaControl.selectButtonAction = ^(UIButton *btn) {
        
    };
    
    //滑动条
    self.mediaControl.sliderAction = ^(UISlider *slider,ChapterModel * chapter) {
        //非任务或者任务通过的可以拖动进度条
        if (!weakSelf.isTask || chapter.passStatus)
        {
            [weakSelf.player pause];
            
            [weakSelf.player setCurrentPlaybackTime:slider.value];
            
            [weakSelf.player play];
        }
    };
    
    //课程播放下一集按钮的点击
    self.mediaControl.nextCoursePackButtonAction = ^(UIButton *btn) {
        [weakSelf playNextCourseChapter];
    };
    
    //点击提示
    
    self.mediaControl.tipsButtonAction = ^(UIButton *btn){
        
        [weakSelf showAlertView];
    };
    
    //清晰度回调
    self.mediaControl.clarityAction = ^(UIButton *clarityButton,ChapterModel *chapter,VideoDetail *videoDetail,DoctorsHealthDetail *doctorsHealthDetail,NSString *nameStr)
    {
        if ([nameStr isEqualToString:@"高清"])
        {
            for (ChapterModel *chat in weakSelf.courseDetail.chapters) {
                chat.changeHD = YES;
            }
            for (CourseDetail *course in weakSelf.sopDetail.sopCourse)
            {
                for (ChapterModel *chat in course.chapters) {
                    chat.changeHD = YES;
                }
            }
            
            [weakSelf.mediaControl.mediaPlayer pause];
            [weakSelf.mediaControl showIndicator];
            videoDetail.changeHD = YES;
            chapter.changeHD = YES;
            weakSelf.doctorHealthDetail = doctorsHealthDetail;
            weakSelf.chapter = chapter;
            weakSelf.videoDetail = videoDetail;
            [weakSelf.mediaControl.mediaPlayer play];
            
        }else if ([nameStr isEqualToString:@"标清"])
        {
            for (ChapterModel *chat in weakSelf.courseDetail.chapters) {
                chat.changeHD = NO;
            }
            for (CourseDetail *course in weakSelf.sopDetail.sopCourse)
            {
                for (ChapterModel *chat in course.chapters) {
                    chat.changeHD = NO;
                }
            }

            [weakSelf.mediaControl.mediaPlayer pause];
            [weakSelf.mediaControl showIndicator];
            videoDetail.changeHD = NO;
            chapter.changeHD = NO;
            weakSelf.doctorHealthDetail = doctorsHealthDetail;
            weakSelf.chapter = chapter;
            weakSelf.videoDetail = videoDetail;
            [weakSelf.mediaControl.mediaPlayer play];
        }
        
    };
}

-(void)showAlertView
{
    [self.player pause];
    [self.previewTimer pauseTimer];
    
    [PaperAlertView showInView:self.view message:self.previewTips With:AlertViewTypeCheckAll usingBlock:^(PaperAlertView *alertView, NSInteger buttonIndex) {
        if ([self.previewTips isEqualToString:@"本视频需登录后才能观看!"])
        {
            [self dismissMediaPlayer:^{
                
                [AppManager checkLogin];
                
            }];
            
            [alertView removeFromSuperview];
        }
        else
        {
            [self dismissMediaPlayer:nil];
            [alertView removeFromSuperview];
        }
    }];
    
}

- (void)playNextCourseChapter {
    NSUInteger courseCount = self.coursePackArray.count;
    
    NSUInteger courseIdx  = 0;
    NSUInteger chapterIdx = 0;
    
    BOOL stop = NO;
    for (int i = 0; i < self.coursePackArray.count; i++)
    {
        //当前第几个章节
        courseIdx               = i;
        CoursePackModel *course = self.coursePackArray[i];
        for (int j = 0; j < course.coursePackChapters.count; j++)
        {
            chapterIdx              = j;
            CoursePackChapter *chap = course.coursePackChapters[j];
            if (chap.isSelect.integerValue == 1)
            {
                stop = YES;
                break;
            }
        }
        if (stop) break;
    }
    
    for (CoursePackModel *packModel in self.coursePackArray)
    {
        for (CoursePackChapter *packChapter in packModel.coursePackChapters)
        {
            packChapter.isSelect = @"0";
        }
    }
    
    chapterIdx++;
    
    //当前的课程章节
    CoursePackModel *course = self.coursePackArray[courseIdx];
    NSUInteger chapterCount = course.coursePackChapters.count;
    
    if (chapterIdx >= chapterCount)
    {
        courseIdx++; //最后一个章节的最后一个视频
        if (courseIdx >= courseCount)
        {
            [self dismissMediaPlayer:nil];
            return;
        }
        
        CoursePackModel *course    = self.coursePackArray[courseIdx];
        CoursePackChapter *chapter = [course.coursePackChapters firstObject];
        chapter.isSelect           = @"1";
        [self getVideoDetailWithId:chapter.video_id];
    }
    else
    {
        CoursePackChapter *chapter = course.coursePackChapters[chapterIdx];
        chapter.isSelect           = @"1";
        [self getVideoDetailWithId:chapter.video_id];
    }
}

- (void)playNextChapterOfCourseOrSop {
    if (self.type == MeidaPlayTypeVideo) return;
    //    if (self.isTask) return;
    if (self.comeFromCacheFile)
    {
        [self dismissMediaPlayer:nil];
        return;
    }
    
    if (self.type == MeidaPlayTypeCourse)
    {
        NSUInteger count        = self.courseDetail.chapters.count;
        NSUInteger currentIndex = [self.courseDetail.chapters indexOfObject:self.chapter];
        currentIndex++;
        if (currentIndex >= count) return;
        
        self.chapter = self.courseDetail.chapters[currentIndex];
    }
    else if (self.type == MeidaPlayTypeSOP)
    {
        NSUInteger courseCount = self.sopDetail.sopCourse.count;
        
        NSUInteger courseIdx  = 0;
        NSUInteger chapterIdx = 0;
        
        BOOL stop = NO;
        for (int i = 0; i < self.sopDetail.sopCourse.count; i++)
        {
            //当前第几个教程
            courseIdx              = i;
            SopCourseModel *course = self.sopDetail.sopCourse[i];
            for (int j = 0; j < course.chapters.count; j++)
            {
                chapterIdx         = j;
                ChapterModel *chap = course.chapters[j];
                if ([self.chapter isEqual:chap])
                {
                    stop = YES;
                    break;
                }
            }
            if (stop) break;
        }
        
        chapterIdx++;
        
        //当前的教程
        SopCourseModel *course  = self.sopDetail.sopCourse[courseIdx];
        NSUInteger chapterCount = course.chapters.count;
        
        if (chapterIdx >= chapterCount)
        {
            courseIdx++; //最后一个教程的最后一个章节
            if (courseIdx >= courseCount) return;
            
            SopCourseModel *course = self.sopDetail.sopCourse[courseIdx];
            ChapterModel *chapter  = [course.chapters firstObject];
            self.chapter           = chapter;
        }
        else
        {
            ChapterModel *chapter = course.chapters[chapterIdx];
            self.chapter          = chapter;
        }
    }
}

#pragma mark Install Movie Notifications
- (void)initPlayerWith:(id)urlString {
#ifdef DEBUG
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
    [IJKFFMoviePlayerController setLogReport:NO];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
    
    [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    
    NSURL *url;
    if ([urlString isKindOfClass:[NSString class]])
    {
        url = [NSURL URLWithString:urlString];
    }
    else if ([urlString isKindOfClass:[NSURL class]])
    {
        url = urlString;
    }
    
    self.player                       = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.player.view.frame            = self.view.bounds;
    self.player.scalingMode           = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay        = NO;
    
    self.view.autoresizesSubviews = YES;
    [self.view insertSubview:self.player.view belowSubview:self.mediaControl];
    
    self.mediaControl.mediaPlayer = self.player;
    
    [self.player prepareToPlay];
    
    if (self.previewTips)
    {
        self.mediaControl.playtipsButton.hidden = NO;
    }else
    {
        self.mediaControl.playtipsButton.hidden = YES;
    }
}

- (void)showAlertWith:(NSTimeInterval)duratin userAnswer:(UserAnswer *)answer logId:(NSString *)logId {
    if (!self.player) return;
    
    if (duratin > 0)
    {
        //提示是否断点播放
        NSString *dateString = [NSDate dateWithTimeInterval:duratin format:@"mm:ss"];
        NSString *message    = [NSString stringWithFormat:@"上次考核到%@,是否继续考核？", dateString];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:message cancelButtonTitle:nil otherButtonTitles:@[ @"重新开始", @"继续考核" ]];
        
        [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1)
            {
                self.userAnswer = answer;
                [self.player play];
                [self.player setCurrentPlaybackTime:duratin];
                self.breakpointPlay = YES;
                
                self.logId = logId;
                
                [self.viewTimer resumeTimer];
            }
            else
            {
                [self.player play];
                
                //开始统计
                [self studyLogStart];
                
                [self.viewTimer resumeTimer];
            }
            
        }];
    }//没有播放记录
    else
    { //直接播放
        [self.player play];
        //开始统计
        [self studyLogStart];
        [self.viewTimer resumeTimer];
    }
}

- (void)destoryPlayer {
    [self.player stop];
    [self.player shutdown];
    self.player = nil;
}

- (void)destoryTimer {
    [self.timer invalidate];
    self.timer = nil;
    
    if(_previewTimer)
    {
        [self.previewTimer invalidate];
        self.previewTimer = nil;
    }
    
    [self.logTimer invalidate];
    self.logTimer = nil;
    
    [self destoryViewTimer];
}

- (void)destoryViewTimer {
    [self.viewTimer invalidate];
    self.viewTimer = nil;
}

- (void)installMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    
    //选集通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectViewDidClick:) name:@"MediaDidSelectChapter" object:nil];
    
    //课程选集通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(CoursePackSelectViewDidClick:) name:@"MediaDidSelectCoursePackModel" object:nil];
    
    //应用进入后台、进入前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //帐号登录异常通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountLoginError:) name:ACCOUNTLOGINERROR object:nil];
}

- (void)loadStateDidChange:(NSNotification *)notification {
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0)
    {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStatePlaythroughOK: %d\n", (int)loadState);
        [self.mediaControl hideIndicator];
        [self.viewTimer resumeTimer];
        if (self.isTask && !self.isChapterPass)
        {
            [self.timer resumeTimer];
        }
        
    }
    else if ((loadState & IJKMPMovieLoadStateStalled) != 0)
    {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        [self.mediaControl showIndicator];
        self.status = MediaPlayStatusCache;
        
        if (self.isTask && !self.isChapterPass)
        {
            [self.timer pauseTimer];
        }
    }
    else
    {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
        [self.mediaControl hideIndicator];
    }
}

- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            self.status = MediaPlayStatusFinish;
            [self videoPlayEnd];
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackError: %d\n", reason);
            break;
            
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification *)notification {
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
    
    //章节未通过
    if (self.isTask && !self.isChapterPass)
    { //如果当前是考核任务，则查看数据库中有没有记录上次播放时间
        __weak typeof(self) weakSelf = self;
        
        [DataCacheTool playDurationInfoWithChapterId:self.chapter.chapterId find:^(NSTimeInterval duration, UserAnswer *answer, NSString *logId) {
            
            if(!self.mediaControl.changeDefinition)
            {
                [weakSelf showAlertWith:duration userAnswer:answer logId:logId];
            }else
            {
                [self.player play];
            }
        }];
        
    }//章节通过的，直接播放学习
    else if (self.isTask && self.isChapterPass)
    {
        [self.player play];
    }
    else
    { //非任务直接播放
        [self.player play];
        //请求播放记录
        [self studyLogStart];
    }
    
    [self.mediaControl hideIndicator];
    
    if (self.isTask)
    {
        //获取开始播放的时间戳
        NSDate *date   = [NSDate dateWithTimeIntervalSinceNow:0];
        long timeStack = [date timeIntervalSince1970];
        self.startTime = [NSString stringWithFormat:@"%lu", timeStack];
    }
}

#pragma mark - 进入后台和进入前台
//进入后台
- (void)applicationDidEnterBackground {
    
    if (self.status == MediaPlayStatusFinish) return;
    
    [self.player pause];
    
}

//进入前台
- (void)applicationDidEnterForeground {
    
    if (self.status == MediaPlayStatusFinish) return;
    
    if (self.status == MediaPlayStatusPause) return;
    
    [self.player play];
}

#pragma mark - 学习统计
- (void)studyLogStart {
    //不需要上传日志，则返回
    if (!self.needToUploadLog) return;
    
    User *user = [AppManager sharedManager].user;
    //用户未登录
    if (!user) return;
    
    NSString *taskId;
    NSString *goodsId;
    NSString *courseId;
    NSString *chapterId;
    int goodsType = 0;
    
    if (self.type == MeidaPlayTypeVideo)
    {
        taskId    = @"";
        goodsId   = self.videoDetail.id;
        courseId  = @"";
        chapterId = @"";
        goodsType = (int)self.type + 1;
    }
    else if (self.type == MeidaPlayTypeCourse)
    {
        taskId    = self.courseDetail.taskId;
        goodsId   = self.courseDetail.courseId;
        courseId  = @"";
        chapterId = self.chapter.chapterId;
        goodsType = (int)self.type + 1;
    }
    else if (self.type == MeidaPlayTypeSOP)
    {
        taskId                 = self.sopDetail.taskId;
        goodsId                = self.sopDetail.id;
        SopCourseModel *course = [self getSopCourseWithChapter:self.chapter];
        courseId               = course.courseId;
        chapterId              = self.chapter.chapterId;
        goodsType              = (int)self.type + 1;
    }
    
    [StudyLogTool startStudyLog:goodsId goodsType:goodsType courseId:courseId chapterId:chapterId lastLogId:self.logId taskId:taskId success:^(NSString *logId) {
        
        self.logId = logId;
        
    }failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}

- (void)studyLogExit {
    
    //不需要上传日志，则返回
    if (!self.needToUploadLog) return;
    if (!self.logId) return;
    
    User *user = [AppManager sharedManager].user;
    //用户未登录
    if (!user) return;
    
    NSTimeInterval videoTimeSpot = self.mediaControl.videoTimeSpot;
    
    [StudyLogTool exitLogWiht:self.logId viewTime:self.viewTime videoTimeSpot:videoTimeSpot success:^{
        
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)studyLogEnd {
    
    //不需要上传日志，则返回
    if (!self.needToUploadLog) return;
    if (!self.logId) return;
    
    User *user = [AppManager sharedManager].user;
    //用户未登录
    if (!user) return;
    
    NSTimeInterval videoTimeSpot = self.mediaControl.videoTimeSpot;
    
    [StudyLogTool endStudyLogWith:self.logId breakPointPlay:self.breakpointPlay viewTime:self.viewTime videoTimeSpot:videoTimeSpot success:^{
        
        NSLog(@"上传");
        
    }failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        
    }];
}

- (void)moviePlayBackStateDidChange:(NSNotification *)notification {
    //    MPMoviePlaybackStateStopped,
    //    MPMoviePlaybackStatePlaying,
    //    MPMoviePlaybackStatePaused,
    //    MPMoviePlaybackStateInterrupted,
    //    MPMoviePlaybackStateSeekingForward,
    //    MPMoviePlaybackStateSeekingBackward
    
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped:
        {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: stoped", (int)_player.playbackState);
            break;
        }
        case IJKMPMoviePlaybackStatePlaying:
        {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: playing", (int)_player.playbackState);
            [self.mediaControl hideIndicator];
            self.mediaControl.changeL.hidden = YES;
            self.status = MediaPlayStatusPlay;
            
            [self.viewTimer resumeTimer];
            
            break;
        }
        case IJKMPMoviePlaybackStatePaused:
        {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            self.status = MediaPlayStatusPause;
            
            [self.viewTimer pauseTimer];
            
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted:
        {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
            [self.viewTimer pauseTimer];
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward:
        {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: seeking", (int)_player.playbackState);
            break;
        }
        default:
        {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: unknown", (int)_player.playbackState);
            break;
        }
    }
}

#pragma mark - 选集通知
- (void)selectViewDidClick:(NSNotification *)noti {
    ChapterModel *chapter = noti.object;
    
    if (self.isTask)
    {
        //判断当前章节是否可做
        if (!chapter.cando) return;
    }
    
    [self studyLogExit];
    
    self.chapter = chapter;
    
    if (!self.isTask)
    {
        if (_previewTimer)
        {
            _previewTimer = nil;
        }
        [self.previewTimer resumeTimer];
    }
}

#pragma mark - 课程选集通知
- (void)CoursePackSelectViewDidClick:(NSNotification *)noti {
    CoursePackChapter *model = noti.object;
    [self getVideoDetailWithId:model.video_id];
}

-(void)setActivityId:(NSString *)activityId
{
    _activityId = activityId;
}
- (void)getVideoDetailWithId:(NSString *)idStr {
    [VideoDetail videoDetailWithUserId:[AppManager sharedManager].user.uid userType:[AppManager sharedManager].user.userType action:@"detail" videoId:idStr activityId:self.activityId fromeCache:YES success:^(VideoDetail *videoDetail) {
        
        //不是从活动进来的视频，要检查权限
        if (!self.isActivity)
        {
            [self setPreviewAuthorityWithVideoDetail:videoDetail];
        }
        videoDetail.changeHD = _videoDetail.changeHD;
        self.videoDetail = videoDetail;
        [self.mediaControl.mediaPlayer play];
        self.mediaControl.indicatorView.hidden = NO;
        
    }
                               failure:^(NSError *error) {
                                   [self showError:error];
                               }];
}

//设置预览权限
- (void)setPreviewAuthorityWithVideoDetail:(VideoDetail *)videoDetail {
    int extra_permission = videoDetail.extra_permission;
    ;
    BOOL isMember = videoDetail.isMember;
    int buy       = videoDetail.buy;
    //--当前资源的额外权限限制，0--无，1--属于会员套餐，2--无需登录即可播放的资源
    if (extra_permission != 2)
    {
        if ([AppManager hasLogin])
        {
            if (extra_permission == 1)
            {
                if (isMember)
                {
                    //播放
                }
                else
                {
                    self.preview     = YES;
                    self.previewTips = @"2分钟预览已结束，观看全部课程请联系医院培训负责人开通平台套餐。";;
                }
            }
            else if (extra_permission == 0)
            {
                // 0表示不需要购买，1表示需要购买，2表示申请购买中，3表示已购买
                if (buy == 1 || buy == 2)
                {
                    self.preview     = YES;
                    self.previewTips = @"2分钟预览已结束，观看全部课程请联系医院培训负责人开通平台套餐。";
                }
                else
                {
                    //直接播放
                }
            }
            
        } //未登录
        else
        {
            self.preview     = YES;
            self.previewTips = @"本视频需登录后才能观看!";
        }
        
    } //无需登录即可播放的资源
    else
    {
        //直接播放
    }
}


#pragma mark - 帐号登录异常通知
- (void)accountLoginError:(NSNotification *)noti {
    [self dismissMediaPlayer:nil];
}

#pragma mark Remove Movie Notification Handlers
- (void)removeMovieNotificationObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:_player];
    //移除当前控制器的通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private
- (void)videoPlayEnd {
    
    //上传播放完成
    [self studyLogEnd];
    
    if (self.isTask)
    {
        [DataCacheTool deletePlayDurationWithChapterId:self.chapter.chapterId];
        
        //销毁定时器
        [self destoryTimer];
        
        if (self.isChapterPass)
        {
            //当最后一个视频播放完毕时回到课程详情页。
            if ([self isLastChapterOrVideo])
            {
                [self dismissMediaPlayer:nil];
                return;
            }
            
            [self playNextChapterOfCourseOrSop];
        }
        else
        {
            [self commitAnswer];
        }
    }
    else if (self.coursePackArray.count > 0)
    {
        [self playNextCourseChapter];
    }
    else
    { //播放下一集
        
        //当最后一个视频播放完毕时回到课程详情页。
        if ([self isLastChapterOrVideo])
        {
            [self dismissMediaPlayer:nil];
            return;
        }
        
        [self playNextChapterOfCourseOrSop];
    }
    
    self.breakpointPlay = NO;
}

//判断是否是最后一个章节或者是视频
- (BOOL)isLastChapterOrVideo {
    
    if (self.sopDetail)
    {
        SopCourseModel *course = [self.sopDetail.sopCourse lastObject];
        ChapterModel *lastChapter = [course.chapters lastObject];
        
        if ([self.chapter isEqual:lastChapter]) return YES;
        
    }
    else if(self.courseDetail)
    {
        ChapterModel *lastChapter = [self.courseDetail.chapters lastObject];
        
        if ([self.chapter isEqual:lastChapter]) return YES;
        
    }
    else if (self.videoDetail)
    {
        return YES;
    }else if (self.doctorHealthDetail)
    {
        return YES;
    }

    
    return NO;
}

- (void)commitAnswer {
    NSString *taskId = self.courseDetail ? self.courseDetail.taskId : self.sopDetail.taskId;
    
    NSString *courseId;
    if (self.type == MeidaPlayTypeCourse)
    {
        courseId = self.courseDetail.courseId;
    }
    else if (self.type == MeidaPlayTypeSOP)
    {
        SopCourseModel *sopCourse = [self getSopCourseWithChapter:self.chapter];
        courseId                  = sopCourse.courseId;
    }
    
    __weak typeof(self) weakSelf = self;
    
    //testResult答案，itemID题号，joinTime：完成时间，paperID,试卷的ID
    [Question submitAnswerWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] testResult:self.userAnswer.answerId itemId:self.userAnswer.itemId joinTime:self.userAnswer.finishTimeString paperId:self.userAnswer.paperId task_id:taskId taskType:(int)self.type chapter_id:self.chapter.chapterId course_id:courseId startTime:self.startTime logId:self.logId success:^(SCBModel *model) {
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        BOOL pass      = [model.data[@"coursePassed"] boolValue];
        NSString *rate = model.data[@"rate"];
        
        if (pass)
        {
            //设置章节通过
            strongSelf.chapter.passStatus = YES;
            
            if (strongSelf.type == MeidaPlayTypeSOP)
            {
                SopCourseModel *course     = [strongSelf getSopCourseWithChapter:strongSelf.chapter];
                SopCourseModel *lastCourse = [strongSelf.sopDetail.sopCourse lastObject];
                ChapterModel *lastChapter  = [course.chapters lastObject];
                
                BOOL lastSOPCourse          = [course isEqual:lastCourse];
                BOOL lastChapterInSopCourse = [strongSelf.chapter isEqual:lastChapter];
                
                if (!lastChapterInSopCourse)
                {
                    NSString *message = [NSString stringWithFormat:@"保存成功,正确率:%@%%,考试结果:通过 是否播放下一章节？", rate];
                    [PaperAlertView showInView:strongSelf.view message:message With:AlertViewTypePass usingBlock:^(PaperAlertView *alertView, NSInteger buttonIndex) {
                        
                        //播放下一章节
                        if (buttonIndex == 1)
                        {
                            [strongSelf playNextChapter:NO];
                            
                            //重播
                        }
                        else if (buttonIndex == 0)
                        {
                            [strongSelf replayCurrentVideo];
                            
                            //关闭
                        }
                        else if (buttonIndex == 2)
                        {
                            [strongSelf dismissMediaPlayer:nil];
                        }
                        
                        [alertView removeFromSuperview];
                    }];
                }
                else if (!lastSOPCourse && lastChapterInSopCourse)
                {
                    NSString *message = [NSString stringWithFormat:@"保存成功,正确率:%@%%,考试结果:通过 是否播放下一教程？", rate];
                    [PaperAlertView showInView:strongSelf.view message:message With:AlertViewTypePass usingBlock:^(PaperAlertView *alertView, NSInteger buttonIndex) {
                        
                        //播放下一教程
                        if (buttonIndex == 1)
                        {
                            [strongSelf playNextChapter:YES];
                            
                            //重播
                        }
                        else if (buttonIndex == 0)
                        {
                            [strongSelf replayCurrentVideo];
                            
                            //关闭
                        }
                        else if (buttonIndex == 2)
                        {
                            [strongSelf dismissMediaPlayer:nil];
                        }
                        
                        [alertView removeFromSuperview];
                        
                    }];
                }
                else if (lastSOPCourse && lastChapterInSopCourse)
                {
                    NSString *message = [NSString stringWithFormat:@"保存成功,正确率:%@%%,考核结果:通过", rate];
                    
                    [PaperAlertView showInView:strongSelf.view message:message With:AlertViewTypeUnPass usingBlock:^(PaperAlertView *alertView, NSInteger buttonIndex) {
                        
                        //重播
                        if (buttonIndex == 0)
                        {
                            [strongSelf replayCurrentVideo];
                            
                            //关闭
                        }
                        else if (buttonIndex == 1)
                        {
                            [strongSelf dismissMediaPlayer:nil];
                        }
                        
                        [alertView removeFromSuperview];
                    }];
                }
            }
            else if (self.type == MeidaPlayTypeCourse)
            {
                ChapterModel *lastChapter = [strongSelf.courseDetail.chapters lastObject];
                BOOL lastChapterInCourse  = [strongSelf.chapter isEqual:lastChapter];
                
                if (!lastChapterInCourse)
                {
                    NSString *message = [NSString stringWithFormat:@"保存成功,正确率:%@%%,考试结果:通过 是否播放下一章节？", rate];
                    [PaperAlertView showInView:self.view message:message With:AlertViewTypePass usingBlock:^(PaperAlertView *alertView, NSInteger buttonIndex) {
                        
                        //播放下一章节
                        if (buttonIndex == 1)
                        {
                            [strongSelf playNextChapter:NO];
                            
                            //重播
                        }
                        else if (buttonIndex == 0)
                        {
                            [strongSelf replayCurrentVideo];
                            
                            //关闭
                        }
                        else if (buttonIndex == 2)
                        {
                            [strongSelf dismissMediaPlayer:nil];
                        }
                        
                        [alertView removeFromSuperview];
                        
                    }];
                }
                else
                {
                    NSString *message = [NSString stringWithFormat:@"保存成功,正确率:%@%%,考试结果:通过", rate];
                    [PaperAlertView showInView:strongSelf.view message:message With:AlertViewTypeUnPass usingBlock:^(PaperAlertView *alertView, NSInteger buttonIndex) {
                        
                        //重播
                        if (buttonIndex == 0)
                        {
                            [strongSelf replayCurrentVideo];
                            
                            //关闭
                        }
                        else if (buttonIndex == 1)
                        {
                            [strongSelf dismissMediaPlayer:nil];
                        }
                        
                        [alertView removeFromSuperview];
                        
                    }];
                }
            }
        }
        else
        {
            NSString *message = [NSString stringWithFormat:@"保存成功,正确率:%@%%,考试结果:不通过", rate];
            [PaperAlertView showInView:strongSelf.view message:message With:AlertViewTypeUnPass usingBlock:^(PaperAlertView *alertView, NSInteger buttonIndex) {
                
                //重播
                if (buttonIndex == 0)
                {
                    [strongSelf replayCurrentVideo];
                    
                    //关闭
                }
                else if (buttonIndex == 1)
                {
                    [strongSelf dismissMediaPlayer:nil];
                }
                
                [alertView removeFromSuperview];
                
            }];
        }
        
        strongSelf.userAnswer = nil;
        
    } failure:^(NSError *error) {
        
        NSLog(@"%@", error);
        [self showError:error];
        //播放sop时断网保存数据退出播放，有网络的时候再次进入断点继续
        [self savePlayDuration];
        [self dismissMediaPlayer:nil];
        
        self.userAnswer = nil;
        
    }];
    
}

- (SopCourseModel *)getSopCourseWithChapter:(ChapterModel *)chapter {
    for (SopCourseModel *sopCourse in self.sopDetail.sopCourse)
    {
        for (ChapterModel *chapter in sopCourse.chapters)
        {
            if ([self.chapter.chapterId isEqualToString:chapter.chapterId])
            {
                return sopCourse;
            }
        }
    }
    
    return nil;
}

//播放下一章节
- (void)playNextChapter:(BOOL)nextCourse {
    if (self.type == MeidaPlayTypeSOP)
    {
        if (nextCourse)
        {
            SopCourseModel *currentCourse = [self getSopCourseWithChapter:self.chapter];
            for (int i = 0; i < self.sopDetail.sopCourse.count; i++)
            {
                SopCourseModel *sopCourse = self.sopDetail.sopCourse[i];
                if ([sopCourse isEqual:currentCourse])
                {
                    i++;
                    SopCourseModel *nextCourse = self.sopDetail.sopCourse[i];
                    ChapterModel *chapter      = [nextCourse.chapters firstObject];
                    self.chapter               = chapter;
                    return;
                }
            }
        }
        else
        {
            SopCourseModel *currentCourse = [self getSopCourseWithChapter:self.chapter];
            for (int i = 0; i < currentCourse.chapters.count; i++)
            {
                ChapterModel *chapter = currentCourse.chapters[i];
                if ([chapter isEqual:self.chapter])
                {
                    i++;
                    ChapterModel *nextChapter = currentCourse.chapters[i];
                    self.chapter              = nextChapter;
                    return;
                }
            }
        }
    }
    else if (self.type == MeidaPlayTypeCourse)
    {
        for (int i = 0; i < self.courseDetail.chapters.count; i++)
        {
            ChapterModel *chapter = self.courseDetail.chapters[i];
            if ([chapter isEqual:self.chapter])
            {
                i++;
                ChapterModel *nextChapter = self.courseDetail.chapters[i];
                self.chapter              = nextChapter;
                return;
            }
        }
    }
}

//重播
- (void)replayCurrentVideo {
    self.chapter = self.chapter;
}

- (NSString *)pathOfVideoCacheFileWith:(VideoDetail *)detail {
    DownloadChapterObject *obect = [VideoCacheDownloadManager downloadObjectWithChpaterId:detail.id];
    
    if (obect.status == DownloadStatusComplete)
    {
        NSFileManager *manager = [NSFileManager defaultManager];
        
        NSString *fileName;
        
        if(detail.isChangeHD)
        {
            fileName = [detail.mp4urlHd lastPathComponent];
        }else
        {
            fileName = [detail.mp4url lastPathComponent];
        }
        
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Videos"];
        filePath           = [filePath stringByAppendingPathComponent:fileName];
        
        if ([manager fileExistsAtPath:filePath])
        {
            self.playCacheFile = YES;
            return filePath;
        }
    }
    
    if(detail.isChangeHD)
    {
        return detail.m3u8Hd?detail.m3u8Hd:detail.m3u8;
    }
    
    self.playCacheFile = NO;
    return detail.m3u8;
}

- (NSString *)pathOfChapterCaheFileWith:(ChapterModel *)chapter {
    DownloadChapterObject *obect = [VideoCacheDownloadManager downloadObjectWithChpaterId:chapter.chapterId];
    
    if (obect.status == DownloadStatusComplete)
    {
        NSFileManager *manager = [NSFileManager defaultManager];
        NSString *fileName;
        
        if(chapter.isChangeHD)
        {
            fileName = [chapter.mp4UrlHd lastPathComponent];
        }else
        {
            fileName = [chapter.mp4Url lastPathComponent];
        }
        
        NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Videos"];
        filePath           = [filePath stringByAppendingPathComponent:fileName];
        
        if ([manager fileExistsAtPath:filePath])
        {
            self.playCacheFile = YES;
            return filePath;
        }
    }
    
    if(chapter.isChangeHD)
    {
        return chapter.m3u8Hd?chapter.m3u8Hd:chapter.m3u8;
    }
    self.playCacheFile = NO;
    return chapter.m3u8;
}

#pragma mark - Getter和Setter
- (MediaControl *)mediaControl {
    if (!_mediaControl)
    {
        _mediaControl       = [MediaControl mediaControl];
        _mediaControl.frame = self.view.bounds;
        [self.view addSubview:_mediaControl];
    }
    return _mediaControl;
}

- (void)setVideoDetail:(VideoDetail *)videoDetail {
    if (!videoDetail) return;
    _videoDetail = videoDetail;
    
    [self destoryPlayer];
    self.type               = MeidaPlayTypeVideo;
    self.mediaControl.title = videoDetail.title;
    self.mediaControl.videoDetail = videoDetail;
    
    if (self.coursePackArray.count == 0)
    {
        self.mediaControl.isVideo = YES;
    }else
    {
        [self.mediaControl canDisableNextButton];
    }
    
    //检查有没有本地缓存文件
    NSString *filePath = [self pathOfVideoCacheFileWith:self.videoDetail];
    
    [self initPlayerWith:filePath];
}

- (void)setCourseDetail:(CourseDetail *)courseDetail {
    if (!courseDetail) return;
    _courseDetail = courseDetail;
    
    self.type = MeidaPlayTypeCourse;
    
    self.mediaControl.courseDetail = self.courseDetail;
    
    if (self.chapter) return;
    
    ChapterModel *chapter = courseDetail.chapters[courseDetail.nextIndex];
    self.chapter          = chapter;
}

- (void)setSopDetail:(SopDetail *)sopDetail {
    if (!sopDetail) return;
    _sopDetail = sopDetail;
    
    self.type = MeidaPlayTypeSOP;
    
    self.mediaControl.sopDetail = self.sopDetail;
    
    if (self.chapter) return;
    
    SopCourseModel *courseModel = sopDetail.sopCourse[sopDetail.courseIndex];
    
    if (courseModel.chapters.count == 0)
    { //第一个教程没有章节，播下一个教程
        [self nextSopCourseWith:sopDetail andIndex:1];
    }
    else
    {
        ChapterModel *chapter = courseModel.chapters[sopDetail.chapterIndex];
        self.chapter          = chapter;
    }
}

-(void)setDoctorHealthDetail:(DoctorsHealthDetail *)doctorHealthDetail
{
    
    if (!doctorHealthDetail)return;
    _doctorHealthDetail = doctorHealthDetail;
    
    self.type               = MeidaPlayTypeVideo;
    self.mediaControl.title = doctorHealthDetail.video_titile;
    self.mediaControl.doctorsHealthDetail = doctorHealthDetail;
    self.mediaControl.isVideo = YES;
    self.mediaControl.comeFromCacheFile = YES;
    
    [self updateViewClick:doctorHealthDetail];
    
    [self initPlayerWith:doctorHealthDetail.video_url];
    
}

-(void)updateViewClick:(DoctorsHealthDetail *)detail{
    
    User *user = [AppManager sharedManager].user;
    
    [StudyLogTool updateViewClickStudyLogWith:detail.des_id userId:user.uid userType:[NSString stringWithFormat:@"%d",user.userType] action:@"updateViewClick" success:^{
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)nextSopCourseWith:(SopDetail *)sopDetail andIndex:(NSInteger)index {
    if (sopDetail.sopCourse.count > index)
    {
        SopCourseModel *courseModel = sopDetail.sopCourse[index];
        if (courseModel.chapters.count == 0)
        { //教程没有章节,寻找下一个教程
            [self nextSopCourseWith:sopDetail andIndex:index + 1];
        }
        else
        {
            ChapterModel *chapter = courseModel.chapters[sopDetail.chapterIndex];
            self.chapter          = chapter;
        }
    }
}

- (void)setChapter:(ChapterModel *)chapter {
    if (!chapter) return;
    
    _chapter = chapter;
    
    [self destoryPlayer];
    
    //停止计时
    [self destoryTimer];
    
    chapter.cando = YES;
    
    self.mediaControl.title   = chapter.name;
    self.mediaControl.chapter = chapter;
    
    //检查有没有本地缓存文件
    NSString *filePath = [self pathOfChapterCaheFileWith:chapter];
    
    [self initPlayerWith:filePath];
    
    //记录试题
    if (!self.isTask) return;
    
    //保存章节通过状态
    self.chapterPass = chapter.passStatus;
    
    self.timeSpotsDic = [NSMutableDictionary dictionary];
    
    for (PaperModel *paper in chapter.papers)
    {
        [self.timeSpotsDic setObject:paper forKey:@(paper.timeSpot)];
    }
}

- (void)setChapterPass:(BOOL)chapterPass {
    _chapterPass = chapterPass;
    
    //章节通过，不弹出试题
    if (!chapterPass)
    {
        [self.timer resumeTimer];
        [self.logTimer resumeTimer];
    }
    
}

- (void)setIsTask:(BOOL)isTask {
    _isTask = isTask;
    
    self.mediaControl.isTask = isTask;
}

- (NSTimer *)timer {
    if (!_timer)
    {
        __unsafe_unretained typeof(self) weakSelf = self;
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:0.5 block:^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            //判断试题弹出的时间
            int currentDuration = (int)strongSelf.player.currentPlaybackTime;
            PaperModel *paper   = strongSelf.timeSpotsDic[@(currentDuration)];
            BOOL showPaper = YES;
            
            for (NSString *idstr in weakSelf.userAnswer.paperIdArr)
            {
                if ([idstr isEqualToString:paper.paperId])
                {
                    showPaper = NO;
                }
            }
            
            if (paper&&showPaper)
            {
                [strongSelf.player pause];
                [strongSelf.timer pauseTimer];
                
                [strongSelf showPaperViewControllerWith:paper];
            }
            
        }
                                                repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        _timer = timer;
    }
    return _timer;
}

- (void)showPaperViewControllerWith:(PaperModel *)paper {
    
    TaskPaperViewController *paperVC = [TaskPaperViewController presentWith:self paperModel:paper];
    
    __unsafe_unretained typeof(self) weakSelf = self;
    
    //试卷的答题情况
    paperVC.CompleteBlock = ^(UserAnswer *userAnswer) {
        
        __strong typeof(weakSelf) strongSelf = self;
        
        strongSelf.userAnswer.paperId          = [NSString stringWithFormat:@"%@,%@", strongSelf.userAnswer.paperId, userAnswer.paperId];
        strongSelf.userAnswer.itemId           = [NSString stringWithFormat:@"%@,%@", strongSelf.userAnswer.itemId, userAnswer.itemId];
        strongSelf.userAnswer.answerId         = [NSString stringWithFormat:@"%@,%@", strongSelf.userAnswer.answerId, userAnswer.answerId];
        strongSelf.userAnswer.finishTimeString = [NSString stringWithFormat:@"%@,%d", strongSelf.userAnswer.finishTimeString, userAnswer.finishTime];
        
        NSLog(@"%@--%@--%@--%@", strongSelf.userAnswer.paperId, strongSelf.userAnswer.itemId, strongSelf.userAnswer.answerId, strongSelf.userAnswer.finishTimeString);
        [strongSelf.userAnswer.paperIdArr addObject:userAnswer.paperId];
        strongSelf.viewTime += userAnswer.finishTime;
        
        //继续播放
        [strongSelf.player play];
        [strongSelf.timer resumeTimerAfterTimeInterval:2];
    };
}

- (void)setPreview:(BOOL)preview {
    _preview = preview;
    
    if (preview)
    {
        [self.previewTimer resumeTimer];
    }
}

- (NSTimer *)previewTimer {
    
    if (!_previewTimer)
    {
        if(self.isHasChapter)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                __unsafe_unretained typeof(self) weakSelf = self;
                
                NSTimer *timer = [NSTimer timerWithTimeInterval:0.5 block:^{
                    
                    __strong typeof(weakSelf) strongSelf = weakSelf;
                    
                    if (strongSelf.player.currentPlaybackTime > 120)
                    {
                        [strongSelf showAlertView];
                    }
                } repeats:YES];
                
                [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
                
                _previewTimer = timer;
            });
        }else
        {
            __unsafe_unretained typeof(self) weakSelf = self;
            
            NSTimer *timer = [NSTimer timerWithTimeInterval:0.5 block:^{
                
                __strong typeof(weakSelf) strongSelf = weakSelf;
                
                if (strongSelf.player.currentPlaybackTime > 120)
                {
                    [strongSelf showAlertView];
                }
            } repeats:YES];
            
            [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
            
            _previewTimer = timer;
        }
        
    }
    
    return _previewTimer;
}

- (NSTimer *)logTimer {
    if (!_logTimer)
    {
        //使用定时器
        __unsafe_unretained typeof(self) weakSelf = self;
        
        NSTimer *timer = [NSTimer timerWithTimeInterval:2.0 block:^{
            
            __strong typeof(weakSelf) strongSelf = weakSelf;
            
            [strongSelf savePlayDuration];
            
        } repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        _logTimer = timer;
    }
    return _logTimer;
}

- (NSTimer *)viewTimer {
    
    if (!_viewTimer)
    {
        self.viewTime = 0;
        
        __unsafe_unretained typeof(self) weakSelf = self;
        
        //使用定时器
        NSTimer *timer = [NSTimer timerWithTimeInterval:1.0 block:^{
            
            __strong typeof(self) strongSelf = weakSelf;
            
            strongSelf.viewTime++;
            
        } repeats:YES];
        
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        
        _viewTimer = timer;
        
    }
    
    return _viewTimer;
}

- (UserAnswer *)userAnswer {
    if (!_userAnswer)
    {
        _userAnswer                  = [UserAnswer new];
        _userAnswer.paperId          = @"";
        _userAnswer.itemId           = @"";
        _userAnswer.answerId         = @"";
        _userAnswer.finishTimeString = @"";
        _userAnswer.paperIdArr = [NSMutableArray array];
    }
    return _userAnswer;
}

- (void)setPlayCacheFile:(BOOL)playCacheFile {
    _playCacheFile = playCacheFile;
    
    if (!playCacheFile)
    {
        [self pauseDownloadTask];
    }
}
-(void)setComeFromCacheFile:(BOOL)comeFromCacheFile
{
    _comeFromCacheFile = comeFromCacheFile;
    self.mediaControl.comeFromCacheFile = comeFromCacheFile;
}
- (void)setCoursePackArray:(NSArray *)coursePackArray {
    _coursePackArray = coursePackArray;
    
    self.mediaControl.coursePackArray = self.coursePackArray;
}

- (void)dealloc {
    [self removeMovieNotificationObservers];
    [self destoryTimer];
    NSLog(@"MediaPlayerController dealloc!");
}

@end
