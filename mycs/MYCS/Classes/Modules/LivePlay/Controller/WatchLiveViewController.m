//
//  WatchLiveViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/4/28.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "WatchLiveViewController.h"
#import "LiveMediaControl.h"
#import "IQKeyboardManager.h"
#import "TYTextContainer.h"
#import "AppManager.h"
#import "SRWebSocket.h"
#import "LiveListModel.h"

#import <IJKMediaFramework/IJKMediaFramework.h>

#import "UMSocialSnsPlatformManager.h"
#import "UMengHelper.h"
#import "SDWebImageDownloader.h"

@interface WatchLiveViewController () <SRWebSocketDelegate>

@property (nonatomic, strong) LiveMediaControl *mediaControl;

@property (nonatomic, strong) LiveMediaShareView *shareView;

@property (nonatomic, strong) SRWebSocket *webSocket;

@property (nonatomic, assign) LiveMediaPlayStatus status;

@property (atomic, strong) id<IJKMediaPlayback> player;

@property (nonatomic ,strong) UIImage *shareImage;

@property (nonatomic, strong) LiveURLModel *liveURLModel;

@end

@implementation WatchLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self connectWebSocket];

    [self installMovieNotificationObservers];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [IQKeyboardManager sharedManager].enable            = NO;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.mediaControl addNotificationCenter];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[UIApplication sharedApplication] setStatusBarHidden:NO];

    [IQKeyboardManager sharedManager].enable            = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    [self.mediaControl removeNotificationCenter];
}
#pragma mark - Action
- (void)dismissMediaPlayer:(void(^)())complete {
    [self destoryPlayer];
    
    //移除通知
    [self removeMovieNotificationObservers];
    if (self.mediaControl.liveType == OnMediaLive)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:ChangeLiveStatus object:nil];
    }
    [self.mediaControl removeNotificationCenter];
    [self.mediaControl removeFromSuperview];
    self.mediaControl = nil;
    [self dismissViewControllerAnimated:YES completion:complete];
}
//获取直播详情
-(void)loadLiveDetail
{
    [LiveListModel requestLiveDetailWithRoomId:self.roomId action:@"detail" Success:^(LiveDetail *model) {
        
        if(model.status == 2)
        {
            _mediaControl.liveType = OnMediaLive;
        }
        
    } Failure:^(NSError *error) {
        
    }];
}
-(void)getPushUrl
{
    
    [LiveListModel getPushUrl:self.roomId Success:^(LiveURLModel *model) {
        
        self.liveURLModel = model;
        
        [self initPlayerWith:nil];
        
    } Failure:^(NSError *error) {
        [self showError:error];
    }];
}

//直播房间
-(void)setRoomId:(NSString *)roomId
{
    _roomId = roomId;
    [self getPushUrl];
    
}
//直播状态
-(void)setLiveType:(int)liveType{
    _liveType = liveType;
   
    if (liveType == 1)
    {
        [self loadLiveDetail];
    }
    
    self.view.backgroundColor = [UIColor grayColor];
}

-(void)setListModel:(LiveListModel *)listModel
{
    _listModel = listModel;
    [self.mediaControl setLiveTitle:listModel.title];
    [self.mediaControl setViewNumber:listModel.online];
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setLocale:[NSLocale systemLocale]];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.mediaControl cutdownWithExpireTime:[formater dateFromString:self.listModel.live_time]];
    [self downloadShareImage];
    
}
-(void)downloadShareImage
{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:self.listModel.img] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished){
        self.shareImage = image;
    }];
}

- (void)destoryPlayer {
    [self.player stop];
    [self.player shutdown];
    self.player = nil;
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
    
    if (self.isLiveEnd)
    {
        url = [NSURL URLWithString:@"http://v1.mycs.cn/73/4663/21365/Ozs4OjhyPCY.mp4"];
    }
    else
    {
        url = [NSURL URLWithString:self.liveURLModel.m3u8];
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
    
}

//播放器回调
- (void)setMediaControlAction {
    __weak typeof(self) weakSelf = self;
    //退出
    self.mediaControl.backBlock = ^(LiveMediaControl *view, UIButton *button) {
        [weakSelf.webSocket close];
        [weakSelf dismissMediaPlayer:nil];
    };
    //分享
    self.mediaControl.shareBlock = ^(LiveMediaControl *view, UIButton *button) {
        [weakSelf showShareView];
    };
    //移除分享
    self.mediaControl.touchBlock = ^(LiveMediaControl *view) {
        [weakSelf dissmissShareView];
    };
   //发送聊天
    self.mediaControl.sendBlock = ^(LiveMediaControl *view, NSString *content) {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [weakSelf.webSocket send:[content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
#pragma clang diagnostic pop

    };
    //播放或者暂停
    self.mediaControl.startBlock = ^(LiveMediaControl *view, UIButton *button) {
        
        if (!button.selected)
        {
            [weakSelf.player pause];
        }
        else
        {
            [weakSelf.player play];
        }
        
    };
    
    //滑动条
    self.mediaControl.sliderAction = ^(UISlider *slider) {
        
        [weakSelf.player pause];
        
        [weakSelf.player setCurrentPlaybackTime:slider.value];
        
        [weakSelf.player play];
    };
}

- (void)showShareView {
    LiveMediaShareView *shareView = [LiveMediaShareView shareViewWith:^(UIButton *button) {

        NSString * typeStr;
        if ([button.titleLabel.text isEqualToString:@"微信好友"])
        {
            typeStr = UMShareToWechatSession;
        }else if ([button.titleLabel.text isEqualToString:@"微信朋友圈"])
        {
            typeStr = UMShareToWechatTimeline;
        }else if ([button.titleLabel.text isEqualToString:@"QQ好友"])
        {
            typeStr = UMShareToQQ;
        }else if ([button.titleLabel.text isEqualToString:@"QQ空间"])
        {
            typeStr = UMShareToQzone;
        }
        
        [UMengHelper shareUrlWith:self.shareImage title:self.listModel.title content:self.listModel.detail Url:self.listModel.shareUrl shareType:typeStr];
        
        [self dissmissShareView];

    }];

    self.shareView = shareView;
    [self.view addSubview:shareView];

    CGFloat viewW   = 270;
    shareView.frame = CGRectMake(ScreenW - 270, 0, viewW, ScreenH);

    //添加动画
    shareView.transform = CGAffineTransformTranslate(shareView.transform, viewW, 0);
    [UIView animateWithDuration:0.25 animations:^{
        shareView.transform = CGAffineTransformIdentity;
    }];
    
    UIView *tapView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW- 270, ScreenH)];
    tapView.backgroundColor = [UIColor clearColor];
    tapView.tag = ScreenW;
    tapView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmissShareView)];
    [tapView addGestureRecognizer:tap];
    [self.view addSubview:tapView];
}

- (void)dissmissShareView
{
    UIView *tapView= [self.view viewWithTag:ScreenW];
    [tapView removeFromSuperview];
    if (!self.shareView) return;
    [UIView animateWithDuration:0.25 animations:^{
        self.shareView.transform = CGAffineTransformTranslate(self.shareView.transform, 270, 0);
    }
        completion:^(BOOL finished) {
            [self.shareView removeFromSuperview];
            self.shareView = nil;
        }];
}

#pragma mark - WebSocket
- (void)connectWebSocket {
    self.webSocket.delegate = nil;

    [self.webSocket close];

    NSString *liveId   = self.listModel.pk;
    NSString *userId   = [AppManager sharedManager].user.uid;
    NSString *userName = [AppManager sharedManager].user.realname;

    NSString *urlString = [NSString stringWithFormat:@"ws://192.168.1.13:8080/ws?liveid=%@&name=%@&userid=%@", liveId, userName, userId];
    urlString           = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    NSURL *connectURL = [NSURL URLWithString:urlString];

    NSURLRequest *request = [NSURLRequest requestWithURL:connectURL];

    self.webSocket = [[SRWebSocket alloc] initWithURLRequest:request];

    self.webSocket.delegate = self;

    //打开连接
    [self.webSocket open];
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    if ([message isKindOfClass:[NSString class]])
    {
        NSLog(@"接收到消息：%@", message);
        [self.mediaControl addChatMessage:message  Error:NO];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"WebSocket已连接");
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    
    [self.mediaControl addChatMessage:@"聊天服务器连接失败。。。" Error:YES];
    
//    [self performSelector:@selector(connectWebSocket) withObject:nil afterDelay:5];

}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"关闭WebSocket");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
}

- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket {
    return YES;
}

#pragma mark - Getter & Setter
- (LiveMediaControl *)mediaControl {
    if (!_mediaControl)
    {
        _mediaControl = [LiveMediaControl liveMediaControl];
        //设置类型
        LiveMediaControlType type      = self.isLiveEnd ? LiveMediaControlTypePlayback : LiveMediaControlTypeOther;
        _mediaControl.mediaControlType = type;
        _mediaControl.liveType = self.liveType;
        _mediaControl.roomId = self.roomId;
        
        [self.view addSubview:_mediaControl];

        [self addConstsToMediaControl];
        
        [self setMediaControlAction];
    }
    return _mediaControl;
}

- (void)addConstsToMediaControl {
    self.mediaControl.translatesAutoresizingMaskIntoConstraints = NO;

    UIView *mediaControl = self.mediaControl;

    NSString *hVFL = @"H:|-(0)-[mediaControl]-(0)-|";
    NSString *vVFL = @"V:|-(0)-[mediaControl]-(0)-|";

    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(mediaControl)];

    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(mediaControl)];

    [self.view addConstraints:hConsts];
    [self.view addConstraints:vConsts];
}
- (void)installMovieNotificationObservers
{
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
    
    
    //应用进入后台、进入前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    //帐号登录异常通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(accountLoginError:) name:ACCOUNTLOGINERROR object:nil];
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

#pragma mark - 帐号登录异常通知
- (void)accountLoginError:(NSNotification *)noti
{
    [self dismissMediaPlayer:nil];
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
    }
    else if ((loadState & IJKMPMovieLoadStateStalled) != 0)
    {
        NSLog(@"loadStateDidChange: IJKMPMovieLoadStateStalled: %d\n", (int)loadState);
        [self.mediaControl showIndicator];
        self.status = MediaPlayStatusCache;
        
    }
    else
    {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
        [self.mediaControl hideIndicator];
    }
}
- (void)mediaIsPreparedToPlayDidChange:(NSNotification *)notification {
    NSLog(@"mediaIsPreparedToPlayDidChange\n");
    [self.player play];
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
            self.status = MediaPlayStatusPlay;
            
            break;
        }
        case IJKMPMoviePlaybackStatePaused:
        {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: paused", (int)_player.playbackState);
            self.status = MediaPlayStatusPause;
            
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted:
        {
            NSLog(@"IJKMPMoviePlayBackStateDidChange %d: interrupted", (int)_player.playbackState);
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


#pragma mark - 进入后台和进入前台
//进入后台
- (void)applicationDidEnterBackground {
    
    if (self.status == MediaPlayStatusFinish) return;
    
    [self.player pause];
    
    [self.webSocket close];
}

//进入前台
- (void)applicationDidEnterForeground {
    
    if (self.status == MediaPlayStatusFinish) return;
    
    if (self.status == MediaPlayStatusPause) return;
    
    [self.player play];
    
    [self connectWebSocket];
}


@end
