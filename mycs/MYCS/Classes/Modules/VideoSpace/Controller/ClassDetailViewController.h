//
//  ClassDetailViewController.h
//  MYCS
//
//  Created by GuiHua on 16/4/27.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ZHWebViewController.h"

#import <JavaScriptCore/JavaScriptCore.h>

@protocol JavaScriptObjectiveCClassDetailDelegate <JSExport>

-(void)call:(NSString*)type withId:(NSString *)idStr;

@end

@interface ClassDetailViewController : ZHWebViewController

//活动ID
@property (nonatomic,copy) NSString *activityId;

//课程id
@property (nonatomic, copy) NSString *coursePackId;

//分享的Url
@property (nonatomic, copy) NSString *shareURL;

//是否从活动进入,YES代表是，
@property (nonatomic,assign,getter=isActivity) BOOL activity;

@end
