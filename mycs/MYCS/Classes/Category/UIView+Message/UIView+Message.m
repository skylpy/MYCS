//
//  UIView+Message.m
//  swwy_ipad
//
//  Created by Yell on 15/9/6.
//  Copyright (c) 2015年 zhihua. All rights reserved.
//

#import "UIView+Message.h"
#import "SVProgressHUD.h"

@implementation UIView (Message)

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
            
            [SVProgressHUD showErrorWithStatus:errorMsg];
            [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        }
        
    }
}

- (void)showErrorMessage:(NSString *)message{
    
    [SVProgressHUD showErrorWithStatus:message];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (void)showSuccessWithStatus:(NSString *)status{
    
    [SVProgressHUD showSuccessWithStatus:status];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (void)showLoading{
    
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (void)showLoadingWithStatus:(NSString *)status{
    
    [SVProgressHUD showWithStatus:status];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
}

- (void)dismissLoading{
    [SVProgressHUD dismiss];
}


@end
