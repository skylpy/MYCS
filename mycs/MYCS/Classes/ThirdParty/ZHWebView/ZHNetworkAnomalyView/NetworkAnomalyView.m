//
//  NetworkAnomalyView.m
//  MYCS
//
//  Created by GuiHua on 16/5/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "NetworkAnomalyView.h"

@implementation NetworkAnomalyView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.refleshButton.layer.borderWidth = 1;
    self.refleshButton.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
}

+(instancetype)networkAnomalyView
{

    return [[[NSBundle mainBundle] loadNibNamed:@"NetworkAnomalyView" owner:self options:nil] lastObject];
}

- (IBAction)buttonClick:(UIButton *)sender
{
    if (self.buttonBlock)
    {
        self.buttonBlock(self,sender.tag);
    }
}

@end
