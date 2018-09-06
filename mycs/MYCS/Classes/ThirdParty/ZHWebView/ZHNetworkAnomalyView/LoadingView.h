//
//  LoadingView.h
//  MYCS
//
//  Created by GuiHua on 16/4/26.
//  Copyright © 2016年 GuiHua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoadingView : UIView

+(instancetype)shareLoadingView;

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end
