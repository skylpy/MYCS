//
//  CommunicateViewCell.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "MyCommunicateViewCell.h"

#import "UILabel+Attr.h"
#import "UIButton+WebCache.h"
#import "NSDate+Util.h"
#import "UIImageView+WebCache.h"

#import "CommentModel.h"
#import "AcademicExchangeModel.h"
#import "PraiseModel.h"

@interface MyCommunicateViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *timeL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *praiseBtnWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *praiseBtnT;

@property (weak, nonatomic) IBOutlet UIButton *applyBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *applyBtnWidth;

@property (weak, nonatomic) IBOutlet UIButton *showAllBtn;

@property (nonatomic,assign) CGFloat imageMaxY;

@property (nonatomic,strong) NSMutableArray *nameList;

@end

@implementation MyCommunicateViewCell

- (void)awakeFromNib
{
    
    [super awakeFromNib];
    self.iconView.layer.cornerRadius = self.iconView.width * 0.5;
    self.iconView.layer.masksToBounds = YES;
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.showAllBtn setTitleColor:[UIColor colorWithRed:83/255.0 green:129/255.0 blue:197/255.0 alpha:0.9] forState:UIControlStateNormal];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (void)setContent:(NSString *)content
{
    
    _content = content;
    
    UILabel * label = (UILabel *)[self viewWithTag:999];
    [label removeFromSuperview];
    
    for (UIView * view in self.subviews)
    {
        if (view.tag >= 99)
        {
            [view removeFromSuperview];
        }
    }
    
    //内容
    UILabel * contentL = ({
        
        UILabel * contentL = [UILabel new];
        
        contentL.frame = CGRectMake(15, 70, ScreenW - 30, 21);
        
        contentL.tag = 999;
        
        contentL.font = [UIFont systemFontOfSize:12];
        contentL.textColor = HEXRGB(0x000000);
        
        contentL.numberOfLines = 0;
        
        contentL.text = _academicModel.content;
        
        CGRect labelFrame = CGRectMake(15, 70, 0.0, 0.0);
        
        labelFrame.size = [contentL sizeThatFits:CGSizeMake(ScreenW - 30, 3000)];
        
        [contentL setFrame:labelFrame];
        
        contentL;
        
    });

    
    [self addSubview:contentL];
   
    self.praiseBtnT.constant =  contentL.height+ 65;
    
    CGFloat y = self.praiseBtnT.constant+self.praiseBtn.height+ 10;
    
    //照片区
    if (self.imageArr.count > 0)
    {
        
        CGFloat margin = 10;
        
        for (int i = 0; i < self.imageArr.count; i ++)
        {
            
            NSString *imageURL = self.imageArr[i];
            
            UIImageView *imageV = [[UIImageView alloc] init];
            [imageV sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:PlaceHolderImage];
            
            [self addSubview:imageV];
            imageV.tag = 100 + i;
            
            int row = i / 3;//行
            int col = i % 3;//列
            
            CGFloat imageW = self.width / 4;
            CGFloat imageH = imageW;
            CGFloat imageX = margin + (imageW + margin)*col;
            CGFloat imageY = y + (imageH + margin)*row;
            
            imageV.frame = CGRectMake(imageX, imageY, imageW, imageH);
            
            self.imageMaxY = CGRectGetMaxY(imageV.frame);
            
        }
        
    }
    
    if (self.imageMaxY)
    {
        y = self.imageMaxY + 10;
    }
    
    self.showAllBtn.hidden = YES;
    
    //评论区
    if (self.applyList.count > 0)
    {
        
        NSString *titleN = [NSString stringWithFormat:@"查看全部%lu条评论",(unsigned long)self.applyList.count];
        NSString *titleS = [NSString stringWithFormat:@"收起全部%lu条评论",(unsigned long)self.applyList.count];
        
        [self.showAllBtn setTitle:titleN forState:UIControlStateNormal];
        [self.showAllBtn setTitle:titleS forState:UIControlStateSelected];
        
        self.showAllBtn.selected = self.academicModel.showAllApply.intValue == 0?NO:YES;
        
        if (self.applyList.count <= 6)
        {
            self.showAllBtn.hidden = YES;
        }else
        {
            self.showAllBtn.hidden = NO;
        }
        
        for (int i = 0; i < self.applyList.count; i ++)
        {
            
            if (_academicModel.showAllApply.intValue == 0 && i >= 6)
            {
                break;
            }
            
            UILabel *applyL = [[UILabel alloc] init];
            [self addSubview:applyL];
            applyL.tag = 1000+i;
            
            applyL.text = _applyList[i];
            applyL.numberOfLines = 0;
            applyL.textColor = HEXRGB(0x666666);
            applyL.font = [UIFont systemFontOfSize:12];
            
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            
            CGSize fontSize = [_applyList[i] sizeWithFont:[UIFont systemFontOfSize:12]
                                        constrainedToSize:CGSizeMake(ScreenW- 30, CGFLOAT_MAX)
                                            lineBreakMode:NSLineBreakByWordWrapping];
#pragma clang diagnostic pop
            
            applyL.frame = CGRectMake(15, y,ScreenW - 30, fontSize.height);
            
            y += fontSize.height + 10;
            
            //设置富文本
            NSDictionary *nameDict = self.nameList[i];
            
            NSString *fromName = nameDict[@"FromName"];
            NSString *replyName = nameDict[@"ReplyName"];
            NSString * answer = @" 回复 ";
            
            NSRange fromRange = NSMakeRange(0, fromName.length);
            NSRange replyRange = NSMakeRange(fromRange.length + 4, replyName.length);
            NSRange answerRange = NSMakeRange(fromName.length, answer.length);
            
            [applyL attrInRange:fromRange];
            [applyL attrInRange:replyRange];
            
            if (replyName.length > 0)
            {
                [applyL attrInAnswerRange:answerRange];
            }
            
            //添加control
            UIControl *control = [[UIControl alloc] initWithFrame:applyL.frame];
            control.tag = 100000+i;
            [self addSubview:control];
            
            [control addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchUpInside];
            
        }
        
    }
    
    self.showAllBtn.y = y;
    
    if (!self.showAllBtn.hidden)
    {
        self.cellHeight =  CGRectGetMaxY(self.showAllBtn.frame) + 14;
        
    }else
    {
        self.cellHeight = y + 10;
    }
    
}

- (IBAction)showAllApplyAction:(UIButton *)sender
{
    
    _academicModel.showAllApply = _academicModel.showAllApply.intValue == 0?@"1":@"0";
    
    self.showAllBtn.selected = !self.showAllBtn.selected;

    
    //使用代理刷新数据
    if ([self.delegate respondsToSelector:@selector(refreshMyCommunicateViewCellTable:)])
    {
        [self.delegate refreshMyCommunicateViewCellTable:self];
    }
}

- (void)setAcademicModel:(AcademicExchangeModel *)academicModel
{
    _academicModel = academicModel;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:academicModel.from_upicurl] forState:UIControlStateNormal placeholderImage:PlaceHolderImage];
    
    self.nameL.text = academicModel.from_uname;
    self.timeL.text = [NSDate dateWithTimeInterval:[academicModel.addTime floatValue] format:@"yyyy-MM-dd HH:mm:ss"];
    
    [self.praiseBtn setTitle:academicModel.praiseNum forState:UIControlStateNormal];
    self.praiseBtn.selected = academicModel.isPraise;
    
    [self.applyBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)academicModel.replyList.count] forState:UIControlStateNormal];
    
    self.applyList = [NSMutableArray array];
    self.nameList = [NSMutableArray array];
    
    for (Reply *reply in academicModel.replyList)
    {
        
        NSString *msg;
        if (reply.reply_uname.length==0||!reply.reply_uname)
        {
            msg = [NSString stringWithFormat:@"%@：%@",reply.from_uname,reply.content];
        }else
        {
            msg = [NSString stringWithFormat:@"%@ 回复 %@：%@",reply.from_uname,reply.reply_uname,reply.content];
        }
        
        [_applyList addObject:msg];
        
        NSMutableDictionary *nameDict = [NSMutableDictionary dictionary];
        nameDict[@"FromName"] = reply.from_uname;
        nameDict[@"ReplyName"] = reply.reply_uname;
        
        [self.nameList addObject:nameDict];
        
    }
    
    self.content = academicModel.content;
    
    //CGSize size = [self.praiseBtn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGSize size = [self.praiseBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    self.praiseBtnWidth.constant = size.width + 35;
    
//    CGSize size1 = [self.applyBtn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGSize size1 = [self.applyBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    self.applyBtnWidth.constant = size1.width + 35;
}


- (IBAction)praiseAction:(id)sender
{
    
    self.praiseBtn.userInteractionEnabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(praiseMyCommunicateViewCellBtnDidClick:andDoctorComment:)])
    {
        
        [self.delegate praiseMyCommunicateViewCellBtnDidClick:self andDoctorComment:_academicModel];
        
        self.praiseBtn.userInteractionEnabled = YES;
        
    }
    
    
}
- (IBAction)replyAction:(id)sender
{
    
    if ([self.delegate respondsToSelector:@selector(responseMyCommunicateViewCellReplyAction:)])
    {
        [self.delegate responseMyCommunicateViewCellReplyAction:_academicModel];
    }
    
}

- (void)controlAction:(UIControl *)control{
    
    if ([self.delegate respondsToSelector:@selector(controlMyCommunicateViewCellActionWith:index:)])
    {
        [self.delegate controlMyCommunicateViewCellActionWith:self.academicModel index:(int)control.tag - 100000];
    }
    
}


@end
