//
//  HealthPictureView.h
//  MYCS
//
//  Created by GuiHua on 16/7/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScrollView.h"

@interface HealthPictureView : UIView<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *titleL;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (nonatomic ,assign) BOOL ishowTopView;

@property (nonatomic ,strong) NSArray *imageArrs;

@property (nonatomic ,strong) NSMutableArray *imageScrollViewArrs;

@property (nonatomic ,strong) UIImageView *tapImageView;

@property (nonatomic, assign) int currentIndex;

- (void)setImageArrs:(NSArray *)imageArrs andCurrentIndex:(int)currentIndex andImageView:(UIImageView *)imageView;

+ (instancetype)healthPictureView;

@end
