//
//  FriendChatViewController.h
//  MYCS
//
//  Created by Yell on 16/1/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
@class FriendModel;

@interface FriendChatViewController : RCConversationViewController

@property (strong,nonatomic) FriendModel * model;

@end
