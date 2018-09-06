//
//  FriendConversationViewController.h
//  MYCS
//
//  Created by Yell on 16/1/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@class FriendConversationViewController;
@protocol FriendConversationViewControllerDelegate <NSObject>

-(void)selectListCellWithTargetId:(NSString *)targetId;

@end


@interface FriendConversationViewController : RCConversationListViewController

@property(assign,nonatomic) id<FriendConversationViewControllerDelegate> listDelegate;


@end
