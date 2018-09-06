//
//  HealthHomeCell.h
//  MYCS
//
//  Created by GuiHua on 16/7/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorsHealthList.h"

@interface HealthHomeCell : UITableViewCell

@property (nonatomic,strong) DoctorsHealthList *model;

-(void)setTypeLHide;
@end
