//
//  HospitalDetailView.m
//  MYCS
//
//  Created by GuiHua on 16/7/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "HospitalDetailView.h"
#import "UIImageView+WebCache.h"

@implementation HospitalDetailView

+ (instancetype)hospitalDetailView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HospitalDetailView" owner:nil options:nil] lastObject];
}


-(void)awakeFromNib
{
    [super awakeFromNib];
    self.hospitalImageView.layer.cornerRadius = self.hospitalImageView.width / 2;
    self.hospitalImageView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetail)];
    self.hospitalDetailL.userInteractionEnabled = YES;
    [self.hospitalDetailL addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)];
    self.hospitalImageView.userInteractionEnabled = YES;
    [self.hospitalImageView addGestureRecognizer:tapImageView];
    
}
-(void)tapImageView
{
    if (self.tapImageViewblock)
    {
        self.tapImageViewblock();
    }
}
-(void)tapDetail
{
    
    [self showDetailBtnAction:self.showDetailBtn];
    
}

-(void)setShowHopitalDetail:(BOOL)showHopitalDetail
{
    
    _showHopitalDetail = showHopitalDetail;
    
    CGFloat hei = self.hospitalDetailL.height;
    
    if (showHopitalDetail)
    {
        self.hospitalDetailL.numberOfLines = 0;
        
    }else
    {
        self.hospitalDetailL.numberOfLines = 2;
    }
    
    [self layoutIfNeeded];
    [self.hospitalDetailL sizeToFit];
    self.height += self.hospitalDetailL.height - hei;
}

-(void)setModel:(DoctorsHealthHosptial *)model
{
    _model = model;
    [self.hospitalImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
    self.hospitalNameL.text = model.realname;
    self.hospitalDetailL.text = model.introduction;
    self.hospitalOfficeL.text = model.jobTitle;
    
    
}

- (IBAction)showDetailBtnAction:(UIButton *)sender
{
    self.showDetailBtn.selected = !sender.selected;
    
    if (self.ShowDetailblock)
    {
        self.ShowDetailblock(self.showDetailBtn.selected);
    }
}


@end
