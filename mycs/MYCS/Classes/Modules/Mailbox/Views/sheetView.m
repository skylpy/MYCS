//
//  sheetView.m
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "sheetView.h"

@implementation sheetView

+(instancetype)getSheetView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"sheetView" owner:self options:nil] lastObject];
}
-(void)awakeFromNib
{
    
    [super awakeFromNib];
    self.bgView.layer.cornerRadius = 6.0;
    self.bgView.clipsToBounds = YES;
    
}
- (IBAction)clikBtn:(UIButton *)sender
{
    
    if (self.block)
    {
        self.block(self, sender.tag);
    }
    
    [self removeFromSuperview];
}

- (void)showView:(UIViewController *)view andY:(NSInteger)y SheetBlock:(void (^)(sheetView *, NSInteger))block
{
    self.height = ScreenH - 64;
    self.width = ScreenW;
    self.x = 0;
    if (!iS_IOS8LATER && y == 52)
    {
        self.y = y + 64;
    }
    else
    {
        self.y = y;
    }
    [view.view addSubview:self];
    self.block = block;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self removeFromSuperview];
}
@end
