//
//  OfficeListCell.h
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OfficeContentModel.h"

@interface OfficeListCell : UITableViewCell


@property (nonatomic,assign) int type;

@property (nonatomic,strong) OfficeUnDetailModel * model;
@end
