//
//  ShareToolBar.h
//  MYCS
//
//  Created by wzyswork on 16/2/23.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ShareToolBar : UIView

@property (nonatomic,assign) void(^block)(NSString * typeStr,ShareToolBar * toolBar);

+(instancetype)shareToolBar;

- (void)showInView:(UIView *)view Block:(void(^)(NSString * typeStr,ShareToolBar * toolBar))block;


@end
