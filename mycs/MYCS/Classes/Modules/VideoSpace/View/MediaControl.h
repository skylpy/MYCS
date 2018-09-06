//
//  MediaControl.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SopDetail.h"
#import "CourseDetail.h"
#import "VideoDetail.h"
#import "DoctorsHealthList.h"

@protocol IJKMediaPlayback;
@interface MediaControl : UIView

@property(nonatomic,weak) id<IJKMediaPlayback> mediaPlayer;

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, PanDirection){
    PanDirectionHorizontalMoved, //横向移动
    PanDirectionVerticalLeftMoved,
    PanDirectionVerticalRightMoved
    //纵向移动
};

//是否显示或者隐藏工具条
@property (nonatomic,assign,getter=isShowing) BOOL showing;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic,copy) void(^backButtonAction)(UIButton *);
@property (nonatomic,copy) void(^playButtonAction)(UIButton *);
@property (nonatomic,copy) void(^nextButtonAction)(UIButton *);
@property (nonatomic,copy) void(^selectButtonAction)(UIButton *);
@property (nonatomic,copy) void(^tipsButtonAction)(UIButton *);
@property (nonatomic,copy) void(^sliderAction)(UISlider *, ChapterModel *chapter);
@property (nonatomic,copy) void(^clarityAction)(UIButton *, ChapterModel *chapter,VideoDetail *videoDetail,DoctorsHealthDetail *doctorsHealthDetail,NSString *nameStr);

@property (weak, nonatomic) IBOutlet UIButton *playtipsButton;
@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *changeL;
//清晰度按钮
@property (weak, nonatomic) IBOutlet UIButton *ClarityButton;

@property (nonatomic, assign, getter=isLockScreen) BOOL lockScreen;
@property (nonatomic, assign, getter=isShowSelectView) BOOL showSelectView;
@property (nonatomic,strong) SopDetail *sopDetail;
@property (nonatomic,strong) CourseDetail *courseDetail;
@property (nonatomic,strong) VideoDetail *videoDetail;
@property (nonatomic,strong) ChapterModel *chapter;
@property (nonatomic,strong) DoctorsHealthDetail *doctorsHealthDetail;
//课程视频数组
@property (nonatomic,strong) NSArray * coursePackArray;
@property (nonatomic,copy) void(^nextCoursePackButtonAction)(UIButton *);
//任务
@property (nonatomic, assign) BOOL isTask;
@property (nonatomic,copy) NSString *title;

//是否切换了清晰度
@property (nonatomic,assign) BOOL changeDefinition;
//切换清晰度前的播放时间点
@property (nonatomic,assign) NSTimeInterval changeDefinitionTime;
//切换清晰度前的播放时间总长
@property (nonatomic,assign) NSTimeInterval changeDefinitionDuration;

//当前播放的时间点
@property (nonatomic,assign) NSTimeInterval videoTimeSpot;

//判断是否播放缓存文件
@property (nonatomic, assign) BOOL comeFromCacheFile;
//普通视频
@property (nonatomic,assign) BOOL isVideo;

- (void)showAndFade;
- (void)showNoFade;
- (void)hide;
- (void)cancelDelayedEvent;

- (void)refreshMediaControl;

- (void)showIndicator;
- (void)hideIndicator;

//课程的下一集是否可以点击
- (void)canDisableNextButton;

+ (instancetype)mediaControl;

@end

@interface CustomSlider : UISlider<UIGestureRecognizerDelegate>

@property (nonatomic ,strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic,copy) void(^sliderTouch)();

@end
