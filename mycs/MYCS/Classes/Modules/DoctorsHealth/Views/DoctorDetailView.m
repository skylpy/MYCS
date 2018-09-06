//
//  DoctorDetailView.m
//  MYCS
//
//  Created by GuiHua on 16/7/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "DoctorDetailView.h"
#import "UIImageView+WebCache.h"

@implementation DoctorDetailView

+ (instancetype)doctorDetailView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"DoctorDetailView" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    self.doctorImageView.layer.cornerRadius = self.doctorImageView.width / 2;
    self.doctorImageView.clipsToBounds = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetail)];
    self.doctorDetailL.userInteractionEnabled = YES;
    [self.doctorDetailL addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tapImageView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView)];
    self.doctorImageView.userInteractionEnabled = YES;
    [self.doctorImageView addGestureRecognizer:tapImageView];
    
}

-(void)setModel:(DoctorsHealthDoctor *)model
{

    _model = model;
    
    [self.doctorImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
    self.doctorNameL.text = model.realname;
    self.doctorObjL.text = model.jobTitle;
    self.doctorHospital.text = model.hospital;
    self.doctorOfficeL.text = model.doctorTitle;
    self.doctorDetailL.text = model.introduction;
}

-(void)tapImageView
{
    if (self.tapImageViewblock)
    {
        self.tapImageViewblock();
    }
}
- (IBAction)hospitalNameTap:(UIButton *)sender
{
    if (self.hospitalNameTapblock)
    {
        self.hospitalNameTapblock();
    }
}
-(void)tapDetail
{
    
    [self doctorDetailBtnAction:self.showDetailBtn];
    
}

-(void)setShowDoctorDetail:(BOOL)showDoctorDetail
{
    
    _showDoctorDetail = showDoctorDetail;
    
    CGFloat hei = self.doctorDetailL.height;
    
    if (showDoctorDetail)
    {
        self.doctorDetailL.numberOfLines = 0;
        
    }else
    {
        self.doctorDetailL.numberOfLines = 2;
    }
    
    [self layoutIfNeeded];
    [self.doctorDetailL sizeToFit];
    self.height += self.doctorDetailL.height - hei;
}

- (IBAction)doctorDetailBtnAction:(UIButton *)sender
{
    
    self.showDetailBtn.selected = !sender.selected;
    
    if (self.ShowDetailblock)
    {
        self.ShowDetailblock(self.showDetailBtn.selected);
    }
}


@end
