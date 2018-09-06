//
//  SelectOfficeController.h
//  MYCS
//
//  Created by GuiHua on 16/8/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectOfficeController : UICollectionViewController

@property (nonatomic,copy)NSString *selectID;
@property (nonatomic, copy) void (^selectBackBlock)(NSString *strName,NSString *strId);

@end

@class ClassModel;
@interface SelectOfficeCell : UICollectionViewCell

@property (nonatomic,strong) ClassModel *model;
@property (nonatomic, copy) void (^selectCellBackBlock)(NSString *strName,NSString *strId);

@end