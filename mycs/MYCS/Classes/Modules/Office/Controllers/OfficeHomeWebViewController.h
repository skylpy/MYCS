//
//  OfficeHomeWebViewController.h
//  MYCS
//
//  Created by money on 16/4/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ZHWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@protocol JavaScriptObjectiveCPageDelegate <JSExport>

-(void)homePageWithGroupId:(NSString *)groupId andUid:(NSString *)uid;

@end

@interface OfficeHomeWebViewController : ZHWebViewController

@end
