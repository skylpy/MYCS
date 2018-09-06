//
//  PopUpView.h
//  退出二次确认
//
//  Created by yiqun on 16/4/15.
//  Copyright © 2016年 yiqun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopUpView : UIView

+ (instancetype)popUpView;

@property (nonatomic,copy) void (^block)(NSInteger index);

-(void)showInitView:(UIViewController *)controller array:(NSArray *)array bools:(BOOL)bools block:(void (^)(NSInteger index))block;

@end

/*!
 @author Sky, 16-04-18 14:04:33
 
 @brief PopUpCell
 
 @since
 */
@interface PopUpCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLable;

@end
/*!
 @author MYCS, 16-04-18 11:04:59
 
 @brief ComfirmModel
 
 @since
 */
@interface ComfirmModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, strong) UIColor *titleColor;

+ (instancetype)comfirmModelWith:(NSString *)title titleColor:(UIColor *)color;

// 动态高度
+ (CGSize)countingSize:(NSString *)str fontSize:(int)fontSize width:(float)width;

@end
