//
//  NetworkAnomalyView.h
//  MYCS
//
//  Created by GuiHua on 16/5/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkAnomalyView : UIView

@property (weak, nonatomic) IBOutlet UIButton *refleshButton;

@property (weak, nonatomic) IBOutlet UIButton *closeButton;

@property (nonatomic,copy) void(^buttonBlock)(NetworkAnomalyView *networkAnomalyView, NSInteger index);

+(instancetype)networkAnomalyView;

@end
