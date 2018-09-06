//
//  UserCenterImagePickerView.h
//  MYCS
//
//  Created by AdminZhiHua on 15/11/17.
//  Copyright © 2015年 AdminZhiHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCenterImagePickerView : UIView

@property (nonatomic,strong) void(^completeBlock)(UserCenterImagePickerView *view,NSUInteger index);

+ (void)showWithComplete:(void(^)(UserCenterImagePickerView *view,NSUInteger index))block;

@end
