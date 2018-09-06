//
//  PushControllerView.h
//  MYCS
//
//  Created by wzyswork on 16/1/25.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushControllerView : NSObject

//前台
+(void)showDetailCotrollerViewInForegroundWithUserInfo:(NSDictionary *)userInfo;

//后台
+(void)showDetailCotrollerViewInBackgroundWithUserInfo:(NSDictionary *)userInfo;

//退出登录
+(void)showOtherPlaceloginCurrentUserCode;
@end
