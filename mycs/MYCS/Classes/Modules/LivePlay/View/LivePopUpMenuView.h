//
//  LivePopUpMenuView.h
//  MYCS
//
//  Created by AdminZhiHua on 16/4/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LivePopUpMenuView : UIView

+ (void)showInView:(UIView *)view fromRect:(CGRect)rect withItems:(NSArray *)items itemClick:(void (^)(NSInteger idx))block;

@end

@interface LivePopUpMenuItem : NSObject

@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *title;

+ (instancetype)itemWith:(NSString *)imageName title:(NSString *)title;

@end

@interface LivePopUpMenuCell : UITableViewCell

@property (nonatomic, strong) LivePopUpMenuItem *item;

@property (nonatomic, strong) UIButton *button;

@end
