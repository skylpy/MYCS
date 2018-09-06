//
//  CasePlayerCell.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "CasePlayerCell.h"

#import "UIButton+WebCache.h"
#import "UILabel+Attr.h"
#import "UIImageView+WebCache.h"

#import "PraiseModel.h"

@interface CasePlayerCell ()

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLConstraintHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *praiseBtnT;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *praiseBtnWidth;

@property (weak, nonatomic) IBOutlet UIButton *replyBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *replyBtnWidth;

@property (weak, nonatomic) IBOutlet UIButton *showAllBtn;

@property (weak, nonatomic) IBOutlet UIImageView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (nonatomic,strong) NSMutableArray *applyList;

@property (nonatomic,strong) NSMutableArray *nameList;

@end

@implementation CasePlayerCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
}

- (void)setImageArr:(NSArray *)imageArr
{
    _imageArr = imageArr;
    
    
    UILabel * label = (UILabel *)[self viewWithTag:999];
    [label removeFromSuperview];
    
    for (UIView * view in self.subviews)
    {
        if (view.tag >= 99)
        {
            [view removeFromSuperview];
        }
    }
    
    CGFloat margin = 5;
    CGFloat leftMargin = 15;
    CGFloat topMargin = margin;
    CGFloat btnW = 45;
    
    for (int i = 0; i<imageArr.count; i++) {
        
        if (i>6) {
            break;
        }
        
        UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:imageBtn];
        imageBtn.tag = 100 + i;
        
        NSString *imageURL = imageArr[i];
        [imageBtn sd_setImageWithURL:[NSURL URLWithString:imageURL] forState:UIControlStateNormal placeholderImage:PlaceHolderImage];
        
        int col = i%6;//列
        
        CGFloat btnH = btnW;
        CGFloat btnX = leftMargin + (btnW + margin)*col;
        CGFloat btnY = 196 + topMargin;
        
        imageBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
        
    }
    
    if (self.imageArr.count == 0)
    {
        self.cellHeight = 196 + 5;
    }else
    {
        self.cellHeight = 196 + topMargin*2 + btnW;
    }
    
    [self layoutCoustomSubview];
    
}

- (void)layoutCoustomSubview{
  
    //内容
    UILabel * contentL = ({
        
        UILabel * contentL = [UILabel new];
        
        contentL.frame = CGRectMake(15, self.titleLConstraintHeight.constant + 256 + 10, ScreenW - 30, 21);
        
        contentL.tag = 999;
        
        contentL.font = [UIFont systemFontOfSize:12];
        contentL.textColor = HEXRGB(0x000000);
        
        contentL.numberOfLines = 0;
        
        contentL.text = _academicModel.content;
        
        CGRect labelFrame = CGRectMake(15, self.titleLConstraintHeight.constant + 256 + 10, 0.0, 0.0);
        
        labelFrame.size = [contentL sizeThatFits:CGSizeMake(ScreenW - 30, 3000)];
        
        [contentL setFrame:labelFrame];
        
        contentL;
        
    });
    
    [self addSubview:contentL];
    
    self.praiseBtnT.constant = contentL.height+ self.titleLConstraintHeight.constant + 256 + 10;
    
    CGFloat y = self.praiseBtnT.constant+self.praiseBtn.height+ 10;
    
    self.showAllBtn.hidden = YES;
    
    //评论区
    if (self.applyList.count > 0)
    {
        
        NSString *titleN = [NSString stringWithFormat:@"查看全部%lu条评论",(unsigned long)self.applyList.count];
        NSString *titleS = [NSString stringWithFormat:@"收起全部%lu条评论",(unsigned long)self.applyList.count];
        
        [self.showAllBtn setTitle:titleN forState:UIControlStateNormal];
        [self.showAllBtn setTitle:titleS forState:UIControlStateSelected];
        
        self.showAllBtn.selected = self.academicModel.showAllApply.intValue == 0?NO:YES;
        
        if (self.applyList.count <= 2)
        {
            self.showAllBtn.hidden = YES;
        }else
        {
            self.showAllBtn.hidden = NO;
        }
        
        for (int i = 0; i < self.applyList.count; i ++)
        {
            
            if (i>=2 && _academicModel.showAllApply.intValue == 0)
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
                                        constrainedToSize:CGSizeMake(ScreenW - 30,100000)
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
            [self addSubview:control];
            control.tag = 100000 + i;
            
            [control addTarget:self action:@selector(controlAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
    }
    
    self.showAllBtn.y = y;
    
    if (!self.showAllBtn.hidden)
    {
        self.cellHeight =  CGRectGetMaxY(self.showAllBtn.frame)+16;
        
    }else
    {
        self.cellHeight = y+10;
    }
    
}

- (void)setAcademicModel:(AcademicExchangeModel *)academicModel
{
    
    _academicModel = academicModel;
    
    self.titleL.numberOfLines = 0;
    self.titleL.text = academicModel.title;
    [self.titleL sizeToFit];
    self.titleLConstraintHeight.constant = self.titleL.height;
    
    [self.praiseBtn setTitle:academicModel.praiseNum forState:UIControlStateNormal];
    self.praiseBtn.selected = academicModel.isPraise;
    
    [self.replyBtn setTitle:[NSString stringWithFormat:@"%lu",(unsigned long)academicModel.replyList.count] forState:UIControlStateNormal];
    
    [self.bgView sd_setImageWithURL:[NSURL URLWithString:academicModel.videoCover] placeholderImage:PlaceHolderImage];
    
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
    
    self.imageArr = academicModel.picList;
    
    //CGSize size = [self.praiseBtn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGSize size = [self.praiseBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    self.praiseBtnWidth.constant = size.width + 35;
    
    //CGSize size1 = [self.replyBtn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGSize size1 = [self.replyBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    self.replyBtnWidth.constant = size1.width + 35;
    
}

- (IBAction)praiseAction:(id)sender
{
    
    self.praiseBtn.userInteractionEnabled = NO;
    
    if ([self.delegate respondsToSelector:@selector(praiseCasePlayerCellBtnDidClick:andDoctorComment:)])
    {
        
        [self.delegate praiseCasePlayerCellBtnDidClick:self andDoctorComment:self.academicModel];
        
        self.praiseBtn.userInteractionEnabled = YES;
        
    }
    
}

- (IBAction)replyAction:(id)sender
{
    
    if ([self.delegate respondsToSelector:@selector(responseCasePlayerCellReplyAction:)])
    {
        [self.delegate responseCasePlayerCellReplyAction:_academicModel];
    }
    
}

- (void)controlAction:(UIControl *)control
{
    
    if ([self.delegate respondsToSelector:@selector(controlCasePlayerCellActionWith:index:)])
    {
        [self.delegate controlCasePlayerCellActionWith:self.academicModel index:(int)control.tag-100000];
    }
    
}

- (IBAction)showAllAction:(id)sender
{
    
    _academicModel.showAllApply = _academicModel.showAllApply.intValue == 0?@"1":@"0";
    
    self.showAllBtn.selected = !self.showAllBtn.selected;
    
    if ([self.delegate respondsToSelector:@selector(refreshCasePlayerCellTable:)])
    {
        [self.delegate refreshCasePlayerCellTable:self];
    }
    
}

- (IBAction)playerAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(playCasePlayerCellVideoWith:titil:)])
    {
        [self.delegate playCasePlayerCellVideoWith:self.academicModel titil:self.academicModel.title];
    }
    
}


@end
