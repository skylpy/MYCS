//
//  LiveEditIntroViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/4/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveEditIntroViewController : UIViewController

@property (nonatomic , copy) NSString * content;

@property (nonatomic, copy) void (^saveBlock)(NSString *content);

@end
