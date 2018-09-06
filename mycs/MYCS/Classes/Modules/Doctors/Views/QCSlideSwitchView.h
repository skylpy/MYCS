//
//  QCSlideSwitchView.h
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QCSlideSwitchViewDelegate;

@interface QCSlideSwitchView : UIView<UIScrollViewDelegate>{
    BOOL _isLeftScroll;                             //是否左滑动
    BOOL _isRootScroll;                             //是否主视图滑动
    BOOL _isBuildUI;                                //是否建立了ui
    UIView *_shadowView;
    CGFloat kFontSizeOfTabButton;
}

@property (nonatomic) CGFloat heightOfTopScrollView;
@property (nonatomic) CGFloat widthOfButtonMargin;
@property (nonatomic, strong) UIScrollView *rootScrollView;
@property (nonatomic, strong) UIScrollView *topScrollView;
@property (nonatomic) CGFloat userContentOffsetX;
@property (nonatomic) NSInteger userSelectedChannelID;
@property (nonatomic) NSInteger scrollViewSelectedChannelID;
@property (nonatomic, weak) id<QCSlideSwitchViewDelegate> slideSwitchViewDelegate;
@property (nonatomic, strong) UIColor *tabItemNormalColor;
@property (nonatomic, strong) UIColor *tabItemSelectedColor;
@property (nonatomic, strong) UIColor *topBackgroundColor;
@property (nonatomic, strong) UIImage *tabItemNormalBackgroundImage;
@property (nonatomic, strong) UIImage *tabItemSelectedBackgroundImage;
@property (nonatomic, strong) UIView *scrollBar;
@property (nonatomic, strong) NSMutableArray *viewArray;
@property (nonatomic) NSInteger selectViewControllerIndex;
@property (nonatomic) CGFloat scrollBarWidth; // 若大于0，则滚动条的宽度以该值为准，否则动态计算


- (void)buildUI;

- (void)setButtonsName:(NSArray*)nameArray;

- (void)changeViewWithIndex:(NSInteger)index;

@end

@protocol QCSlideSwitchViewDelegate <NSObject>

@required

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view;

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number;

@optional

- (void)slideSwitchView:(QCSlideSwitchView *)view panLeftEdge:(UIPanGestureRecognizer*) panParam;

- (void)slideSwitchView:(QCSlideSwitchView *)view panRightEdge:(UIPanGestureRecognizer*) panParam;

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number;

@end
