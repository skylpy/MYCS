//
//  ImageScrollView.h
//  MYCS
//
//  Created by GuiHua on 16/7/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScrollView : UIScrollView

@property (nonatomic ,strong) UIImageView *imgView;

//记录自己的位置
@property (nonatomic ,assign) CGRect scaleOriginRect;

//图片的大小
@property (nonatomic ,assign) CGSize imgSize;

//缩放前大小
@property (nonatomic ,assign) CGRect initRect;

@property (nonatomic ,assign) BOOL isLoading;

@property (nonatomic ,strong) UILabel * contentL;

@property (nonatomic,copy) void(^ShowContentLblock)();

@property (strong, nonatomic)  UIActivityIndicatorView *indicatorView;

- (void) setOriginAnimationRect:(CGRect) rect;
- (void) setImage:(UIImage *) image;
- (void) setAnimationRect;
- (void) rechangeInitRdct;
- (void) setNewImage:(UIImage *) image;
- (void) setContentStr:(NSString *)str;

@end
