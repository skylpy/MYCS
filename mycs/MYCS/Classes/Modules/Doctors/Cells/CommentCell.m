//
//  CommentCell.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "CommentCell.h"

#import "DoctorCommentModel.h"
#import "PraiseModel.h"

#import "UIButton+WebCache.h"
#import "NSDate+Util.h"

@interface CommentCell ()

@property (weak, nonatomic) IBOutlet UIButton *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet UIView *startView;


@end

@implementation CommentCell

- (void)awakeFromNib
{
    
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = self.iconView.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)setDcomment:(DoctorComment *)Dcomment
{
    _Dcomment = Dcomment;
    
    [_iconView sd_setImageWithURL:[NSURL URLWithString:Dcomment.from_imageUrl] forState:UIControlStateNormal placeholderImage:UIControlStateNormal];
    
    _nameL.text = Dcomment.from_uname;
    _timeL.text = [NSDate dateWithTimeInterval:[Dcomment.addTime floatValue] format:@"yyyy-MM-dd HH:mm"];
    [_praiseBtn setTitle:Dcomment.praiseNum forState:UIControlStateNormal];
    self.praiseBtn.selected = Dcomment.isPraise;
    
    for (UIButton *btn in self.startView.subviews)
    {
        if (btn.tag<=Dcomment.score)
        {
            btn.selected = YES;
            
        }else
        {
            btn.selected = NO;
        }
    }
    
    UILabel * label = (UILabel *)[self viewWithTag:999];
    [label removeFromSuperview];
    
    //内容
    UILabel * contentL = ({
        
        UILabel * contentL = [UILabel new];
        
        contentL.frame = CGRectMake(65, 70, ScreenW - 75, 21);
        
        contentL.tag = 999;
        
        contentL.font = [UIFont systemFontOfSize:12];
        contentL.textColor = HEXRGB(0x000000);
        
        contentL.numberOfLines = 0;
        
        contentL.text = Dcomment.content;
        
        CGRect labelFrame = CGRectMake(65, 70, 0.0, 0.0);
        
        labelFrame.size = [contentL sizeThatFits:CGSizeMake(ScreenW - 75, 3000)];
        
        [contentL setFrame:labelFrame];
        
        contentL;
        
    });
    
    [self addSubview:contentL];
    
    self.height = 120 + contentL.height;

}


- (IBAction)praiseAction:(id)sender
{
    
    self.praiseBtn.userInteractionEnabled = NO;

    if ([self.delegate respondsToSelector:@selector(praiseBtnDidClick:andDoctorComment:)])
    {
        [self.delegate praiseBtnDidClick:self andDoctorComment:_Dcomment];
        
        self.praiseBtn.userInteractionEnabled = YES;

    }

}


@end
