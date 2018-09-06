//
//  EdictVideoViewController.h
//  MYCS
//
//  Created by wzyswork on 16/2/2.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoDetail.h"
#import "CourseDetail.h"
#import "SopDetail.h"

@interface EdictVideoViewController : UIViewController

@property (nonatomic,strong) VideoDetail * videoDetail;

@property (nonatomic,strong) CourseDetail * courseDetail;

@property (nonatomic,strong) SopDetail * sopDetail;

@property (nonatomic,copy) void(^sureBtnBlock)();

@end
