//
//  ServiceDetailsController.h
//  MYCS
//
//  Created by wzyswork on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceDetailsController : UIViewController

@property (nonatomic,strong) void(^memberDetailVCRefleshBlock)();

/**
 *  会员ID
 */
@property (strong, nonatomic) NSString *memberIDString;

@end
