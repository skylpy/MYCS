//
//  CountDownButton.h
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountDownButton : UIButton

@property (strong, nonatomic) NSString *normalString;

- (void)startCountDown:(int)time;

@end
