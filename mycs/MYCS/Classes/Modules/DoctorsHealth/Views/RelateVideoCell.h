//
//  RelateVideoCell.h
//  MYCS
//
//  Created by GuiHua on 16/7/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoctorsHealthList.h"

@interface RelateVideoCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *urlImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailL;

@property (nonatomic,strong) DoctorsHealthRelate *model;

@end
