//
//  StaticsViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/3/16.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ZHWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JavaScriptStaticsDeleagte <JSExport>

- (void)selectDept:(NSString *)deptId;

-(void)selectTime;

@end

@interface StaticsViewController : ZHWebViewController

@end
