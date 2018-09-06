//
//  HomeViewController.h
//  MYCS
//
//  Created by GuiHua on 16/7/20.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZHCycleView;
@interface HomeViewController : UIViewController

@end

@interface HomeCollectionReusableView : UICollectionReusableView

@property (nonatomic,strong) NSArray *focus;

@property (nonatomic,strong) NSMutableArray *imageUrlArrs;

@property (nonatomic,copy) void(^tapButtonViewblock)(NSInteger index);

@property (strong, nonatomic) ZHCycleView *LoopScrollView;

@end
