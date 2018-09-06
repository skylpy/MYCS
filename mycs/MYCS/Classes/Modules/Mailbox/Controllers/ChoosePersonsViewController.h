//
//  ChoosePersonsViewController.h
//  MYCS
//
//  Created by wzyswork on 16/1/11.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChoosePersonsViewController : UIViewController

@property (nonatomic,copy) void(^sureBtnBlock)(NSArray *results,int type);

@property (assign,nonatomic) BOOL isMember;

@property (assign,nonatomic) BOOL fromTask;

@property (strong,nonatomic) NSMutableArray * selectStaff;

@property (strong,nonatomic) NSMutableArray * selectMem;

@end
