//
//  MailBoxDetailViewController.h
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MailBoxDetailViewController : UIViewController

@property (nonatomic,assign) int type;

@property (nonatomic,copy) NSString *inMessageID;

@property (nonatomic,copy) NSString *outMessageID;

@end
