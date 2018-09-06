//
//  OnLiveViewController.h

//  MYCS
//
//  Created by AdminZhiHua on 16/4/20.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LiveListModel;
@interface OnLiveViewController : UIViewController

@property (nonatomic ,copy) NSString *roomId;

@property (nonatomic, assign) BOOL IsHorizontal;

@property (nonatomic,copy) void (^sureButtonBlock)();

@property (nonatomic,strong) LiveListModel *listModel;

@end
