//
//  StudyStatisticsViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/4/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ZHWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JavaScriptStudyStaticsDeleagte <JSExport>

-(void)selectTime;

@end

//学习统计
@interface StudyStatisticsViewController : ZHWebViewController

@end
