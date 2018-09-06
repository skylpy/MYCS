//
//  PushBarView.h
//  MYCS
//
//  Created by wzyswork on 16/2/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PushModel.h"

@class PushBarView;

typedef void(^PushBarClickBlock)(PushBarView *pushBar,PushModel * model);

@interface PushBarView : UIView
{
    PushBarClickBlock _pushBarClickBlock;
}

@property (nonatomic,strong)PushModel * model;

-(void)showWithModel:(PushModel *)model DismissAfter:(NSTimeInterval)time;

-(void)handleClickAction:(PushBarClickBlock)pushBarClickBlock;

- (void)dismiss;

@end


