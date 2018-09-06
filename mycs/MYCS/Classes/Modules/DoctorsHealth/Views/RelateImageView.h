//
//  RelateImageView.h
//  MYCS
//
//  Created by GuiHua on 16/7/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RelateImageView : UIView
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imageViewArrs;

@property (weak, nonatomic) IBOutlet UILabel *titleL;

//图片数目
@property (weak, nonatomic) IBOutlet UILabel *numberL;

@property (nonatomic ,strong) NSArray *imageArrs;

@property (nonatomic,copy) void(^tapImageViewblock)(UIImageView *imageView,NSInteger index);

+ (instancetype)relateImageView;

@end
