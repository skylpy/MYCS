//
//  HealthDetailController.h
//  MYCS
//
//  Created by GuiHua on 16/7/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HealthDetailController : UIViewController

@property (nonatomic, copy) NSString *detailId;

@property (nonatomic,assign) int buttonType;//0-为疾病，专题片，微电影，1-宣传片

@end

