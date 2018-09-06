//
//  ChooseDeptsViewController.h
//  MYCS
//
//  Created by wzyswork on 16/1/11.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseDeptsViewController : UIViewController

@property (nonatomic,assign)BOOL isMember;

@property (nonatomic,copy) void(^sureBtnBlock)(NSArray *results,int type);

@property (nonatomic,strong) NSMutableArray *selectDep;

@end
