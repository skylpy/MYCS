//
//  CoverView.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "CoverView.h"

@interface CoverView ()

@property (nonatomic,copy) void(^touchBlock)(CoverView *view);

@end

@implementation CoverView

- (instancetype)initWithFrame:(CGRect)frame {
    if ([super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

+ (instancetype)showInView:(UIView *)view frame:(CGRect)frame touchBlock:(void (^)(CoverView *view))touchBlock {
    
    CoverView *coverView = [CoverView new];
    
    coverView.touchBlock = touchBlock;
    
    coverView.frame = frame;
    [view addSubview:coverView];
    
    [coverView showAnimation];
    
    
    return coverView;
}

- (void)showAnimation {
    
    self.alpha = 0;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0.4;
    }];
    
}

- (void)dismiss {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.alpha = 0;

    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.touchBlock)
    {
        self.touchBlock(self);
    }
}

@end
