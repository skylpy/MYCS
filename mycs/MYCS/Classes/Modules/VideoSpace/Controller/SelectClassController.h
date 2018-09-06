//
//  SelectClassController.h
//  MYCS
//
//  Created by AdminZhiHua on 16/1/9.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SelectCompleteBlock)(NSString *selectIdStr,NSString * vipIdStr);

@interface SelectClassController : UIViewController

@property (nonatomic,strong) SelectCompleteBlock completeBlock;

@property (nonatomic,strong) NSString * selectId;
@property (nonatomic,strong) NSString * selectVipId;

@end

@class ClassModel;
@interface SelectClassCell : UICollectionViewCell

@property (nonatomic,strong) ClassModel *model;

@property (nonatomic,retain)NSArray * arrSelect;

@end