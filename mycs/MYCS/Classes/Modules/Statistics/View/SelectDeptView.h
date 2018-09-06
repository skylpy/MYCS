//
//  SelectDeptView.h
//  MYCS
//
//  Created by GuiHua on 16/4/21.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectDeptView : UIView

@property (nonatomic,copy) void(^sureBtnBlock)(NSString *deptId,NSString * deptName);

+(void)showInView:(UIViewController *)view WithCurrentDeptId:(NSString *)deptid
       andGovType:(NSString *)govType WithBlock:(void(^)(NSString *deptId,NSString * deptName))sureBlock;

@end
