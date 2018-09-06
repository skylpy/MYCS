//
//  ShareToolBar.m
//  MYCS
//
//  Created by wzyswork on 16/2/23.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ShareToolBar.h"
#import <UMengSocial/WXApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "UIView+Message.h"
#import <objc/runtime.h>
#import "UMSocialSnsPlatformManager.h"
@interface ShareToolBar ()

@property (weak, nonatomic) IBOutlet UIView *shareView;

@property (weak, nonatomic) IBOutlet UIView *sheetView;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation ShareToolBar

+(instancetype)shareToolBar
{
    return [[[NSBundle mainBundle] loadNibNamed:@"ShareToolBar" owner:nil options:nil] lastObject];
}

- (void)showInView:(UIView *)view Block:(void (^)(NSString *, ShareToolBar *))block{
    
    if (iS_IOS8LATER)
    {
        self.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    }
    else
    {
        self.frame = CGRectMake(0, 0, ScreenH, ScreenW);
    }
    [view addSubview:self];
    
    [view bringSubviewToFront:self];
    self.sheetView.y = ScreenW;
    self.block = block;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0.4;
        self.sheetView.y = 0;
    } completion:nil];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self cancelBtnAction:nil];
    
    
}
- (IBAction)cancelBtnAction:(id)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0;
        self.sheetView.y = ScreenW;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (IBAction)shareAction:(UIButton *)sender {
    
    [self cancelBtnAction:nil];
    
    NSString * typeStr;
    
    if (sender.tag == 0)
    {
        if ([WXApi isWXAppInstalled])
        {
            typeStr = UMShareToWechatSession;
            
        }else
        {
            [self showErrorMessage:@"你没有安装微信"];
            
            return;
        }
    }else if(sender.tag == 1)
    {
        if ([WXApi isWXAppInstalled])
        {
            typeStr = UMShareToWechatTimeline;
        }else
        {
            [self showErrorMessage:@"你没有安装微信"];
            return;
        }
        
    }else if (sender.tag == 2)
    {
        if ([QQApiInterface isQQInstalled])
        {
            typeStr = UMShareToQQ;
        }else
        {
            [self showErrorMessage:@"你没有安装QQ"];
            return;
        }
        
    }else if (sender.tag == 3)
    {
        if ([QQApiInterface isQQInstalled])
        {
            typeStr = UMShareToQzone;
        }else
        {
            [self showErrorMessage:@"你没有安装QQ或QQ空间"];
            return;
        }
        
    }
    
    self.block(typeStr,self);
}

- (void)setBlock:(void (^)(NSString *, ShareToolBar *))block
{
    objc_setAssociatedObject(self, @selector(block), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(NSString *, ShareToolBar *))block
{
    return objc_getAssociatedObject(self, @selector(block));
}

@end
