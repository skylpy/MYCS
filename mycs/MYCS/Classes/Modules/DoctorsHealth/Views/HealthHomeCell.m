//
//  HealthHomeCell.m
//  MYCS
//
//  Created by GuiHua on 16/7/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "HealthHomeCell.h"
#import "UIImageView+WebCache.h"

@interface HealthHomeCell ()

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (weak, nonatomic) IBOutlet UILabel *typeL;

@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UILabel *contenL;

@property (weak, nonatomic) IBOutlet UILabel *lookL;

@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;

@end

@implementation HealthHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.typeL.layer.cornerRadius = 2;
    self.typeL.clipsToBounds = YES;
    self.typeL.layer.borderWidth = 1;
    self.typeL.layer.borderColor = HEXRGB(0x47c1a8).CGColor;
    
    self.timeL.layer.cornerRadius = 4;
    self.timeL.clipsToBounds = YES;
    self.timeL.layer.borderWidth = 1;
    self.timeL.layer.borderColor = HEXRGB(0xffffff).CGColor;
}

-(void)setTypeLHide
{
    self.typeL.hidden = YES;
}

-(void)setModel:(DoctorsHealthList *)model
{
    _model = model;
    
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.video_img] placeholderImage:PlaceHolderImage];
    self.typeL.text = [NSString stringWithFormat:@" %@ ",model.disease_category];
    self.timeL.text = [NSString stringWithFormat:@" %@ ",model.video_long];
    
    self.contenL.text = model.video_titile;
    
    [self.contenL sizeToFit];
    
    self.lookL.text = [NSString stringWithFormat:@" %@ ",model.video_click];
    [self.praiseBtn setTitle:[NSString stringWithFormat:@" %@ ",model.video_praise] forState:UIControlStateNormal];
    [self.praiseBtn setTitle:[NSString stringWithFormat:@" %@ ",model.video_praise] forState:UIControlStateSelected];
    
    self.praiseBtn.selected = model.is_praise.intValue == 1?YES:NO;

    [self layoutIfNeeded];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)praiseBtnAction:(UIButton *)sender {
}

@end
