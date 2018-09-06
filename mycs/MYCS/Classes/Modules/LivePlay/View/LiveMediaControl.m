//
//  LiveMediaControl.m
//  MYCS
//
//  Created by AdminZhiHua on 16/4/21.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "LiveMediaControl.h"
#import "NSString+Size.h"
#import "LivePopUpMenuView.h"
#import "UMengHelper.h"
#import "TYAttributedLabel.h"
#import "MJExtension.h"
#import "NSMutableAttributedString+Attr.h"
#import "NSDate+Util.h"
#import "CBAutoScrollLabel.h"

#import <IJKMediaFramework/IJKMediaFramework.h>
#import "UIView+Message.h"
#import "LiveListModel.h"

#define kTopPanelH 45
#define kBottomPanelH 45
#define kMessageFont [UIFont systemFontOfSize:14]
#define kChatViewW 300

static NSString *const reuseId = @"ChatViewCell";

@interface LiveMediaControl () <UITableViewDelegate, UITableViewDataSource, TYAttributedLabelDelegate,UIGestureRecognizerDelegate>

#pragma mark - topPanel
@property (weak, nonatomic) IBOutlet UIView *topPanel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPanelConstTop;

//观看人数按钮
@property (weak, nonatomic) IBOutlet UIButton *viewsButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewsButtonWidth;

//摄像头转换按钮
@property (weak, nonatomic) IBOutlet LiveMediaTitleButton *cameraButton;
//标题
@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *titleLabel;
//聊天列表按钮
@property (weak, nonatomic) IBOutlet UIButton *chatListButton;

//发送通知按钮
@property (weak, nonatomic) IBOutlet UIButton *notiButton;

//分享按钮
@property (weak, nonatomic) IBOutlet UIButton *shareButton;

//更多按钮
@property (weak, nonatomic) IBOutlet UIButton *moreButton;

//更多按钮到右边的约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreBtnRightConst;

//聊天按钮
@property (weak, nonatomic) IBOutlet UIButton *chatButton;

//锁屏按钮
@property (weak, nonatomic) IBOutlet UIButton *lockScreenButton;

//开始按钮
@property (weak, nonatomic) IBOutlet UIButton *startButton;

#pragma mark - BottomView

@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;


@property (weak, nonatomic) IBOutlet LiveCustomSlider *slider;

@property (weak, nonatomic) IBOutlet UIProgressView *cacheProgress;

@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (weak, nonatomic) IBOutlet UIView *bottomPanel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomPanelConstBottom;

#pragma mark - InputView
@property (weak, nonatomic) IBOutlet UIView *inputView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputViewConstBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cameraLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeading;

//聊天列表
@property (nonatomic, strong) UITableView *chatTableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

#pragma mark - 倒计时
@property (nonatomic, strong) UIView *cutdownView;
//计时Label
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) NSDate *expireDate;

#pragma mark - 直播计时
@property (weak, nonatomic) IBOutlet UIView *bgCoverView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *uptimeLabel;
@property (nonatomic, strong) NSDate *startDate;

//滑动的方向
@property (nonatomic, assign) LivePanDirection panDirection;
//系统声音Slider
@property (nonatomic,weak) UISlider *systemSlider;
//快进时间
@property (nonatomic,assign) CGFloat seekTime;
@end

@implementation LiveMediaControl

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.slider.continuous = NO;
    [self.slider setThumbImage:[UIImage imageNamed:@"play_on"] forState:UIControlStateNormal];
    [self.slider setTintColor:HEXRGB(0x47c1a8)];
    
    self.dataSource = [NSMutableArray array];
    
    [self showAndFade];
    
    self.chatTableView.hidden = NO;
    
    //计时view
    self.timeView.alpha    = 0;
    self.bgCoverView.alpha = 0;
    
    self.viewsButton.clipsToBounds = YES;
    
    [self refreshMediaControl];
}
-(void)addTap
{
    if (_liveType == EndMediaLive)
    {
        [self.slider addTarget:self action:@selector(mediaProgressSliderAction:) forControlEvents:UIControlEventValueChanged];
        [self setSliderTouch];
    }
    
    UIPanGestureRecognizer *panGest = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestAction:)];
    panGest.delegate = self;
    
    [self addGestureRecognizer:panGest];
    
    UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestAction:)];
    tapGest.delegate = self;
    
    [self addGestureRecognizer:tapGest];
    
    UITapGestureRecognizer *tapGest1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestAction:)];
    tapGest1.delegate = self;
    
    [self.topPanel addGestureRecognizer:tapGest1];
    
    UITapGestureRecognizer *tapGest2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestAction:)];
    tapGest2.delegate = self;
    
    [self.bottomPanel addGestureRecognizer:tapGest2];
    
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[LiveCustomSlider class]]){
        
        return NO;
        
    }
    
    return YES;
    
}
//活动手势
- (void)panGestAction:(UIPanGestureRecognizer *)pan {
    
    CGPoint locationPoint = [pan locationInView:self];
    
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    switch (pan.state) {
            
        case UIGestureRecognizerStateBegan:{
            
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            
            if (x > y) { // 水平移动
                self.panDirection = PanDirectionHorizontalMoved;
            }
            else if (x < y){
                if (locationPoint.x > self.bounds.size.width / 2) {
                    self.panDirection = PanDirectionVerticalRightMoved;
                }else {
                    self.panDirection = PanDirectionVerticalLeftMoved;
                }
                
            }
            break;
        }
        case UIGestureRecognizerStateChanged:{
            switch (self.panDirection)
            {
                case PanDirectionHorizontalMoved:{
                    //水平移动
                    [self updateProgress:veloctyPoint.x];
                    break;
                }
                case PanDirectionVerticalLeftMoved:{
                    //左边垂直移动
                    [self configSystemBrightness:veloctyPoint.y];
                    break;
                }
                case PanDirectionVerticalRightMoved:{
                    //右边垂直移动
                    [self configSystemSound:veloctyPoint.y];
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:{
            
            switch (self.panDirection)
            {
                case PanDirectionHorizontalMoved:{
                    //水平移动
                    [self configProgress:veloctyPoint.x];
                    break;
                }
                default:
                    break;
            }
            break;
            
        }
        default:
            break;
    }
    
}
//水平活动改变进度条
- (void)updateProgress:(CGFloat)value {
    
     if (_liveType != EndMediaLive)return;
    
    if (self.isLockScreen)
    {
        [self showLockButton];
        [self hideAndFade];
        [self delayHide];
        return;
    }
    
    [self showAndFade];
    
    [self cancelDelayedRefreshMediaControl];
    
    CGFloat newValue = value / 200;
    
    self.slider.value += newValue;
    self.seekTime = self.slider.value;
}
//调节视频进度
- (void)configProgress:(CGFloat)value
{
    if (_liveType != EndMediaLive)return;
    
    if (self.isLockScreen)
    {
        [self showLockButton];
        [self hideAndFade];
        [self delayHide];
        return;
    }
    
    [self showAndFade];
    
    if (self.sliderAction) {
        self.slider.value = self.seekTime;
        self.sliderAction(self.slider);
    }
    self.seekTime = 0;
    [self refreshMediaControl];
    
}

//音量调节
- (void)configSystemSound:(CGFloat)value
{
    if (!self.isLockScreen)
    {
        [self showAndFade];
        self.lockScreenButton.selected = NO;
        self.systemSlider.value -= value / 10000;// 越小幅度越小
    }
    
}

//亮度
- (void)configSystemBrightness:(CGFloat)value {
    
    if (!self.isLockScreen)
    {
        [self showAndFade];
        self.lockScreenButton.selected = NO;
        [UIScreen mainScreen].brightness -= value / 10000;
    }
    
}

#pragma mark - Getter和Setter
- (UISlider *)systemSlider {
    if (!_systemSlider) {
        
        //关联系统音量
        MPVolumeView *volumeView = [[MPVolumeView alloc] init];
        
        [self addSubview:volumeView];
        
        for (UIView *subView in volumeView.subviews) {
            if ([subView isKindOfClass:[UISlider class]]) {
                _systemSlider = (UISlider *)subView;
            }
        }
        
        _systemSlider.hidden = YES;
        
    }
    return _systemSlider;
}
- (void)cancelDelayedRefreshMediaControl {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
}
//滑动按钮事件
-(void)mediaProgressSliderAction:(LiveCustomSlider *)slider
{
    self.slider.value = slider.value;
    
    if (self.slider.sliderTouch)
    {
        self.slider.sliderTouch();
    }
    
}
- (void)setSliderTouch
{
    self.slider.sliderTouch = ^() {
        
        if (self.sliderAction) self.sliderAction(self.slider);
        
        [self showAndFade];
    };
}

-(void)setLiveType:(LiveMediaType)liveType
{
    _liveType = liveType;
    if (liveType == OnMediaLive)
    {
        [self.cutdownView removeFromSuperview];
    }
    
    if (liveType != EndMediaLive)
    {
        self.indicatorView.alpha = 0;
    }else
    {
        self.indicatorView.hidden = NO;
    }
    
    [self addTap];
}
-(void)setRoomId:(NSString *)roomId
{
    _roomId = roomId;
}
-(void)addNotificationCenter{
    //添加键盘的监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
-(void)removeNotificationCenter
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
}
+ (instancetype)liveMediaControl {
    LiveMediaControl *mediaControl = [[[NSBundle mainBundle] loadNibNamed:@"LiveMediaControl" owner:nil options:nil] firstObject];
    
    return mediaControl;
}

#pragma mark - Control

- (void)showNoFade {
    
    [self show];
}

- (void)showAndFade {
    
    [self showNoFade];
    [self delayHide];
}
-(void)delayHide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    
    [self performSelector:@selector(hide) withObject:nil afterDelay:5];
}
- (void)hide {
    
    self.lockScreenButton.hidden = YES;
    [UIView animateWithDuration:0.25 animations:^{
        
        self.topPanelConstTop.constant = -kTopPanelH;
        self.bottomPanelConstBottom.constant = -kBottomPanelH;
        [self layoutIfNeeded];
        self.chatButton.hidden = YES;
        self.startButton.hidden = YES;
    }];
    self.showControl = NO;
}

- (void)show {
    
    self.lockScreenButton.hidden = NO;
    self.topPanel.hidden = NO;
    self.bottomPanel.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.topPanelConstTop.constant = 0;
        self.bottomPanelConstBottom.constant = 0;
        self.chatButton.hidden = NO;
        self.startButton.hidden = NO;
        [self layoutIfNeeded];
        
    }];
    self.showControl = YES;
    [self refreshMediaControl];
}
-(void)showLockButton
{
    self.lockScreenButton.hidden = NO;
}
-(void)hideAndFade
{
    [UIView animateWithDuration:0.25 animations:^{
        
        self.topPanelConstTop.constant = -kTopPanelH;
        self.bottomPanelConstBottom.constant = -kBottomPanelH;
        [self layoutIfNeeded];
        self.chatButton.hidden = YES;
        self.startButton.hidden = YES;
        
    }];
    self.showControl = NO;
}


- (void)cancelDelayedEvent {
    self.showControl = NO;
}

- (void)refreshMediaControl
{
    //    // duration
    NSTimeInterval duration = self.mediaPlayer.duration;
    NSInteger intDuration = duration + 0.5;
    
    if (intDuration > 0)
    {
        NSInteger totalDuration = duration;
        self.slider.maximumValue = duration;
        self.endTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)(totalDuration / 3600), (int)((totalDuration / 60)%60), (int)(totalDuration % 60)];
    } else
    {
        self.slider.maximumValue = 1.0f;
        self.endTimeLabel.text = @"--:--:--";
    }
    //缓冲的进度
    self.cacheProgress.progress = self.mediaPlayer.playableDuration/duration;
    NSTimeInterval position;
    position = self.mediaPlayer.currentPlaybackTime;
    NSInteger intPosition = position + 0.5;
    if (position > 0) {
        self.slider.value = position;
    } else {
        self.slider.value = 0.0f;
    }
    
    BOOL isPlaying = [self.mediaPlayer isPlaying];
    self.playButton.selected = isPlaying;
    
    self.startTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)(intPosition / 3600), (int)((intPosition / 60)%60), (int)(intPosition % 60)];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    
    if (self.showControl)
    {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
    }
    
}

- (void)showIndicator
{
    self.indicatorView.hidden = NO;
}

- (void)hideIndicator
{
    self.indicatorView.hidden = YES;
}
#pragma mark - Action

- (IBAction)backButtonAction:(UIButton *)button {
    [self showAndFade];
    
    //取消计时
    [self cancelCutdownTime];
    
    if (self.backBlock)
    {
        self.backBlock(self, button);
    }
}

- (IBAction)cameraButtonAction:(UIButton *)button {
    [self showAndFade];
    
    if (self.changeCameraBlock)
    {
        self.changeCameraBlock(self, button);
    }
}

- (IBAction)chatListButtonAction:(UIButton *)button {
    button.selected = !button.selected;
   
    [self showAndFade];
    
    CGFloat alpha = button.selected ? 0 : 1;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.chatTableView.alpha = alpha;
        self.chatButton.alpha = alpha;
        self.chatButton.userInteractionEnabled = !button.selected;
    }];
}

- (IBAction)notiButtonAction:(UIButton *)button {
    [self showAndFade];
    
    if (self.notiBlock)
    {
        self.notiBlock(self, button);
    }
}

- (IBAction)shareButton:(UIButton *)button {
    if (self.shareBlock)
    {
        self.shareBlock(self, button);
    }
}

- (void)tapGestAction:(UITapGestureRecognizer *)tap
{
    [self.inputTextField resignFirstResponder];
    [self bringSubviewToFront:self.topPanel];
    
    if (tap.view.tag >=1 )
    {
        [self showAndFade];
        
        return;
    }
    if (self.isLockScreen)
    {
        [self showLockButton];
        [self hideAndFade];
        [self delayHide];
        return;
    }
    
    self.showControl ? [self hide] : [self showAndFade];
    
    
    if (self.touchBlock)
    {
        self.touchBlock(self);
    }
}

- (IBAction)moreButtonAction:(UIButton *)button {
    [self showNoFade];
    
    //定义菜单数组
    LivePopUpMenuItem *item1 = [LivePopUpMenuItem itemWith:@"Live_edit" title:@"编辑"];
    LivePopUpMenuItem *item2 = [LivePopUpMenuItem itemWith:@"Live_del" title:@"删除"];
    
    NSArray *items = @[ item1, item2 ];
    
    [LivePopUpMenuView showInView:self fromRect:self.moreButton.frame withItems:items itemClick:^(NSInteger idx) {
        
        if (0 == idx)
        {
            if (self.editBlock)
            {
                self.editBlock(self);
            }
        }
        else if (1 == idx)
        {
            if (self.removeBlock)
            {
                self.removeBlock(self);
            }
        }
        
        [self showAndFade];
        
    }];
}

- (IBAction)lockScreenButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    
    self.lockScreen = button.selected;
    
    self.lockScreen ? [self hideAndFade] : [self showAndFade];
}

- (IBAction)chatButtonAction:(UIButton *)button {
    
    if (![AppManager hasLogin]) {
        [self showErrorMessage:@"请登录！"];
        return;
    }
    
    [self showNoFade];
    [self.inputTextField becomeFirstResponder];
}

- (IBAction)startButtonAction:(UIButton *)button {
    
    if (self.startBlock)
    {
        [self.cutdownView removeFromSuperview];
        self.startBlock(self, button);
        self.moreBtnRightConst.constant = -30;
    }
}
- (IBAction)playButtonAction:(UIButton *)sender
{
    sender.selected = !sender.selected;
    if (self.startBlock)
    {
        self.startBlock(self, sender);
    }
}

- (IBAction)sendButtonAction:(id)sender
{
    if (self.inputTextField.text.length <=0)
    {
        [self showErrorMessage:@"内容不能为空"];
        return;
    }
    if (self.sendBlock)
    {
        self.sendBlock(self, self.inputTextField.text);
    }
    
    self.inputTextField.text = nil;
    [self endEditing:YES];
}


#pragma mark - Public
- (void)setViewNumber:(NSString *)number
{
    [self.viewsButton setTitle:number forState:UIControlStateNormal];
    CGFloat width = [number widthWithFont:[UIFont systemFontOfSize:12] constrainedToHeight:CGFLOAT_MAX];
    self.viewsButtonWidth.constant = width + 37;
}

- (void)setLiveTitle:(NSString *)title {
    
    [self.titleLabel setText:title refreshLabels:NO];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.labelSpacing = 40; // distance between start and end labels
    self.titleLabel.pauseInterval = 1.7; // seconds of pause before scrolling starts again
    self.titleLabel.scrollSpeed = 30; // pixels per second
    self.titleLabel.textAlignment = NSTextAlignmentLeft; // centers text when no auto-scrolling is applied
    self.titleLabel.fadeLength = 12.f;
    self.titleLabel.scrollDirection = CBAutoScrollDirectionLeft;
    [self.titleLabel observeApplicationNotifications];
    
}

#pragma mark - Pravite


#pragma mark - Getter & Setter
- (void)setMediaControlType:(LiveMediaControlType)mediaControlType {
    _mediaControlType = mediaControlType;
    
    if (mediaControlType == LiveMediaControlTypeSelf)
    {
        [self mediaControlTypeSelfConfig];
    }
    else if (mediaControlType == LiveMediaControlTypeOther)
    {
        [self mediaControlTypeOtherConfig];
        [self setLiveTitle:@""];
    }
    else
    {
        [self mediaControlTypePlayBackConfig];
        [self setLiveTitle:@""];
    }
}

//调整UI界面，把不想关的控件移除，以免占用内存
- (void)mediaControlTypeSelfConfig {
    self.moreBtnRightConst.constant = 5;
    
    [self.bottomPanel removeFromSuperview];
    
}

- (void)mediaControlTypeOtherConfig
{
    self.moreBtnRightConst.constant = -30;
    self.noticeButtonWidth.constant = 0.1;
    self.cameraLeading.constant = 20;
    self.titleLeading.constant = 10;
    self.cameraButton.hidden = YES;
    
    [self.startButton removeFromSuperview];
    [self.bgCoverView removeFromSuperview];
    [self.timeView removeFromSuperview];
    [self.bottomPanel removeFromSuperview];
}

- (void)mediaControlTypePlayBackConfig {
    self.moreBtnRightConst.constant = -30;
    self.noticeButtonWidth.constant = 0.1;
    self.cameraLeading.constant = 20;
    self.titleLeading.constant = 10;
    self.cameraButton.hidden = YES;
    
    [self.startButton removeFromSuperview];
    [self.bgCoverView removeFromSuperview];
    [self.timeView removeFromSuperview];
    [self.cutdownView removeFromSuperview];
}

#pragma mark - 键盘处理
- (void)keyboardWillShow:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    
    NSTimeInterval duration = [info[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    
    NSValue *endFrameValue = info[@"UIKeyboardFrameEndUserInfoKey"];
    
    CGRect endFrame = [endFrameValue CGRectValue];
    
    CGFloat endY = endFrame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        
        self.inputViewConstBottom.constant = endY;
        [self layoutIfNeeded];
        
    }];
}

- (void)keyboardWillHide:(NSNotification *)noti {
    NSDictionary *info = noti.userInfo;
    
    NSTimeInterval duration = [info[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        self.inputViewConstBottom.constant = -50;
        [self layoutIfNeeded];
        
    }];
}

#pragma mark - TableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    cell.backgroundColor = [UIColor clearColor];
    
    ChatModel *model = self.dataSource[indexPath.row];
    
    cell.model = model;
    
    cell.attributedLabel.delegate = self;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatModel *model = self.dataSource[indexPath.row];
    return model.textHeight + 4;
}

//消息的格式处理
- (void)addChatMessage:(NSString *)message Error:(BOOL)error{

    if (error)
    {
        //显示服务器连接失败
        [self showMessage:message linkData:nil isCreatorMessage:NO];
        return;
    }
    
    //在线人数
    NSRange onliveRange = [message rangeOfString:@" UID:"];
    NSString *onlive = [NSString string];
    onlive = [message substringToIndex:onliveRange.location];
    onlive = [onlive substringFromIndex:7];
    [self setViewNumber:onlive];
    
    //获取评论人ID
    NSString *userID = [NSString string];
    userID = [message substringFromIndex:onliveRange.location + onliveRange.length];
    NSRange userIDRange = [userID rangeOfString:@" UNAME:"];
    userID = [userID substringToIndex:userIDRange.location];

    
    NSRange loginRange    = [message rangeOfString:@"login"];
    NSRange logoutRange   = [message rangeOfString:@"logout"];
    NSRange silentRange   = [message rangeOfString:@"silent"];
    NSRange unsilentRange = [message rangeOfString:@"unsilent"];
    
    if (loginRange.location != NSNotFound)
    {
        NSRange range = [message rangeOfString:@" MSG" options:NSBackwardsSearch];
        NSString *userName = [message substringToIndex:range.location];
        NSRange range1 = [message rangeOfString:@"UNAME:"];
        userName = [userName substringFromIndex:range1.location+range1.length];
        
        if ([userName isEqualToString:@"(null)"])
        {
            userName = @"游客";
        }
        NSString *msg = [NSString stringWithFormat:@"%@进入直播间", userName];
        
        [self showMessage:msg linkData:nil isCreatorMessage:NO];
    }
    else if (logoutRange.location != NSNotFound)
    {
        NSRange range = [message rangeOfString:@" MSG" options:NSBackwardsSearch];
        NSString *userName = [message substringToIndex:range.location];
        NSRange range1 = [message rangeOfString:@"UNAME:"];
        userName = [userName substringFromIndex:range1.location+range1.length];
        
        if ([userName isEqualToString:@"(null)"])
        {
            userName = @"游客";
        }
        //显示消息
        NSString *msg = [NSString stringWithFormat:@"%@离开直播间", userName];
        
        [self showMessage:msg linkData:nil isCreatorMessage:NO];
    }
    else if (silentRange.location != NSNotFound)
    {
        NSRange range = [message rangeOfString:@" MSG" options:NSBackwardsSearch];
        NSString *userName = [message substringToIndex:range.location];
        NSRange range1 = [message rangeOfString:@"UNAME:"];
        userName = [userName substringFromIndex:range1.location+range1.length];
        
        //显示消息
        NSString *msg = [NSString stringWithFormat:@"%@你已被禁言!", userName];
        [self showMessage:msg linkData:nil isCreatorMessage:NO];
    }
    else if (unsilentRange.location != NSNotFound)
    {
        NSRange range = [message rangeOfString:@" MSG" options:NSBackwardsSearch];
        NSString *userName = [message substringToIndex:range.location];
        NSRange range1 = [message rangeOfString:@"UNAME:"];
        userName = [userName substringFromIndex:range1.location+range1.length];
        
        NSString *msg = [NSString stringWithFormat:@"%@你已解除禁言!", userName];
        
        [self showMessage:msg linkData:nil isCreatorMessage:NO];
    }
    else
    {
        NSString *newMessage = [NSString string];
        
        NSRange range = [message rangeOfString:@" MSG:" options:NSBackwardsSearch];
        newMessage = [message substringFromIndex:range.location + range.length];
        message = [message substringToIndex:range.location];
        
        NSRange range1 = [message rangeOfString:@"UNAME:"];
        NSString *userName = [message substringFromIndex:range1.location+range1.length];
        
        NSRange range2 = [newMessage rangeOfString:@"\n" options:NSBackwardsSearch];
        if (range2.location != NSNotFound)
        {
            
            newMessage = [newMessage stringByReplacingOccurrencesOfString:@"\n" withString:@"" options:NSBackwardsSearch range:range2];
        }
        
        if([newMessage hasPrefix:@"cn.mycs.www.start"])
        {
            [self.cutdownView removeFromSuperview];
            self.indicatorView.alpha = 1;
            newMessage = @"开始直播";
            _liveType = OnMediaLive;
            [[NSNotificationCenter defaultCenter] postNotificationName:ChangeLiveStatus object:nil];
        }
        
        newMessage = [userName stringByAppendingString:[NSString stringWithFormat:@"-&&&-%@",newMessage]];
        ChatUserModel *model = [ChatUserModel modelWith:userName andId:userID];
        
        [self showMessage:newMessage linkData:model isCreatorMessage:NO];
    }
}

- (void)showMessage:(NSString *)message linkData:(id)linkData isCreatorMessage:(BOOL)isCreatorMessage {
    
    ChatModel *model = [[ChatModel alloc] initWithMessage:message linkData:linkData isCreatorMessage:isCreatorMessage];
    
    [self.dataSource addObject:model];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0];
    [self.chatTableView insertRowsAtIndexPaths:@[ lastIndexPath ] withRowAnimation:UITableViewRowAnimationBottom];
    //滚动到最底部
    [self.chatTableView scrollToRowAtIndexPath:lastIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - AttributedLabel代理
- (void)attributedLabel:(TYAttributedLabel *)attributedLabel textStorageClicked:(id<TYTextStorageProtocol>)textStorage atPoint:(CGPoint)point
{
       id linkData = ((TYLinkTextStorage *)textStorage).linkData;
        
        if (!linkData) return;
        
        if (self.chatNameClickBlock)
        {
            self.chatNameClickBlock(self, linkData);
        }
}

#pragma mark - Getter & Setter
- (UITableView *)chatTableView {
    if (!_chatTableView)
    {
        UITableView *tableView = [UITableView new];
        _chatTableView         = tableView;
        [self insertSubview:tableView belowSubview:self.lockScreenButton];
        tableView.backgroundColor = [UIColor clearColor];
        tableView.delegate        = self;
        tableView.dataSource      = self;
        tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[ChatViewCell class] forCellReuseIdentifier:reuseId];
        tableView.showsVerticalScrollIndicator   = NO;
        tableView.showsHorizontalScrollIndicator = NO;
        [self addConstsToTableView];
    }
    
    return _chatTableView;
}

- (void)addConstsToTableView {
    self.chatTableView.translatesAutoresizingMaskIntoConstraints = NO;
    //
    UIView *chatTable = self.chatTableView;
    
    NSDictionary *metrics = @{ @"kChatViewW" : @kChatViewW };
    
    NSString *hVFL = @"H:|-(15)-[chatTable(kChatViewW)]";
    
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:metrics views:NSDictionaryOfVariableBindings(chatTable)];
    
    NSLayoutConstraint *constTop = [NSLayoutConstraint constraintWithItem:chatTable attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.lockScreenButton attribute:NSLayoutAttributeBottom multiplier:1 constant:18];
    
    NSLayoutConstraint *constBottom = [NSLayoutConstraint constraintWithItem:chatTable attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    
    [self addConstraints:hConsts];
    [self addConstraint:constTop];
    [self addConstraint:constBottom];
}

#pragma mark - 倒计时
- (UIView *)cutdownView {
    if (!_cutdownView)
    {
        UIView *view = [UIView new];
        _cutdownView = view;
        
        [self insertSubview:view belowSubview:self.inputView];
        
        view.backgroundColor     = [UIColor blackColor];
        view.alpha               = 0.7;
        view.layer.cornerRadius  = 8;
        view.layer.masksToBounds = YES;
        
        view.bounds = CGRectMake(0, 0, 230, 70);
        [self addConstToCutdownView];
        
        UILabel *titleLabel  = [UILabel new];
        titleLabel.text      = @"距离直播开始";
        titleLabel.textColor = HEXRGB(0xffffff);
        titleLabel.font      = [UIFont systemFontOfSize:16];
        [view addSubview:titleLabel];
        
        UILabel *timeLabel  = [UILabel new];
        self.timeLabel      = timeLabel;
        timeLabel.text      = @"03天13时54分26秒";
        timeLabel.textColor = HEXRGB(0xffffff);
        timeLabel.font      = [UIFont systemFontOfSize:16];
        [view addSubview:timeLabel];
        
        //添加约束
        [self addConstTo:titleLabel andTimeLabel:timeLabel];
    }
    return _cutdownView;
}

- (void)addConstToCutdownView {
    self.cutdownView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constCenterX = [NSLayoutConstraint constraintWithItem:self.cutdownView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *constCenterY = [NSLayoutConstraint constraintWithItem:self.cutdownView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *constWidth   = [NSLayoutConstraint constraintWithItem:self.cutdownView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:230];
    NSLayoutConstraint *constHeight  = [NSLayoutConstraint constraintWithItem:self.cutdownView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:70];
    
    [self addConstraints:@[ constCenterX, constCenterY, constWidth, constHeight ]];
}

- (void)addConstTo:(UILabel *)titleLabel andTimeLabel:(UILabel *)timeLabel {
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    timeLabel.translatesAutoresizingMaskIntoConstraints  = NO;
    
    NSLayoutConstraint *titleCenterX  = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:titleLabel.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *titleConstTop = [NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:titleLabel.superview attribute:NSLayoutAttributeTop multiplier:1 constant:12];
    
    [titleLabel.superview addConstraint:titleCenterX];
    [titleLabel.superview addConstraint:titleConstTop];
    
    NSLayoutConstraint *timeCenterX = [NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:timeLabel.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *timeConstBottom = [NSLayoutConstraint constraintWithItem:timeLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:timeLabel.superview attribute:NSLayoutAttributeBottom multiplier:1 constant:-12];
    [timeLabel.superview addConstraint:timeCenterX];
    [timeLabel.superview addConstraint:timeConstBottom];
}

- (void)cutdownWithExpireTime:(NSDate *)expireDate {
    self.cutdownView.hidden = NO;
    self.expireDate         = expireDate;
    [self cutdownTime];
}

- (void)cutdownTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *cps = [calendar components:NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date] toDate:self.expireDate options:NSCalendarMatchStrictly];
    
    NSString *timeStr = [NSString stringWithFormat:@"%02zd天%02zd时%02zd分%02zd秒", cps.day, cps.hour, cps.minute, cps.second];
    
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:timeStr];
    
    [attrStr setAttrColor:HEXRGB(0xf66060) inRange:NSMakeRange(0, 2)];
    [attrStr setAttrColor:HEXRGB(0xf66060) inRange:NSMakeRange(3, 2)];
    [attrStr setAttrColor:HEXRGB(0xf66060) inRange:NSMakeRange(6, 2)];
    [attrStr setAttrColor:HEXRGB(0xf66060) inRange:NSMakeRange(9, 2)];
    
    [attrStr setFontSize:16 inRange:NSMakeRange(0, 2)];
    [attrStr setFontSize:16 inRange:NSMakeRange(3, 2)];
    [attrStr setFontSize:16 inRange:NSMakeRange(6, 2)];
    [attrStr setFontSize:16 inRange:NSMakeRange(9, 2)];
    
    self.timeLabel.attributedText = attrStr;
    
    [self performSelector:@selector(cutdownTime) withObject:nil afterDelay:1];
    
   __unused BOOL timeEnd = cps.second == 0 && cps.day == 0 && cps.minute == 0 && cps.hour == 0;
    
    if (self.mediaControlType != LiveMediaControlTypeSelf) return;
    
    BOOL lessThanFifteenMin = cps.day == 0 && cps.hour == 0 && (cps.minute < 15);
    
    //在15分钟之内可以提前开播
    if (lessThanFifteenMin)
    {
        
    }
    else
    {
       
    }
}

//取消计时
- (void)cancelCutdownTime {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(cutdownTime) object:nil];
    [self.cutdownView removeFromSuperview];
}

#pragma mark - 直播计时器
//开始计时
- (void)startCalculateTime {
    //只有主播才有计时功能
    if (self.mediaControlType != LiveMediaControlTypeSelf) return;
    
    self.startDate = [NSDate date];
    
    self.bgCoverView.alpha = 0.2;
    self.timeView.alpha    = 1;
    self.startButton.selected = YES;
    //真正开始计算时间
    [self calculateTime];
}

- (void)calculateTime {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *cps = [calendar components:NSCalendarUnitSecond fromDate:self.startDate toDate:[NSDate date] options:NSCalendarMatchStrictly];
    
    NSTimeInterval timeInterval = cps.second;
    
    NSString *timeStr = [NSDate timeWithSec:timeInterval format:@"HH:mm:ss"];
    
    self.uptimeLabel.text = timeStr;
    
    [self performSelector:@selector(calculateTime) withObject:nil afterDelay:1];
}

- (void)cancelCalculateTime {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(calculateTime) object:nil];
}

@end

@implementation LiveMediaTitleButton

- (void)setImage:(UIImage *)image
        forState:(UIControlState)state {
    [super setImage:image forState:state];
    
    if (!image) return;
    
    [self setTitle:nil forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    
    if (!title) return;
    
    [self setImage:nil forState:UIControlStateNormal];
}

@end

@interface LiveMediaShareView ()

@property (nonatomic, strong) NSArray *shareButtons;

@property (weak, nonatomic) IBOutlet UIView *contentView;

@end

@implementation LiveMediaShareView

+ (instancetype)shareViewWith:(void (^)(UIButton *button))block {
    LiveMediaShareView *shareView = [[[NSBundle mainBundle] loadNibNamed:@"LiveMediaControl" owner:nil options:nil] lastObject];
    
    shareView.shareButtonBlock = block;
    
    return shareView;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shareButtons = [LiveMediaShareView items];
    for (LiveMediaShareButton *button in self.shareButtons)
    {
        [self.contentView addSubview:button];
        //添加点击事件
        [button addTarget:self action:@selector(shareButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}

+ (NSArray *)items {
    NSMutableArray *array = [NSMutableArray array];
    
    if ([UMengHelper isInstallWechatPlatform])
    {
        LiveMediaShareButton *friendButton   = [LiveMediaShareButton shareButtonWith:@"Live_wechat" title:@"微信好友"];
        LiveMediaShareButton *timeLineButton = [LiveMediaShareButton shareButtonWith:@"Live_friend-circle" title:@"微信朋友圈"];
        [array addObject:friendButton];
        [array addObject:timeLineButton];
    }
    
    if ([UMengHelper isInstallQQPlatform])
    {
        LiveMediaShareButton *QQButton = [LiveMediaShareButton shareButtonWith:@"Live_qq" title:@"QQ好友"];
        [array addObject:QQButton];
        LiveMediaShareButton *QQZoneButton = [LiveMediaShareButton shareButtonWith:@"Live_zone" title:@"QQ空间"];
        [array addObject:QQZoneButton];
        
    }
    
    return array;
}

- (void)shareButtonDidClick:(UIButton *)button {
    if (self.shareButtonBlock)
    {
        self.shareButtonBlock(button);
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat buttonW = self.contentView.width / self.shareButtons.count;
    CGFloat buttonH = self.contentView.height;
    
    //调整button的位置
    for (int i = 0; i < self.shareButtons.count; i++)
    {
        LiveMediaShareButton *button = self.shareButtons[i];
        
        CGFloat buttonX = buttonW * i;
        
        button.frame = CGRectMake(buttonX, 0, buttonW, buttonH);
    }
}

@end

@implementation LiveMediaShareButton

+ (instancetype)shareButtonWith:(NSString *)imageName title:(NSString *)title {
    LiveMediaShareButton *button = [LiveMediaShareButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitleColor:HEXRGB(0x666666) forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    
    return button;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView sizeToFit];
    [self.titleLabel sizeToFit];
    
    if (!self.titleLabel.text) self.titleLabel.height = 20;
    
    CGFloat margin = 10;
    
    CGFloat imageCenterX = (self.width - self.imageView.width) * 0.5;
    CGFloat imageY       = (self.height - self.imageView.height - self.titleLabel.height - margin) * 0.5;
    
    self.imageView.frame = CGRectMake(imageCenterX, imageY, self.imageView.width, self.imageView.height);
    
    CGFloat titleX = (self.width - self.titleLabel.width) * 0.5;
    CGFloat titleY = CGRectGetMaxY(self.imageView.frame) + margin;
    
    self.titleLabel.frame = CGRectMake(titleX, titleY, self.titleLabel.width, self.titleLabel.height);
}

@end

@implementation ChatModel

- (instancetype)initWithMessage:(NSString *)message linkData:(id)linkData isCreatorMessage:(BOOL)isCreatorMessage {
    if ([super init])
    {
        self.isCreatorMessage = isCreatorMessage;
        self.linkData = linkData;
        self.message  = message;
    }
    return self;
}

- (void)setMessage:(NSString *)message {
    _message = message;
    
    NSRange range = [message rangeOfString:@"-&&&-" options:NSBackwardsSearch];
    
    TYTextContainer *textContainer = [TYTextContainer new];
    textContainer.lineBreakMode    = kCTLineBreakByWordWrapping;
    textContainer.font             = kMessageFont;
    textContainer.textColor        = HEXRGB(0xffffff);
    textContainer.linesSpacing     = 0;
    //    textContainer
    
    TYLinkTextStorage *linkTextStorage = [[TYLinkTextStorage alloc] init];
    linkTextStorage.text               = nil;
    linkTextStorage.linkData           = self.linkData;
    linkTextStorage.underLineStyle     = kCTUnderlineStyleNone;
    [textContainer addTextStorage:linkTextStorage];
    
    if (range.location != NSNotFound)
    {
        linkTextStorage.textColor = self.isCreatorMessage ? HEXRGB(0x47c1a8) : HEXRGB(0x0075c1);
        linkTextStorage.range     = NSMakeRange(0, range.location+1);
        self.interactionEnabled = YES;
    }
    else
    {
        linkTextStorage.textColor = HEXRGB(0xe67928);
        linkTextStorage.range     = NSMakeRange(0, message.length);
        self.interactionEnabled = NO;
        
    }
    
    textContainer.text             = [message stringByReplacingOccurrencesOfString:@"-&&&-" withString:@":"];
    
    [textContainer addTextStorage:linkTextStorage];
    
    [textContainer createTextContainerWithTextWidth:kChatViewW];
    
    self.attributedString = textContainer.attributedText;
    self.textHeight       = textContainer.textHeight;
}


@end

@implementation ChatViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        [self addConstToAttributedLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)addConstToAttributedLabel {
    self.attributedLabel.translatesAutoresizingMaskIntoConstraints = NO;
    //
    UIView *attributedLabel = self.attributedLabel;
    NSString *hVFL          = @"H:|-(0)-[attributedLabel]-(0)-|";
    NSString *vVFL          = @"V:|-(0)-[attributedLabel]-(4)-|";
    
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(attributedLabel)];
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(attributedLabel)];
    
    [self addConstraints:hConsts];
    [self addConstraints:vConsts];
}

- (void)setModel:(ChatModel *)model {
    _model = model;
    
    self.attributedLabel.attributedText = model.attributedString;
    self.userInteractionEnabled = model.interactionEnabled;
}

- (TYAttributedLabel *)attributedLabel {
    if (!_attributedLabel)
    {
        TYAttributedLabel *label = [[TYAttributedLabel alloc] init];
        _attributedLabel         = label;
        label.lineBreakMode      = kCTLineBreakByCharWrapping;
        label.textAlignment      = kCTTextAlignmentLeft;
        label.backgroundColor    = [UIColor clearColor];
        label.font               = kMessageFont;
        [self addSubview:label];
    }
    return _attributedLabel;
}

@end

@implementation ChatUserModel

+ (instancetype)modelWith:(NSString *)name andId:(NSString *)userId {
    ChatUserModel *model = [ChatUserModel new];
    model.userid         = userId;
    model.name           = name;
    return model;
}

@end
@implementation LiveCustomSlider

-(void)awakeFromNib
{
    [super awakeFromNib];
    _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    _tapGesture.delegate = self;
    [self addGestureRecognizer:_tapGesture];
    
    [self addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(sliderTouchUp:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sliderValueChanged:(UISlider *)sender {
    
    self.value = sender.value;
    if (self.sliderTouch)
    {
        self.sliderTouch();
    }
}

- (void)sliderTouchDown:(UISlider *)sender
{
    NSLog(@"sliderTouchDown");
    _tapGesture.enabled = NO;
}

- (void)sliderTouchUp:(UISlider *)sender
{
    if (sender) {
        NSLog(@"sliderTouchUp");
    } else {
        NSLog(@"sliderTouchUp from actionTap");
    }
    _tapGesture.enabled = YES;
}


- (void)actionTapGesture:(UITapGestureRecognizer *)sender
{
    
    CGPoint touchPoint = [sender locationInView:self];
    CGFloat value = (self.maximumValue - self.minimumValue) * (touchPoint.x / self.frame.size.width );
    
    self.value = value;
    
    if (self.sliderTouch)
    {
        self.sliderTouch();
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}
- (void)dealloc
{
    if (_tapGesture) {
        [self removeGestureRecognizer:_tapGesture];
        _tapGesture = nil;
    }
}
@end






