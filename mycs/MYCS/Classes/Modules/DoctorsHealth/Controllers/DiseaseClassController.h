//
//  DiseaseClassController.h
//  MYCS
//
//  Created by GuiHua on 16/7/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DoctorsHealthList.h"

@interface DiseaseClassController : UIViewController

@property (nonatomic,copy) NSString *selectId;

@property (copy, nonatomic) void (^DiseaseClassCellClickblock)(NSString *name,NSString *idStr);

@end


@interface DiseaseClassCell : UICollectionViewCell

@property (nonatomic, strong) DoctorsHealthClass * model;

@property (copy, nonatomic) void (^CellClickblock)(NSString *name,NSString *idStr);

@end