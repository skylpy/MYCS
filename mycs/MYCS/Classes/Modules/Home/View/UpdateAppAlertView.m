//
//  UpdateAppAlertView.m
//  MYCS
//
//  Created by GuiHua on 16/4/25.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "UpdateAppAlertView.h"

@implementation UpdateAppAlertView

-(void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated
{
   
    if (![[self buttonTitleAtIndex:buttonIndex]isEqualToString:@"取消"])
    {
        return;
    }else
    {
        [super dismissWithClickedButtonIndex:buttonIndex animated:animated];
    }
}

@end
