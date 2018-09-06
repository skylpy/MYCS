//
//  SelectSourceController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/11.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectSourceController : UIViewController

@property (nonatomic,copy) void(^sureBtnBlock)(NSString *selectStr);

@property (nonatomic,assign) BOOL isPostSystemViewController;

@end

