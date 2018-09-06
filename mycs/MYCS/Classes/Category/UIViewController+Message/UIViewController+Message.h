//
//  UIViewController+Message.h
//  appdaily
//
//  Created by wilson on 14-3-1.
//  Copyright (c) 2014年 Maxicn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"

@interface UIViewController (Message)

/**
 *	loadindView
 */
-(void)showLoadingView:(int)topY;

-(void)dismissLoadingView;

/**
 *	@brief	弹窗显示错误信息，确定可回调
 *
 *	@param 	error 	错误对象
 *	@param 	delegate 	代理
 *	@param 	tag 	弹窗识别标签
 */
- (void)showError:(NSError *)error delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag;

/**
 *	@brief	弹窗显示错误信息，可回调
 *
 *	@param 	error 	错误对象
 *	@param 	cancel 	取消按钮
 *	@param 	other 	其他接钮
 *	@param 	delegate 	代理
 *	@param 	tag 	弹窗识别标签
 */
- (void)showError:(NSError *)error cancelButton:(NSString *)cancel otherButton:(NSString *)other delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag;

/**
 显示错误提醒，2秒后消失
 */
- (void) showError:(NSError*)error;

/**
 显示错误提醒，点击确定后消失
 */
- (void) showErrorMessage:(NSString *)errorMessage;

- (void)showErrorMessageHUD:(NSString *)message;

- (void)showSuccessWithStatusHUD:(NSString *)status;

- (void)showLoadingHUD;

- (void)showLoadingWithStatusHUD:(NSString *)status;

- (void)dismissLoadingHUD;

//搜索没有结果的提示
-(void)noDataTips:(UIViewController *)controller andSearchView:(UIView *)searcher andJudge:(BOOL)judge;


@end
