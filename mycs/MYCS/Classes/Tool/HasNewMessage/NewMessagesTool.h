//
//  NewMessagesTool.h
//  MYCS
//
//  Created by wzyswork on 16/3/16.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "NewMsgCountModel.h"

//获取未读消息数
@interface NewMessagesTool : NSObject

singleton_interface(NewMessagesTool)

@property (nonatomic,strong) NSTimer *timer;

- (void)startCheck;

- (void)checkNewMessage;

- (void)stopChecking;

@end
