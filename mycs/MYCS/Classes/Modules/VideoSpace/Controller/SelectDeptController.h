//
//  SelectDeptController.h
//  MYCS
//
//  Created by yiqun on 16/9/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDeptController : UIViewController

@property (nonatomic,copy) void(^sureBtnBlock)(NSString *selectStr);

@property (nonatomic,assign) BOOL isPostSystemViewController;

@property (assign,nonatomic)BOOL isFirstCome;
@property (nonatomic,strong) NSArray *sourceData;
@property (retain,nonatomic)NSString * deptName;
@property (nonatomic,strong) NSMutableArray *titArr;

@property (retain,nonatomic)NSArray * allData;

@end
