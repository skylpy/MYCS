//
//  TaskDescViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskDescViewController : UIViewController

@property (nonatomic,copy) void(^editCompleteBlock)(NSString *desc);

@property (nonatomic,copy) NSString *descString;

@end
