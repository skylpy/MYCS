//
//  HomeMedicineController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@class ShopListItemModel,CoursePackListModel;

@interface HomeMedicineController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@interface HomeMedicineCell : UICollectionViewCell

@property (nonatomic, strong) ShopListItemModel *itemModel;

@property (nonatomic, strong) CoursePackListModel *packModel;

@end
