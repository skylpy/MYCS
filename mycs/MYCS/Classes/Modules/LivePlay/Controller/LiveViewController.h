//
//  LiveViewController.h
//  MYCS
//
//  Created by GuiHua on 16/6/17.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveListModel.h"

typedef NS_ENUM(int, LiveType){
    //直播中
    OnLive = 2,
    //未开播
    AfterLive = 1,
    //结束直播
    EndLive = 4
};

@interface LiveViewController : UIViewController

@property (nonatomic ,assign) LiveType liveType;

@property (nonatomic ,strong) NSMutableArray *dataArr;

-(void)reloadNewsData;

@end

@interface LiveCell : UITableViewCell

@property (nonatomic ,assign) LiveType liveType;

@property (nonatomic ,strong) LiveListModel *model;

@end