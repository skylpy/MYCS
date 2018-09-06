//
//  PersonalInformationViewController.h
//  MYCS
//
//  Created by Yell on 16/1/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendModel.h"

@interface PersonalInformationViewController : UIViewController

@property (strong,nonatomic) FriendModel * model;

//yes 为来自聊天界面
@property (nonatomic,assign) BOOL  isComeFromChatView;

@end
