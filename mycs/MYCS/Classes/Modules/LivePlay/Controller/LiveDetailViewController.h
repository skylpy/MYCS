//
//  LiveDetailViewController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/4/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LiveDetailType) {

    LiveDetailTypeSelf = 0,

    LiveDetailTypeOther = 1 << 1

};

@interface LiveDetailViewController : UIViewController

@property (nonatomic, assign) LiveDetailType type;

@end
