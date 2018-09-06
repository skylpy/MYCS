//
//  ActivityDetailController.h
//  MYCS
//
//  Created by wzyswork on 16/3/30.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ZHWebViewController.h"
#import "ActivityModel.h"

@interface ActivityDetailController : ZHWebViewController

@property (nonatomic, strong) ActivityParamModel *detailModel;

//活动ID
@property (nonatomic,copy) NSString *activityId;

@end
