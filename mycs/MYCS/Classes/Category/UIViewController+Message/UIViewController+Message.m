//
//  UIViewController+Message.m
//  appdaily
//
//  Created by wilson on 14-3-1.
//  Copyright (c) 2014年 Maxicn. All rights reserved.
//

#import "UIViewController+Message.h"
#import "SVProgressHUD.h"

@implementation UIViewController (Message)

- (void)showError:(NSError *)error
{
    if (error) {
        id userInfo = [error userInfo];
        NSString *errorMsg ;
        if([userInfo objectForKey:NSLocalizedFailureReasonErrorKey]){
            errorMsg = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
        }else if([userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey]){
            errorMsg = [userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey];
        }else{
            errorMsg = [error localizedDescription];
        }
        if(errorMsg){
            
            if([errorMsg isKindOfClass:[NSString class]]){
                errorMsg = [errorMsg stringByReplacingOccurrencesOfString:@"Error:" withString:@""];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                [alertView show];
            }
        }
    }
}

- (void)showError:(NSError *)error delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag
{
    if (error) {
        id userInfo = [error userInfo];
        NSString *errorMsg ;
        if([userInfo objectForKey:NSLocalizedFailureReasonErrorKey]){
            errorMsg = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
        }else if([userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey]){
            errorMsg = [userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey];
        }else{
            errorMsg = [error localizedDescription];
        }
        if(errorMsg){
            if([errorMsg isKindOfClass:[NSString class]]){
                errorMsg = [errorMsg stringByReplacingOccurrencesOfString:@"Error:" withString:@""];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:delegate cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                alertView.tag = tag;
                [alertView show];
            }
        }
    }
}

- (void)showError:(NSError *)error cancelButton:(NSString *)cancel otherButton:(NSString *)other delegate:(id<UIAlertViewDelegate>)delegate tag:(NSInteger)tag
{
    if (error) {
        id userInfo = [error userInfo];
        NSString *errorMsg ;
        if([userInfo objectForKey:NSLocalizedFailureReasonErrorKey]){
            errorMsg = [userInfo objectForKey:NSLocalizedFailureReasonErrorKey];
        }else if([userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey]){
            errorMsg = [userInfo objectForKey:NSLocalizedRecoverySuggestionErrorKey];
        }else{
            errorMsg = [error localizedDescription];
        }
        if(errorMsg){
            if([errorMsg isKindOfClass:[NSString class]]){
                errorMsg = [errorMsg stringByReplacingOccurrencesOfString:@"Error:" withString:@""];
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMsg delegate:delegate cancelButtonTitle:cancel otherButtonTitles:other, nil];
                alertView.tag = tag;
                [alertView show];
            }
        }
    }
}

- (void)showErrorMessage:(NSString *)errorMessage{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:errorMessage delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)showErrorMessageHUD:(NSString *)message {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showErrorWithStatus:message];
    
}

- (void)showSuccessWithStatusHUD:(NSString *)status {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showSuccessWithStatus:status];
    
}

- (void)showLoadingHUD {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD show];
    
}

- (void)showLoadingWithStatusHUD:(NSString *)status {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD showWithStatus:status];
    
}

- (void)dismissLoadingHUD {
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD dismiss];
    
}

//搜索没有结果的提示
-(void)noDataTips:(UIViewController *)controller andSearchView:(UIView *)searcher andJudge:(BOOL)judge{
    
    UILabel * la = [controller.view viewWithTag:7878];
    
    [la removeFromSuperview];
    
    UILabel * label = ({
        
        UILabel * label = [UILabel new];
        
        [label setText:@"没有相关数据！"];
        
        label.frame = CGRectMake(controller.view.width / 2 - 100,judge == YES ? CGRectGetMaxY(searcher.frame)+20 : 20, 200, 40);
        label.tag = 7878;
        
        label.textAlignment = NSTextAlignmentCenter;
        
        label.font = [UIFont systemFontOfSize:14];
        
        label.textColor = HEXRGB(0x999999);
        
        label;
    });
    [controller.view addSubview:label];
}

//加载中...
-(void)showLoadingView:(int)topY
{
    LoadingView *loadingView = [LoadingView shareLoadingView];
    loadingView.tag = 999999;
    loadingView.frame = CGRectMake(0, topY, ScreenW, ScreenH - topY - 49);
    [self.view addSubview:loadingView];
}
-(void)dismissLoadingView
{
    LoadingView *loadingView = (LoadingView *)[self.view viewWithTag:999999];
    if (loadingView)
    {
        [loadingView removeFromSuperview];
    }
}
@end

