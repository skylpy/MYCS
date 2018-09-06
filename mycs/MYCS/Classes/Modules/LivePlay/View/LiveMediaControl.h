//
//  LiveMediaControl.h
//  MYCS
//
//  Created by AdminZhiHua on 16/4/21.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

// 枚举值，包含水平移动方向和垂直移动方向
typedef NS_ENUM(NSInteger, LivePanDirection){
    PanDirectionHorizontalMoved, //横向移动
    PanDirectionVerticalLeftMoved,
    PanDirectionVerticalRightMoved
    //纵向移动
};

typedef NS_ENUM(NSUInteger, LiveMediaControlType) {
    //主播
    LiveMediaControlTypeSelf,
    //观看
    LiveMediaControlTypeOther,
    //回放
    LiveMediaControlTypePlayback
};

typedef NS_ENUM(int, LiveMediaType){
    //直播中
    OnMediaLive = 2,
    //未开播
    AfterMediaLive = 1,
    //结束直播
    EndMediaLive = 4
};

@protocol IJKMediaPlayback;
@interface LiveMediaControl : UIView

@property(nonatomic,weak) id<IJKMediaPlayback> mediaPlayer;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;

@property (nonatomic, assign) LiveMediaControlType mediaControlType;

@property (nonatomic, assign, getter=isLockScreen) BOOL lockScreen;
@property (nonatomic, assign, getter=isShowControl) BOOL showControl;
@property (nonatomic ,copy) NSString *roomId;
@property (nonatomic ,assign) LiveMediaType liveType;

#pragma mark - ActionBlock
//返回按钮的点击
@property (nonatomic, copy) void (^backBlock)(LiveMediaControl *view, UIButton *button);

//摄像头
@property (nonatomic, copy) void (^changeCameraBlock)(LiveMediaControl *view, UIButton *button);

//发送通知事件
@property (nonatomic, copy) void (^notiBlock)(LiveMediaControl *view, UIButton *button);

//分享按钮的事件
@property (nonatomic, copy) void (^shareBlock)(LiveMediaControl *view, UIButton *button);

//开始按钮的点击
@property (nonatomic, copy) void (^startBlock)(LiveMediaControl *view, UIButton *button);

//发送按钮的点击
@property (nonatomic, copy) void (^sendBlock)(LiveMediaControl *view, NSString *content);

//点击MediaControl
@property (nonatomic, copy) void (^touchBlock)(LiveMediaControl *view);

//编辑
@property (nonatomic, copy) void (^editBlock)(LiveMediaControl *view);
//移除
@property (nonatomic, copy) void (^removeBlock)(LiveMediaControl *view);

@property (nonatomic, copy) void (^chatNameClickBlock)(LiveMediaControl *view, id linkData);

@property (nonatomic,copy) void(^sliderAction)(UISlider *slider);

+ (instancetype)liveMediaControl;

//设置观看人数
- (void)setViewNumber:(NSString *)number;

//设置直播标题
- (void)setLiveTitle:(NSString *)title;

- (void)showNoFade;

- (void)showAndFade;

- (void)hide;

- (void)show;

//显示消息
- (void)addChatMessage:(NSString *)message Error:(BOOL)error;

//显示倒计时
- (void)cutdownWithExpireTime:(NSDate *)expireDate;

//取消倒计时
- (void)cancelCutdownTime;

//开始直播计时
- (void)startCalculateTime;
//取消直播计时
- (void)cancelCalculateTime;

-(void)addNotificationCenter;
-(void)removeNotificationCenter;

- (void)showIndicator;
- (void)hideIndicator;
@end

//标题按钮，只显示文字或者只显示图片
@interface LiveMediaTitleButton : UIButton

@end

//分享的view
@interface LiveMediaShareView : UIView

@property (nonatomic, copy) void (^shareButtonBlock)(UIButton *button);

+ (instancetype)shareViewWith:(void (^)(UIButton *button))block;

@end

//分享的按钮
@interface LiveMediaShareButton : UIButton

+ (instancetype)shareButtonWith:(NSString *)imageName title:(NSString *)title;

@end

@interface ChatModel : NSObject

@property (nonatomic, copy) NSString *message;

//点击用户名附带的信息
@property (nonatomic, strong) id linkData;

//是否是主播发出的消息
@property (nonatomic,assign) BOOL isCreatorMessage;

- (instancetype)initWithMessage:(NSString *)message linkData:(id)linkData isCreatorMessage:(BOOL)isCreatorMessage;

@property (nonatomic, assign) CGFloat textHeight;

@property (nonatomic, strong) NSAttributedString *attributedString;

@property (nonatomic, assign) BOOL interactionEnabled;

@end

@class TYAttributedLabel;
@interface ChatViewCell : UITableViewCell

@property (nonatomic, strong) ChatModel *model;

@property (nonatomic, strong) TYAttributedLabel *attributedLabel;

@end

@interface ChatUserModel : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *userid;

@property (nonatomic, assign) BOOL slient;

+ (instancetype)modelWith:(NSString *)name andId:(NSString *)userId;

@end

@interface LiveCustomSlider : UISlider<UIGestureRecognizerDelegate>

@property (nonatomic ,strong) UITapGestureRecognizer * tapGesture;

@property (nonatomic,copy) void(^sliderTouch)();

@end