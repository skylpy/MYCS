//
//  ReleaseLiveViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/4/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReleaseLiveViewController : UITableViewController

@property (atomic, assign) Boolean IsHorizontal;

@property (nonatomic ,copy) NSString *roomId;

@property (nonatomic,copy) void (^releaseButtonBlock)();

@end

@interface LiveReleaseParamModel : NSObject

@property (nonatomic,copy) NSString *roomId;
@property (nonatomic,copy) NSString *cateId;
@property (nonatomic,copy) NSString *anchorIntro;
@property (nonatomic,copy) NSString *anchor;
@property (nonatomic,copy) NSString *liveTime;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *coverId;
@property (nonatomic,copy) NSString *extPermission;
@property (nonatomic,copy) NSString *detail;
@property (nonatomic,copy) NSString *checkWord;

@end
