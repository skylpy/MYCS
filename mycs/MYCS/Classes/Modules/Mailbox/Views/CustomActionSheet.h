//
//  CustomActionSheet.h
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomActionSheet : UIView

@property (copy, nonatomic) void (^block)(CustomActionSheet *sheet, NSInteger buttonIndex);

-(void)showInView:(UIViewController *)controller andBlock:(void (^)(CustomActionSheet *, NSInteger))block;

-(void)hiddenSelf;


@property(nonatomic,copy) NSString *firstTitle;

@property(nonatomic,copy) NSString *secondTitle;

@end
