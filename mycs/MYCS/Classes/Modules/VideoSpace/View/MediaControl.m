//
//  MediaControl.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MediaControl.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "SelectedView.h"
#import "VideoDetail.h"
#import "NSDate+Util.h"
#import "CoursePackModel.h"
#import "CBAutoScrollLabel.h"
#import "DefinitionView.h"

#define kTopPanelH 65
#define kBottomPanelH 44

@interface MediaControl ()<UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet UIView *topPanel;

@property (weak, nonatomic) IBOutlet CBAutoScrollLabel *titleLabel;

//下一集按钮
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
//选集按钮
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
//锁屏按钮
@property (weak, nonatomic) IBOutlet UIButton *lockScreenButton;

@property (weak, nonatomic) IBOutlet UIView *bottomPanel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@property (weak, nonatomic) IBOutlet UILabel *totalDurationLabel;
@property (weak, nonatomic) IBOutlet CustomSlider *mediaProgressSlider;

@property (weak, nonatomic) IBOutlet UIProgressView *cacheProgress;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topPanelConstTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomPanelConstBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectButtonTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *totalTimeTrailing;

//系统声音Slider
@property (nonatomic,weak) UISlider *systemSlider;

//滑动的方向
@property (nonatomic, assign) PanDirection panDirection;

//快进时间
@property (nonatomic,assign) CGFloat seekTime;

@end

@implementation MediaControl

- (void)awakeFromNib {
    
    [super awakeFromNib];
    [self.mediaProgressSlider setTintColor:HEXRGB(0x47c1a8)];
    
    self.mediaProgressSlider.continuous = NO;
    
    [self.mediaProgressSlider setThumbImage:[UIImage imageNamed:@"play_on"] forState:UIControlStateNormal];
    
    self.changeDefinitionTime = 0;
    
    [self addTap];
}
-(void)addTap
{
    [self.mediaProgressSlider addTarget:self action:@selector(mediaProgressSliderAction:) forControlEvents:UIControlEventValueChanged];
    
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
    
    [self setSliderTouch];
    
    [self performSelector:@selector(showAndFade) withObject:nil afterDelay:3];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isKindOfClass:[CustomSlider class]]){
        
        return NO;
        
    }
    
    return YES;
    
}

+ (instancetype)mediaControl {
    
    MediaControl *mediaControl = [[[NSBundle mainBundle] loadNibNamed:@"MediaControl" owner:nil options:nil] firstObject];
    
    return mediaControl;
}

-(void)fade
{
    [self cancelDelayedLockButtonHide];
    [self performSelector:@selector(hideLockButton) withObject:nil afterDelay:5];
}

- (void)showNoFade {
    
    [self show];
    [self refreshMediaControl];
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
        
    }];
    self.showing = NO;
}

- (void)show {
    
    [self cancelDelayedLockButtonHide];
    self.lockScreenButton.hidden = NO;
    self.topPanel.hidden = NO;
    self.bottomPanel.hidden = NO;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.topPanelConstTop.constant = 0;
        self.bottomPanelConstBottom.constant = 0;
        
        [self layoutIfNeeded];
        
    }];
    
    self.showing = YES;
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
        
    }];
    self.showing = NO;
    
    [self fade];
}

-(void)hideLockButton
{
    self.lockScreenButton.hidden = YES;
    self.lockScreenButton.selected = YES;
    self.lockScreen = YES;
    
}

- (void)cancelDelayedLockButtonHide
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideLockButton) object:nil];
}

- (void)cancelDelayedRefreshMediaControl {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
}

- (void)cancelDelayedEvent {
    
    [self cancelDelayedLockButtonHide];
    self.showing = NO;
    
}

- (void)refreshMediaControl {
    // duration
    NSTimeInterval duration = self.mediaPlayer.duration;
    NSInteger intDuration = duration + 0.5;
    
    if (self.changeDefinition&&self.mediaPlayer.isPlaying)
    {
        NSInteger intPosition = self.changeDefinitionTime + 0.5;
        
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)(intPosition / 3600), (int)((intPosition / 60)%60), (int)(intPosition % 60)];

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mediaPlayer pause];
            
            [self.mediaPlayer setCurrentPlaybackTime:(self.changeDefinitionTime-9)>0?(self.changeDefinitionTime-9):self.changeDefinitionTime];
            
            [self.mediaPlayer play];
        });
        
        self.changeDefinition = NO;
        
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
        
        return;
    }
    
    if (intDuration > 0) {
        
        NSInteger totalDuration = duration;
        self.mediaProgressSlider.maximumValue = duration;
        self.totalDurationLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)(totalDuration / 3600), (int)((totalDuration / 60)%60), (int)(totalDuration % 60)];
    } else {
        
        if (!self.changeDefinition)
        {
            self.totalDurationLabel.text = @"--:--:--";
        }
        self.mediaProgressSlider.maximumValue = 1.0f;
    }

    //缓冲的进度
    self.cacheProgress.progress = self.mediaPlayer.playableDuration/duration;
    // position
    NSTimeInterval position;
    position = self.mediaPlayer.currentPlaybackTime;
    
    NSInteger intPosition = position + 0.5;
    if (intDuration > 0) {
        self.mediaProgressSlider.value = position;
        self.videoTimeSpot = position;
    } else {
        self.mediaProgressSlider.value = 0.0f;
    }
    
    self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)(intPosition / 3600), (int)((intPosition / 60)%60), (int)(intPosition % 60)];
    // status
    BOOL isPlaying = [self.mediaPlayer isPlaying];
    self.playButton.selected = isPlaying;
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    
    if (self.showing)
    {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.5];
    }
    
    if (self.changeDefinition)
    {
        intPosition = self.changeDefinitionTime;
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)(intPosition / 3600), (int)((intPosition / 60)%60), (int)(intPosition % 60)];
        self.mediaProgressSlider.maximumValue = self.changeDefinitionDuration;
        self.mediaProgressSlider.value = intPosition;
        self.videoTimeSpot = intPosition;
    }
}

- (void)showIndicator {
    self.indicatorView.hidden = NO;
}

- (void)hideIndicator {
    self.indicatorView.hidden = YES;
}


- (IBAction)lockScreenButtonAction:(UIButton *)button {
    button.selected = !button.selected;
    
    self.lockScreen = button.selected;
    
    self.lockScreen ? [self hideAndFade] : [self showAndFade];
}

#pragma mark - Action
- (IBAction)backAction:(UIButton *)button {
    
    if (self.backButtonAction) self.backButtonAction(button);
    
}

- (IBAction)playButtonAction:(UIButton *)button {
    
    if (self.mediaPlayer.isPlaying)
    {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideLockButton) object:nil];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
        
    }else
    {
        [self showAndFade];
    }
    
    if (self.playButtonAction) self.playButtonAction(button);
    
}

- (IBAction)nextButtonAction:(UIButton *)button {
    
    if (self.coursePackArray.count>0)
    {
        if (self.nextCoursePackButtonAction)
            self.nextCoursePackButtonAction(button);
        [self.mediaPlayer pause];
        self.indicatorView.hidden = NO;
        self.changeDefinition = NO;
    }
    else
    {
        if (self.nextButtonAction) self.nextButtonAction(button);
        
        self.changeDefinition = NO;
    }
    [self delayHide];
}

- (void)setSliderTouch
{
    self.mediaProgressSlider.sliderTouch = ^() {
        
        if (self.sliderAction) self.sliderAction(self.mediaProgressSlider,self.chapter);
        
        [self showAndFade];
    };
}

- (IBAction)slideAction:(UISlider *)slider {
    
    [self showAndFade];
    [self refreshMediaControl];
}

- (IBAction)beginSlide:(UISlider *)slider {
    
    [self cancelDelayedLockButtonHide];
    [self cancelDelayedRefreshMediaControl];
    
}
- (IBAction)selectClarityAction:(UIButton *)sender
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    self.showSelectView = YES;
    
    DefinitionView *definitionView = [DefinitionView showInView:self andSelectStr:self.ClarityButton.titleLabel.text and:^{
        [self delayHide];
        self.showSelectView = NO;
    }];
    
    definitionView.cellClickBlock = ^(DefinitionView *definitionView,NSString *strName){
        
        if (![strName isEqualToString:self.ClarityButton.titleLabel.text])
        {
            [self.ClarityButton setTitle:strName forState:UIControlStateNormal];
            
            if (self.clarityAction)
            {
                 if (self.mediaPlayer.currentPlaybackTime > 0.09)
                 {
                     self.changeDefinitionTime = self.mediaPlayer.currentPlaybackTime;
                     self.changeDefinitionDuration = self.mediaPlayer.duration;
                 }
                self.changeL.hidden = NO;
                self.clarityAction(self.ClarityButton,self.chapter,self.videoDetail,self.doctorsHealthDetail,strName);
                
                self.changeDefinition = YES;
            }
        }
    };
}

- (IBAction)selectAction:(UIButton *)button {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hide) object:nil];
    self.showSelectView = YES;
    
    if (self.coursePackArray.count > 0)
    {
        SelectedView *view = [SelectedView showInView:self and:^{
            [self delayHide];
            self.showSelectView = NO;
        }];
        
        [view setSOPDetail:nil CourseDeatil:nil chapter:nil coursePackArray:self.coursePackArray];
        
        view.cellCoursePackChapterBlock = ^(CoursePackChapter * model)
        {
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MediaDidSelectCoursePackModel" object:model];
            [self.mediaPlayer pause];
            self.indicatorView.hidden = NO;
            self.changeDefinition = NO;
        };
        
    }
    else
    {
        SelectedView *view = [SelectedView showInView:self and:^{
            [self delayHide];
            self.showSelectView = NO;
        }];
        [view setSOPDetail:self.sopDetail CourseDeatil:self.courseDetail chapter:self.chapter coursePackArray:self.coursePackArray];
        
        view.cellBlock = ^(ChapterModel *chapter) {
            
            //发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"MediaDidSelectChapter" object:chapter];
            self.changeDefinition = NO;
            
        };
        
    }
    
    
}

- (void)tapGestAction:(UITapGestureRecognizer *)tap
{
    if (self.isShowSelectView)
    {
        return;
    }
    
    if (tap.view.tag >=1 )
    {
        [self showAndFade];
        
        return;
    }
    
    
    
    if (tap.state == UIGestureRecognizerStateEnded)
    {
        if (self.isLockScreen)
        {
            [self showLockButton];
            [self hideAndFade];
            
            return;
        }
        
        self.showing ? [self hide] : [self showAndFade];
        
    }
    
}
- (void)panGestAction:(UIPanGestureRecognizer *)pan {
    
    CGPoint locationPoint = [pan locationInView:self];
    
    CGPoint veloctyPoint = [pan velocityInView:self];
    
    switch (pan.state) {
            
        case UIGestureRecognizerStateBegan:{
            
            //            [self showNoFade];
            
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
            
            //            [self showAndFade];
            
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
-(void)mediaProgressSliderAction:(CustomSlider *)slider
{
    if (self.isTask && !self.chapter.passStatus)
    {
        return;
    }
    self.mediaProgressSlider.value = slider.value;
    
    if (self.mediaProgressSlider.sliderTouch)
    {
        self.mediaProgressSlider.sliderTouch();
    }
    
}
- (void)updateProgress:(CGFloat)value {
    
    if (self.isTask && !self.chapter.passStatus)
    {
        return;
    }
    
    if (self.isLockScreen)
    {
        [self showLockButton];
        [self fade];
        return;
    }
    
    [self showAndFade];
    
    [self cancelDelayedRefreshMediaControl];
    
    CGFloat newValue = value / 200;
    
    self.mediaProgressSlider.value += newValue;
    self.seekTime = self.mediaProgressSlider.value;
}

//调节进度
- (void)configProgress:(CGFloat)value {
    
    if (self.isTask && !self.chapter.passStatus)
    {
        return;
    }
    
    if (self.isLockScreen)
    {
        [self showLockButton];
        [self fade];
        return;
    }
    [self showAndFade];
    
    if (self.sliderAction) {
        self.mediaProgressSlider.value = self.seekTime;
        self.sliderAction(self.mediaProgressSlider,self.chapter);
    }
    self.seekTime = 0;
    [self refreshMediaControl];
    
}

//音量调节
- (void)configSystemSound:(CGFloat)value {
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

- (void)setTitle:(NSString *)title {
    _title = title;
    
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

- (void)setChapter:(ChapterModel *)chapter {
    _chapter = chapter;
    
    if (self.isTask && !self.chapter.passStatus)
    {
        self.mediaProgressSlider.enabled = NO;
        
    }else
    {
        self.mediaProgressSlider.enabled = YES;
    }
    
    [self canDisableNextButton:chapter];
}

- (void)setCourseDetail:(CourseDetail *)courseDetail {
    _courseDetail = courseDetail;
    
}

-(void)setSopDetail:(SopDetail *)sopDetail
{
    _sopDetail = sopDetail;
}

-(void)setVideoDetail:(VideoDetail *)videoDetail
{
    _videoDetail = videoDetail;
}

-(void)setDoctorsHealthDetail:(DoctorsHealthDetail *)doctorsHealthDetail
{
    _doctorsHealthDetail = doctorsHealthDetail;
}
-(void)setIsTask:(BOOL)isTask
{
    _isTask = isTask;
}

//最后教程或者SOP的最后一个章节，禁用下一集按钮
- (void)canDisableNextButton:(ChapterModel *)chapter {
    
    if (self.sopDetail)
    {
        
        if (self.isTask)
        {
            for (int j = 0; j < self.sopDetail.sopCourse.count; j ++)
            {
                SopCourseModel *nowCourse = self.sopDetail.sopCourse [j];
                
                for (int i = 0; i < nowCourse.chapters.count; i ++)
                {
                    ChapterModel *nowChapter = nowCourse.chapters[i];
                    
                    if ([chapter isEqual:nowChapter])
                    {
                        if (i < nowCourse.chapters.count - 1)
                        {
                            ChapterModel *lastChapter = nowCourse.chapters[i + 1];
                            
                            if (lastChapter.cando)
                            {
                                self.nextButton.enabled = YES;
                                return;
                            }
                            else
                            {
                                self.nextButton.enabled = NO;
                                return;
                            }
                        }
                        else if (j < self.sopDetail.sopCourse.count - 1)
                        {
                            SopCourseModel *nextCourse = self.sopDetail.sopCourse [j + 1];
                            ChapterModel *nextChapter = [nextCourse.chapters firstObject];
                            if (nextChapter.cando)
                            {
                                self.nextButton.enabled = YES;
                                return;
                            }
                            else
                            {
                                self.nextButton.enabled = NO;
                                return;
                            }
                        }
                        else
                        {
                            self.nextButton.enabled = NO;
                            return;
                        }
                        
                    }
                }
            }
        }else{
            
            SopCourseModel *course = [self.sopDetail.sopCourse lastObject];
            ChapterModel *lastChapter = [course.chapters lastObject];
            
            if ([chapter isEqual:lastChapter])
            {
                self.nextButton.enabled = NO;
            }
            else
            {
                self.nextButton.enabled = YES;
            }
            
        }
    }
    else if(self.courseDetail)
    {
        
        if (self.isTask)
        {
            for (int i = 0; i < self.courseDetail.chapters.count; i ++)
            {
                ChapterModel *nowChapter = self.courseDetail.chapters[i];
                
                if ([chapter isEqual:nowChapter])
                {
                    if (i < self.courseDetail.chapters.count - 1)
                    {
                        ChapterModel *lastChapter = self.courseDetail.chapters[i + 1];
                        if (lastChapter.cando)
                        {
                            self.nextButton.enabled = YES;
                            return;
                        }
                        else
                        {
                            self.nextButton.enabled = NO;
                            return;
                        }
                    }
                    else
                    {
                        self.nextButton.enabled = NO;
                        return;
                    }
                    
                }
            }
            
            
        }else
        {
            ChapterModel *lastChapter = [self.courseDetail.chapters lastObject];
            
            if ([chapter isEqual:lastChapter])
            {
                self.nextButton.enabled = NO;
            }
            else
            {
                self.nextButton.enabled = YES;
            }
        }
        
    }
    
}

- (void)canDisableNextButton{
    
    if (self.coursePackArray)
    {
        CoursePackModel *course = [self.coursePackArray lastObject];
        CoursePackChapter *lastChapter = [course.coursePackChapters lastObject];
        
        if (lastChapter.isSelect.intValue == 1)
        {
            self.nextButton.enabled = NO;
        }
        else
        {
            self.nextButton.enabled = YES;
        }
    }
}
- (void)setComeFromCacheFile:(BOOL)comeFromCacheFile
{
    _comeFromCacheFile = comeFromCacheFile;
   self.ClarityButton.enabled = !comeFromCacheFile;
    
    if (comeFromCacheFile)
    {
        self.totalTimeTrailing.constant = 15;
        self.selectButtonTrailing.constant = -106;
        self.nextButton.enabled = NO;
        self.selectedButton.enabled = NO;
    }
}
- (void)setIsVideo:(BOOL)isVideo {
    _isVideo = isVideo;
    
    if (isVideo)
    {
        self.nextButton.enabled = NO;
        self.selectedButton.enabled = NO;
        self.selectButtonTrailing.constant = -38;
        self.totalTimeTrailing.constant = 58;
    }
    
}
- (IBAction)playTipsButtonClick:(UIButton *)sender
{
    if (self.tipsButtonAction)
    {
        self.tipsButtonAction(sender);
    }
}

- (void)dealloc {
    NSLog(@"MediaControl dealloc!");
}

@end

@implementation CustomSlider

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
