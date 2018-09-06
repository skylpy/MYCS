//
//  TaskSelectObjectController.h
//  MYCS
//
//  Created by yiqun on 16/8/30.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskSelectObjectController : UIViewController

@property (assign,nonatomic)BOOL isFirstCome;
@property (nonatomic,strong) NSArray *sourceData;
@property (retain,nonatomic)NSString * deptName;
@property (nonatomic,strong) NSMutableArray *titArr;

@property (retain,nonatomic)NSArray * allData;

@property (nonatomic,copy) void(^enterItemBlock)(NSArray *);


@end

