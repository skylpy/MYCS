//
//  CustomActionSheet.m
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "CustomActionSheet.h"

@interface CustomActionSheet ()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) UIButton *bgBtn;

@end

@implementation CustomActionSheet

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

-(void)showInView:(UIViewController *)controller andBlock:(void (^)(CustomActionSheet *, NSInteger))block
{
    self.block = block;
    
    self.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    [controller.navigationController.view addSubview:self];
}

-(void)layoutSubviews
{
    UIButton *bgBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = self.frame;
    bgBtn.backgroundColor = [UIColor blackColor];
    bgBtn.alpha = 0;
    [bgBtn addTarget:self action:@selector(hiddenSelf) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:bgBtn];
    UIView * btnsView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenH,ScreenW,140)];
    btnsView.backgroundColor = HEXRGB(0xF6F6F6);
    [self addSubview:btnsView];
    UIButton * camaraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    camaraBtn.frame = CGRectMake(0, 0, self.width, 45);
    camaraBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [camaraBtn setTitleColor:HEXRGB(0x333333) forState:UIControlStateNormal];
    [camaraBtn setTitle:self.firstTitle forState:UIControlStateNormal];
    [camaraBtn addTarget:self action:@selector(actionSheetclickedInButton:) forControlEvents:UIControlEventTouchUpInside];
    camaraBtn.backgroundColor = [UIColor whiteColor];
    camaraBtn.tag = 0;
    [btnsView addSubview:camaraBtn];
    UIView *firstMarginView = [[UIView alloc]initWithFrame:CGRectMake(0, camaraBtn.height-1, self.width, 1)];
    firstMarginView.backgroundColor = HEXRGB(0xD1D1D1);
    [btnsView addSubview:firstMarginView];

    
    UIButton * photoLibraryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    photoLibraryBtn.frame = CGRectMake(0, CGRectGetMaxY(camaraBtn.frame), self.width, 45);
    photoLibraryBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [photoLibraryBtn setTitleColor:HEXRGB(0x333333) forState:UIControlStateNormal];
    [photoLibraryBtn setTitle:self.secondTitle forState:UIControlStateNormal];
    [photoLibraryBtn addTarget:self action:@selector(actionSheetclickedInButton:) forControlEvents:UIControlEventTouchUpInside];
    photoLibraryBtn.backgroundColor = [UIColor whiteColor];
    photoLibraryBtn.tag = 1;
    [btnsView addSubview:photoLibraryBtn];
    UIView *secondMarginView = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(photoLibraryBtn.frame)-1, self.width, 1)];
    secondMarginView.backgroundColor = HEXRGB(0xD1D1D1);
    [btnsView addSubview:secondMarginView];
    
    UIButton * cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, CGRectGetMaxY(photoLibraryBtn.frame)+5, self.width, 45);
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitleColor:HEXRGB(0x333333) forState:UIControlStateNormal];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(actionSheetclickedInButton:) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.backgroundColor = [UIColor whiteColor];
    cancelBtn.tag = 2;
    [btnsView addSubview:cancelBtn];
    
    self.contentView = btnsView;
    self.bgBtn = bgBtn;
    
    [UIView animateWithDuration:0.25 animations:^{
        bgBtn.alpha = 0.4;
        btnsView.y = ScreenH - 140;
    }];

}

-(void)hiddenSelf
{
    [UIView animateWithDuration:0.25 animations:^{
        self.contentView.y = ScreenH;
        self.bgBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)actionSheetclickedInButton:(UIButton *)btn
{
    if (self.block)
    {
        self.block(self,btn.tag);
    }
}


@end
