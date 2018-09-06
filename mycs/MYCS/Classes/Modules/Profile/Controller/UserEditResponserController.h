//
//  UserEditResponserController.h
//  MYCS
//
//  Created by AdminZhiHua on 15/11/18.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserEditResponserController : UITableViewController
@property (nonatomic,copy) void(^SureResponserBlock)();
@end
