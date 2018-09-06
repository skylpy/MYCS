//
//  RelateVideoView.h
//  MYCS
//
//  Created by GuiHua on 16/7/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelateVideoView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

#pragma mark - 第四个View
//相关视频
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSArray *dataArr;

@property (nonatomic, assign) NSInteger numb;


@property (nonatomic,copy) void(^cellClickblock)(NSString *idStr);

+ (instancetype)relateVideoView;

@end
