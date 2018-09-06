//
//  WatchLiveViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/4/28.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LiveMediaPlayStatus) {
    MediaPlayStatusUnknow,
    MediaPlayStatusPlay,
    MediaPlayStatusPause,
    MediaPlayStatusCache,
    MediaPlayStatusFinish
};

@class LiveListModel;
@interface WatchLiveViewController : UIViewController

@property (nonatomic, assign, getter=isLiveEnd) BOOL liveEnd;

@property (nonatomic ,copy) NSString *roomId;

@property (nonatomic,strong) LiveListModel *listModel;

@property (nonatomic ,assign) int liveType;

@end
