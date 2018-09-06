//
//  InformationCell.h
//  MYCS
//
//  Created by wzyswork on 16/1/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InfomationModel.h"
#import "UIImageView+WebCache.h"

@interface InformationCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *ImageView;

@property (weak, nonatomic) IBOutlet UILabel *TitleL;

@property (weak, nonatomic) IBOutlet UILabel *ContentL;

@property (nonatomic,strong) InfomationModel *model;

@end
