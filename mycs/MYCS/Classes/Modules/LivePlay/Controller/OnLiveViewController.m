//
//  OnLiveViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/4/20.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "OnLiveViewController.h"
#import "ComfirmView.h"
#import <asl.h>
#import <objc/runtime.h>
#import "LiveMediaControl.h"
#import "MailBoxEditorViewController.h"
#import "LanscapeNaviController.h"
#import "UIAlertView+Block.h"
#import "SRWebSocket.h"
#import "IQKeyboardManager.h"
#import "LiveListModel.h"
#import "ReleaseLiveViewController.h"
#import "LiveNaviViewController.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>
#import <AVFoundation/AVFoundation.h>
#import "LFLiveSession.h"
#import "UMSocialSnsPlatformManager.h"
#import "UMengHelper.h"
#import "SDWebImageDownloader.h"

@interface OnLiveViewController () <SRWebSocketDelegate,LFLiveSessionDelegate>

@property (nonatomic, strong) LiveMediaControl *mediaControl;

@property (nonatomic, strong) LiveMediaShareView *shareView;

@property (nonatomic, strong) SRWebSocket *webSocket;

//中途来电话之类是否在直播中
@property (nonatomic, assign) BOOL hasLiveStart;
@property (nonatomic, strong) CTCallCenter *callCenter;
@property (nonatomic, assign) BOOL isCTCallStateDisconnected;

@property (nonatomic, strong) LFLiveSession *session;
@property (nonatomic, strong) LFLiveVideoConfiguration *videoConfiguration;

@property (nonatomic ,strong) UIImage *shareImage;


@property (nonatomic, strong) LiveDetail *liveDetailModel;
@property (nonatomic, strong) LiveURLModel *liveURLModel;

@end

@implementation OnLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.mediaControl setHidden:NO];
    
    self.hasLiveStart = NO;
    
    [self connectWebSocket];
    
    [self addNotificationCenter];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = YES;
    
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
#pragma mark -- Public Method
- (void)requestAccessForVideo
{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            // 许可对话没有出现，发起授权许可
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                if (granted) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.session setRunning:YES];
                    });
                }
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            // 已经开启授权，可继续
            [self.session setRunning:YES];
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            // 用户明确地拒绝授权，或者相机设备无法访问
            
            break;
        default:
            break;
    }
}

- (void)requestAccessForAudio{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            }];
            break;
        }
        case AVAuthorizationStatusAuthorized:{
            break;
        }
        case AVAuthorizationStatusDenied:
        case AVAuthorizationStatusRestricted:
            break;
        default:
            break;
    }
}

-(void)getPushUrl
{
    [LiveListModel getPushUrl:self.roomId Success:^(LiveURLModel *model) {
        
        self.liveURLModel = model;
        [self startPushLive];

    } Failure:^(NSError *error) {
        [self showError:error];
    }];
}
//修改直播状态
-(void)changeStatus:(NSString *)status
{
    [LiveListModel changeLiveStatusWithRoomId:self.roomId action:@"status" status:status Success:^(SCBModel *model) {
        
    } Failure:^(NSError *error) {
        
    }];
}
-(void)addNotificationCenter
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appResignActive) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(killApplicationWillTerminate) name:UIApplicationWillTerminateNotification object:nil];
    
    // 网络状态监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusChange:) name:@"kReachabilityStatusChange" object:nil];
    

}
-(void)removeNotificationCenter
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillTerminateNotification object:nil];
    //取消网络状态通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"kReachabilityStatusChange" object:nil];
    
}

//直播房间id
-(void)setRoomId:(NSString *)roomId
{
    _roomId = roomId;
}
//获取直播详情
-(void)loadLiveDetail
{
    [LiveListModel requestLiveDetailWithRoomId:self.roomId action:@"detail" Success:^(LiveDetail *model) {
        self.liveDetailModel = model;
        
    } Failure:^(NSError *error) {
        [self showError:error];
    }];
}
-(void)setLiveDetailModel:(LiveDetail *)liveDetailModel
{
    _liveDetailModel = liveDetailModel;
    [self.mediaControl setLiveTitle:liveDetailModel.title];
    [self.mediaControl setViewNumber:[NSString stringWithFormat:@"%d",liveDetailModel.online]];
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setLocale:[NSLocale systemLocale]];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.mediaControl cutdownWithExpireTime:[formater dateFromString:self.liveDetailModel.live_time]];
    [self downloadShareImage:liveDetailModel.img];
}
//直播详情
-(void)setListModel:(LiveListModel *)listModel
{
    if (!listModel)
    {
        [self loadLiveDetail];
        return;
    }
    _listModel = listModel;
    [self.mediaControl setLiveTitle:listModel.title];
    [self.mediaControl setViewNumber:[NSString stringWithFormat:@"%@",listModel.online]];
    
    NSDateFormatter* formater = [[NSDateFormatter alloc] init];
    [formater setLocale:[NSLocale systemLocale]];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [self.mediaControl cutdownWithExpireTime:[formater dateFromString:self.listModel.live_time]];
    [self downloadShareImage:listModel.img];
}
-(void)downloadShareImage:(NSString *)url
{
    [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:SDWebImageDownloaderUseNSURLCache progress:nil completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished){
        self.shareImage = image;
    }];
}
//播放器各种回调
#pragma mark - Action
- (void)setMediaControlAction {
    __weak typeof(self) weakSelf = self;

    //退出
    self.mediaControl.backBlock = ^(LiveMediaControl *view, UIButton *button) {
       dispatch_async(dispatch_get_main_queue(), ^{
           [weakSelf quiteAction:nil];
       });
    };
    //摄像头
    self.mediaControl.changeCameraBlock = ^(LiveMediaControl *view, UIButton *button) {
        [weakSelf changeCameraAction:nil];
    };
    //分享
    self.mediaControl.shareBlock = ^(LiveMediaControl *view, UIButton *button) {
        [weakSelf showShareView];
    };
    //隐藏分享
    self.mediaControl.touchBlock = ^(LiveMediaControl *view) {
        [weakSelf dissmissShareView];
    };
    //通知
    self.mediaControl.notiBlock = ^(LiveMediaControl *view, UIButton *button) {
        [weakSelf presentNotiVC];
    };
    //编辑直播
    self.mediaControl.editBlock = ^(LiveMediaControl *view) {
        
        [weakSelf.mediaControl removeNotificationCenter];
        ReleaseLiveViewController *releaseVC = [[UIStoryboard storyboardWithName:@"Live" bundle:nil] instantiateViewControllerWithIdentifier:@"ReleaseLiveViewController"];
        releaseVC.roomId = weakSelf.roomId;
        releaseVC.IsHorizontal = YES;
        releaseVC.title = @"修改直播";
        releaseVC.releaseButtonBlock = ^(){
            if (weakSelf.sureButtonBlock)
            {
                weakSelf.sureButtonBlock();
            }
        };
        LiveNaviViewController *na = [[LiveNaviViewController alloc] initWithRootViewController:releaseVC];
        [weakSelf presentViewController:na animated:YES completion:nil];
        
    };
    //删除直播
    self.mediaControl.removeBlock = ^(LiveMediaControl *view) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定要删除吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {

            //确定
            if (1 == buttonIndex)
            {
                [LiveListModel deleteLiveDetailWithRoomId:weakSelf.roomId action:@"del" Success:^(SCBModel *model) {
                    [weakSelf showSuccessWithStatusHUD:@"删除成功！"];
                    if (weakSelf.sureButtonBlock)
                    {
                        weakSelf.sureButtonBlock();
                    }
                    [weakSelf destroySession];
                    [weakSelf dismissViewControllerAnimated:YES completion:nil];
                    
                } Failure:^(NSError *error) {
                    [weakSelf showError:error];
                }];
            }

        }];
    };
   //禁言
    self.mediaControl.chatNameClickBlock = ^(LiveMediaControl *view, ChatUserModel *linkData) {
        __block ChatUserModel *user = linkData;
        
        ModelComfirm *model1 = [ModelComfirm comfirmModelWith:@"禁言" titleColor:HEXRGB(0x333333) fontSize:16];

        NSArray *sourceArray = @[ model1 ];

        [ComfirmView showInView:weakSelf.navigationController.view cancelItemWith:nil dataSource:sourceArray actionBlock:^(ComfirmView *view, NSInteger index) {

            if (index == 0)
            {
               [LiveListModel silentWith:user.userid and:weakSelf.listModel.pk Success:^(SCBModel *model) {
                   
                   [weakSelf showSuccessWithStatusHUD:[NSString stringWithFormat:@"对%@禁言成功！",user.name]];
                   
               } Failure:^(NSError *error)
                {
                   [weakSelf showSuccessWithStatusHUD:[NSString stringWithFormat:@"对%@禁言成功！",user.name]];
               }];
            }

        }];

    };
    //开始直播推流
    self.mediaControl.startBlock = ^(LiveMediaControl *view, UIButton *button) {

        if (!weakSelf.hasLiveStart)
        {
            [weakSelf getPushUrl];
        }
        else
        {
            [weakSelf quiteAction:nil];
        }

    };
    //发送聊天
    self.mediaControl.sendBlock = ^(LiveMediaControl *view, NSString *content) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [weakSelf.webSocket send:[content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
#pragma clang diagnostic pop
    };
}
/**
 *
 *  通知
 */
- (void)presentNotiVC
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mailbox" bundle:nil];
    MailBoxEditorViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MailBoxEditorViewController"];
    controller.sendType = 0;
    controller.IsHorizontal = YES;
    controller.titleContent = [NSString stringWithFormat:@"直播通知：%@",self.listModel.title];
    controller.content = [NSString stringWithFormat:@"%@医院%@科室的%@ 现定于%@进行主题为《%@》的直播活动。\n敬请观看",self.listModel.realname,self.listModel.cate_str,self.listModel.anchor,self.listModel.live_time,self.listModel.title];
    LiveNaviViewController *na = [[LiveNaviViewController alloc] initWithRootViewController:controller];
    [self presentViewController:na animated:YES completion:nil];
}
//分享
- (void)showShareView
{
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
//移除分享
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
//退出直播
- (void)quiteAction:(UIButton *)sender
{
    //如果还没有开始直播直接退出
    if (!self.hasLiveStart)
    {
        [self.webSocket close];
        [self destroySession];
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }

    //显示退出界面
    ModelComfirm *model = [ModelComfirm comfirmModelWith:@"结束直播" titleColor:HEXRGB(0x333333) fontSize:16];
    [self.mediaControl cancelCutdownTime];
    NSArray *sourceArray = @[ model ];
    
    [ComfirmView showInView:self.navigationController.view cancelItemWith:nil dataSource:sourceArray actionBlock:^(ComfirmView *view, NSInteger index) {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        [self.webSocket send:[@"直播到此结束了，谢谢大家观看！" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
#pragma clang diagnostic pop

        [self.webSocket close];
        [self destroySession];
        [self showLoadingHUD];
        [LiveListModel changeLiveStatusWithRoomId:self.roomId action:@"status" status:@"stop" Success:^(SCBModel *model) {
            self.sureButtonBlock();
            [self dismissLoadingHUD];
            [self dismissViewControllerAnimated:YES completion:nil];
        } Failure:^(NSError *error) {
            [self dismissLoadingHUD];
            [self dismissViewControllerAnimated:YES completion:nil];
        }];

    }];
}
//摄像头转换
- (void)changeCameraAction:(id)sender {
    
    AVCaptureDevicePosition devicePositon = self.session.captureDevicePosition;
    self.session.captureDevicePosition = (devicePositon == AVCaptureDevicePositionBack) ? AVCaptureDevicePositionFront : AVCaptureDevicePositionBack;
}
//杀死进程通知
-(void)killApplicationWillTerminate
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self.webSocket send:[@"直播到此结束了，谢谢大家观看！" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
#pragma clang diagnostic pop
    
    [self.webSocket close];
    [self destroySession];
    
    [self changeStatus:@"stop"];
}
//回到后台通知
- (void)appResignActive
{
    if (!self.hasLiveStart)return;
    
    //得到当前应用程序的UIApplication对象
    UIApplication *app = [UIApplication sharedApplication];
    //一个后台任务标识符
    UIBackgroundTaskIdentifier taskID;
    taskID = [app beginBackgroundTaskWithExpirationHandler:^{
        //如果系统觉得我们还是运行了太久，将执行这个程序块，并停止运行应用程序
        [app endBackgroundTask:taskID];
    }];
    //UIBackgroundTaskInvalid表示系统没有为我们提供额外的时候
    if (taskID == UIBackgroundTaskInvalid)return;
     [self.session setRunning:NO];
    
    //告诉系统我们完成了
    [app endBackgroundTask:taskID];
    
    // 监听电话
    _callCenter = [[CTCallCenter alloc] init];
    _isCTCallStateDisconnected = NO;
    _callCenter.callEventHandler = ^(CTCall* call) {
        if ([call.callState isEqualToString:CTCallStateDisconnected])
        {
            _isCTCallStateDisconnected = YES;
        }
        else if([call.callState isEqualToString:CTCallStateConnected])
            
        {
            _callCenter = nil;
        }
    };
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
       [self.webSocket send:[@"暂时离开一下" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
#pragma clang diagnostic pop
 
}
//回到前台通知
- (void)appBecomeActive
{
    if (_isCTCallStateDisconnected) {
        sleep(2);
    }
    if (!self.hasLiveStart)return;

     [self.session setRunning:YES];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [self.webSocket send:[@"直播继续" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
#pragma clang diagnostic pop
    
}
//烧毁推流
- (void)destroySession
{
    if(_session)
    {
        [self.session setRunning:NO];
        [self.session stopLive];
        self.session = nil;
    }
}
//横屏模式
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if(self.IsHorizontal)
    {
        bool bRet = ((toInterfaceOrientation == UIInterfaceOrientationLandscapeRight));
        return bRet;
    }else
    {
        return false;
    }
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if(self.IsHorizontal)
    {
        [self performSelector:@selector(checkVideo) withObject:nil afterDelay:1.5];
        return UIInterfaceOrientationMaskLandscapeRight;
    }else
    {
        return UIInterfaceOrientationMaskPortrait;
    }
}
-(void)checkVideo
{
    [self requestAccessForVideo];
    [self requestAccessForAudio];
}
//推流准备
- (LFLiveSession*)session{
    if(!_session){
   
        LFLiveAudioConfiguration *audioConfiguration = [LFLiveAudioConfiguration new];
        audioConfiguration.numberOfChannels = 1;
        audioConfiguration.audioBitrate = LFLiveAudioBitRate_96Kbps;
        audioConfiguration.audioSampleRate = LFLiveAudioSampleRate_44100Hz;
        
        _videoConfiguration = [LFLiveVideoConfiguration new];
        _videoConfiguration.videoSize = CGSizeMake(960, 540);
        _videoConfiguration.videoBitRate = 800*1024;
        _videoConfiguration.videoMaxBitRate = 1000*1024;
        _videoConfiguration.videoMinBitRate = 500*1024;
        _videoConfiguration.videoFrameRate = 24;
        _videoConfiguration.videoMaxKeyframeInterval = 48;
        _videoConfiguration.sessionPreset = LFCaptureSessionPreset540x960;
        _videoConfiguration.landscape = YES;
        _session = [[LFLiveSession alloc] initWithAudioConfiguration:audioConfiguration videoConfiguration:_videoConfiguration];
    
        _session.captureDevicePosition = AVCaptureDevicePositionBack;
        _session.beautyLevel = 1;
        _session.delegate = self;
        _session.preView = self.mediaControl;
    }
    
    return _session;
}
-(void)startPushLive
{
    LFLiveStreamInfo *stream = [LFLiveStreamInfo new];
    stream.url = self.liveURLModel.up;
    [self.session setRunning:YES];
    [self.session startLive:stream];
}
#pragma mark -- LFLiveSessionDelegate
/** live status changed will callback */
- (void)liveSession:(nullable LFLiveSession *)session liveStateDidChange:(LFLiveState)state{
    NSLog(@"liveStateDidChange: %ld", (unsigned long)state);
    switch (state) {
        case LFLiveReady:
            NSLog(@"RTMP状态: 预览未连接");
            break;
        case LFLivePending:
            NSLog(@"RTMP状态: 连接中...");
            break;
        case LFLiveStart:
            NSLog(@"RTMP状态: 已连接");
            if (!self.hasLiveStart) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
                [self.webSocket send:[@"cn.mycs.www.start" stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
#pragma clang diagnostic pop
                [self.mediaControl startCalculateTime];
                self.hasLiveStart = YES;
                [self changeStatus:@"start"];
            }
            break;
        case LFLiveError:
            NSLog(@"RTMP状态: 错误");
            [self pushError];
            break;
        case LFLiveStop:
            NSLog(@"RTMP状态: 未连接");
            break;
        default:
            break;
    }
}
-(void)pushError
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"直播链接失败！" cancelButtonTitle:@"取消" otherButtonTitle:@"重新链接"];
    [alert showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        if (buttonIndex == 1)
        {
            [self.session setRunning:NO];
            [self.session stopLive];
            self.session = nil;
            if (self.liveURLModel)
            {
                [self startPushLive];
            }else
            {
                [self getPushUrl];
            }
        }
    }];
}
/** live debug info callback */
- (void)liveSession:(nullable LFLiveSession *)session debugInfo:(nullable LFLiveDebug*)debugInfo{
    NSLog(@"debugInfo: %@", debugInfo);
}

/** callback socket errorcode */
- (void)liveSession:(nullable LFLiveSession*)session errorCode:(LFLiveSocketErrorCode)errorCode
{
    NSLog(@"errorCode: %ld", (unsigned long)errorCode);
}

#pragma mark - Notification Handler
- (void)reachabilityStatusChange:(NSNotification *)noti {
    if (!self.hasLiveStart)return;
    
    AFNetworkReachabilityStatus status = [noti.object intValue];

    //网络的情况下自动连接融云服务器
    if (status != AFNetworkReachabilityStatusUnknown && status != AFNetworkReachabilityStatusNotReachable)
    {
        if (self.liveURLModel)
        {
            // 对断网情况做处理
            [self startPushLive];
        }else
        {
            [self getPushUrl];
        }
    }else
    {
        [self.session stopLive];
    }
}

#pragma mark - WebSocket
- (void)connectWebSocket
{
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
    NSLog(@"连接失败：%@", error);
    [self.mediaControl addChatMessage:@"聊天服务器连接失败。。。" Error:YES];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"关闭WebSocket");
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload {
}

- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket {
    return YES;
}

#pragma mark - Getter&Setter

- (LiveMediaControl *)mediaControl {
    if (!_mediaControl)
    {
        _mediaControl = [LiveMediaControl liveMediaControl];
        //设置类型
        _mediaControl.mediaControlType = LiveMediaControlTypeSelf;
        _mediaControl.liveType = AfterMediaLive;
        _mediaControl.roomId = self.roomId;
        
        [_mediaControl.indicatorView removeFromSuperview];
        
        [self.view addSubview:_mediaControl];
        [self.view bringSubviewToFront:_mediaControl];

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

- (void)dealloc {
    
    [self destroySession];
    [self removeNotificationCenter];
   }

@end
