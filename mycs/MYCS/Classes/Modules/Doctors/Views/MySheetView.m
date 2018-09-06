//
//  MySheetView.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "MySheetView.h"

#import <objc/runtime.h>

@interface MySheetView ()

@property (weak, nonatomic) IBOutlet UIView *sheetView;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation MySheetView

+ (void)showInView:(UIViewController *)view andBlock:(void (^)(MySheetView *, NSInteger))block{
    
    MySheetView *sheet = [[[NSBundle mainBundle] loadNibNamed:@"MySheetView" owner:nil options:nil] lastObject];
    
    if (iS_IOS8LATER)
    {
        sheet.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    }
    else
    {
        sheet.frame = CGRectMake(0, 0, ScreenH, ScreenW);
    }
    
    [view.view addSubview:sheet];
    
    sheet.block = block;
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    if (touch.view == self || touch.view == self.bgView)
    {
        [self cancelBtnAction:nil];
    }
    
}
- (IBAction)cancelBtnAction:(id)sender {
    
    [self removeSelfFromSuperview];
    
    if (self.block)
    {
        self.block(self,0);
    }
}

-(void)removeSelfFromSuperview
{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.bgView.alpha = 0;
        self.sheetView.y = ScreenW;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}
- (IBAction)saveAction:(id)sender {
    
    
    UIButton * btn = (UIButton *)sender;
    
    if (self.block)
    {
        self.block(self,btn.tag);
    }
    
    [self removeSelfFromSuperview];
    
}

- (IBAction)addAction:(id)sender {
    
    
    UIButton * btn = (UIButton *)sender;
    
    if (self.block)
    {
        self.block(self,btn.tag);
    }
    
    [self removeSelfFromSuperview];
    
}

- (void)setBlock:(void (^)(MySheetView *, NSInteger))block
{
    objc_setAssociatedObject(self, @selector(block), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(MySheetView *, NSInteger))block
{
    return objc_getAssociatedObject(self, @selector(block));
}
@end
