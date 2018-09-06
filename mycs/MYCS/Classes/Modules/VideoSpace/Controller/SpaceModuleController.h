//
//  SpaceModuleController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger,SpaceModuleType) {
    SpaceModuleTypeVideo = 1,
    SpaceModuleTypeCourse = 2,
    SpaceModuleTypeSOP = 3
};

@class VideoSpaceModel;
@interface SpaceModuleController : UIViewController

@property (assign,nonatomic)NSInteger index;

//1.action为basic，id为空：基础教程；
//2.action为basic，id不为空：获取分类id为id的教程信息；
//3.action为list，id为空：本院教程；
//4.action为list，id不为空：获取岗位id为id的教程信息；
@property (nonatomic,copy) NSString *idStr;

@property (nonatomic,copy) NSString *vipStr;

@property (nonatomic,copy) NSString *actionStr;

@property (nonatomic,assign) SpaceModuleType moduleType;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

//cell点击的事件
@property (nonatomic,copy) void(^cellClickAction)(VideoSpaceModel *model,SpaceModuleType moduleType);

- (void)refreshData;

@end

@interface SpaceModuleCell : UICollectionViewCell

@property (nonatomic,strong) VideoSpaceModel *model;

@property (nonatomic,copy) NSString *actionType;

@end