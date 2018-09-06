//
//  VideoDetailView.m
//  MYCS
//
//  Created by GuiHua on 16/7/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "VideoDetailView.h"

@implementation VideoDetailView

+ (instancetype)videoDetailView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"VideoDetailView" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    self.DoctorInterviewL.layer.cornerRadius = 4;
    self.DoctorInterviewL.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetail)];
    self.detailL.userInteractionEnabled = YES;
    [self.detailL addGestureRecognizer:tap];
    
}

-(void)setModel:(DoctorsHealthDetail *)model
{

    _model = model;
    self.titleL.text = [NSString stringWithFormat:@"               %@",model.video_titile];
    self.detailL.text = model.video_des;
    [self  setlookL];
    self.dateL.text = model.add_time;
}

-(void)setlookL
{
    NSString *praiseNumb =  [NSString stringWithFormat:@" %@",self.model.video_click];
    
    if (self.model.video_click.floatValue >= 100000.0)
    {
        praiseNumb =  [NSString stringWithFormat:@" %.1f万",self.model.video_click.floatValue / 10000];
    }
    
    [self.lookL setTitle:praiseNumb forState:UIControlStateNormal];
}

-(void)tapDetail
{

    [self videoDetailBtnAction:self.showDetailBtn];
    
}
-(void)setShowVideoDetail:(BOOL)showVideoDetail
{

    _showVideoDetail = showVideoDetail;
    
    CGFloat hei = self.detailL.height;
    
    if (showVideoDetail)
    {
        self.detailL.numberOfLines = 0;

    }else
    {
        self.detailL.numberOfLines = 2;
    }
    
    [self layoutIfNeeded];
    [self.detailL sizeToFit];
    self.height += self.detailL.height - hei;
    if (!self.isFisrt)
    {
        self.height = self.height - 39 + self.titleL.height;
        self.isFisrt = YES;
    }
}

- (IBAction)videoDetailBtnAction:(UIButton *)sender
{
    self.showDetailBtn.selected = !sender.selected;
    
    if (self.ShowDetailblock)
    {
        self.ShowDetailblock(self.showDetailBtn.selected);
    }
}





@end
