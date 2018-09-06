//
//  PaperAlertView.h
//  SWWY
//
//  Created by GuoChenghao on 15/3/24.
//  Copyright (c) 2015年 GuoChenghao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger,AlertViewType) {
    AlertViewTypeSubmit,    //提交试卷
    AlertViewTypeCheckAll,  //答完所有题目
    AlertViewTypePass,  //考核通过
    AlertViewTypeUnPass,    //考核不通过
    AlertViewTypeNext  //播放下一章节
};

@interface PaperAlertView : UIView

@property (strong, nonatomic) NSString *message;

@property (nonatomic,assign) AlertViewType alertType;

/**
 *  1：只有一个确定按钮
 */
@property (assign, nonatomic) NSInteger type;

+ (instancetype)showInView:(UIView *)view message:(NSString *)message With:(AlertViewType)alertType usingBlock:(void (^)(PaperAlertView *alertView, NSInteger buttonIndex))block;

@end
