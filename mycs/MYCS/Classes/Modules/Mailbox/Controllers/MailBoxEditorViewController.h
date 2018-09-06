//
//  MailBoxEditorViewController.h
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailBoxEditorViewController : UIViewController

@property (strong, nonatomic) NSMutableArray *peopleList;

@property (strong,nonatomic) NSMutableArray *answerList;

@property (copy, nonatomic) NSString *titleContent;

@property (copy, nonatomic) NSString *content;

@property (atomic, assign) Boolean IsHorizontal;

//任务提醒的时候用
@property (nonatomic,strong) NSString * endTime;

// 0：表示发新邮件 1：表示回复 2:表示再发一封 3:表示转发 4:任务提醒
@property (assign, nonatomic) int sendType;

//回复用
@property (strong, nonatomic) NSString *from_uid; //发送者id
@property (strong, nonatomic) NSString *modelID; //消息id，通过此id查询消息详细信息

@end
