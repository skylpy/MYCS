//
//  HealthCommentCell.m
//  MYCS
//
//  Created by GuiHua on 16/7/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "HealthCommentCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Util.h"
#import "NSString+Size.h"
#import "NSMutableAttributedString+Attr.h"

@implementation HealthCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.userImageView.layer.cornerRadius = self.userImageView.width / 2;
    self.userImageView.clipsToBounds = YES;
    
}

- (CGFloat)configWith:(GeneralCommentModel *)model
{
    self.model = model;
    
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:PlaceHolderImage];
    self.userNameL.text = model.name;
    
    self.commentTimeL.text   = model.time;
    
    self.userCommentL.text = model.text;
    [self.userCommentL sizeToFit];
    
    NSString *replyCount = [NSString stringWithFormat:@"%lu", (unsigned long)model.sons.count];
    [self.replyButton setTitle:replyCount forState:UIControlStateNormal];
    
    [self layoutIfNeeded];
 
    
    CGFloat cellH;
    
    if (model.sons.count == 0)
    {
        cellH = self.replyContent.y;
        self.replyContent.hidden = YES;
    }
    else
    {
        self.replyContent.hidden = NO;
        for (UIView *subView in self.replyContent.subviews) {
            [subView removeFromSuperview];
        }
   
        //评论区
        CGFloat replyLabelY = 10;
        for (int i = 0; i < model.sons.count; i++)
        {
            if (i > 2 && !model.expand)
            {
                [self.replyContent addSubview:self.showAllReplyButton];
                
                NSString *title = [NSString stringWithFormat:@"更多%lu条回复...", model.sons.count - 3];
                
                [self.showAllReplyButton setTitle:@"收起部分评论" forState:UIControlStateSelected];
                [self.showAllReplyButton setTitle:title forState:UIControlStateNormal];
                
                CGFloat buttonW = ScreenW - 30 - 10 * 2;
                
                self.showAllReplyButton.frame = CGRectMake(10, replyLabelY, buttonW, 16);
                
                replyLabelY = CGRectGetMaxY(self.showAllReplyButton.frame) + 10;
                
                break;
            }else
            {
                [self.showAllReplyButton removeFromSuperview];
            }
            
            GeneralCommentModel *replyModel = model.sons[i];
            UILabel *replyLabel               = [UILabel new];
            [self.replyContent addSubview:replyLabel];
            
            replyLabel.textColor = HEXRGB(0x666666);
            
            NSString *replyContenStr;
            if (replyModel.replyName && replyModel.replyName.length != 0)
            {
                replyContenStr = [NSString stringWithFormat:@"%@回复%@:%@", replyModel.name, replyModel.replyName, replyModel.text];
                
                NSRange fromRange  = NSMakeRange(0, replyModel.name.length);
                NSRange replyRange = NSMakeRange(fromRange.length + 2, replyModel.replyName.length);
                
                NSMutableAttributedString *attrString = [NSMutableAttributedString string:replyContenStr value1:HEXRGB(0x5382c5) range1:fromRange value2:HEXRGB(0x5382c5) range2:replyRange font:12];
                
                replyLabel.attributedText = attrString;
            }
            else
            {
                replyContenStr = [NSString stringWithFormat:@"%@:%@", replyModel.name, replyModel.text];
                
                NSRange fromRange = NSMakeRange(0, replyModel.name.length);
                
                NSMutableAttributedString *attrString = [NSMutableAttributedString string:replyContenStr value1:HEXRGB(0x5382c5) range1:fromRange value2:nil range2:NSMakeRange(0, 0) font:12];
                
                replyLabel.attributedText = attrString;
            }
            
            //设置label的属性
            replyLabel.numberOfLines = 0;
            replyLabel.font          = [UIFont systemFontOfSize:12];
            
            //设置frame
            CGFloat margin = 10;
            CGFloat labelW = ScreenW - 30 - margin * 2;
            CGFloat labelH = [replyContenStr heightWithFont:[UIFont systemFontOfSize:12] constrainedToWidth:labelW];
            
            replyLabel.frame = CGRectMake(margin, replyLabelY, labelW, labelH + 4);
            
            //设置响应事件
            ReplayContentControl *tapControl = [ReplayContentControl new];
            tapControl.frame          = replyLabel.frame;
            [self.replyContent addSubview:tapControl];
            [tapControl addTarget:self action:@selector(replyLabelClickAction:) forControlEvents:UIControlEventTouchUpInside];
            tapControl.sunModel = replyModel;
            
            replyLabelY = CGRectGetMaxY(replyLabel.frame) + margin;
        }
        
        if (model.sons.count>3 && model.expand)
        {
            [self.replyContent addSubview:self.showAllReplyButton];
            
            [self.showAllReplyButton setTitle:@"收起部分评论" forState:UIControlStateNormal];
            
            CGFloat buttonW = ScreenW - 30 - 10 * 2;
            
            self.showAllReplyButton.frame = CGRectMake(10, replyLabelY, buttonW, 16);
            
            replyLabelY = CGRectGetMaxY(self.showAllReplyButton.frame) + 10;
        }
        
        self.replyContentViewConstH.constant = replyLabelY;
        [self layoutIfNeeded];
        
        cellH = CGRectGetMaxY(self.replyContent.frame) + 15;
    }
    
    return cellH;
}


- (void)replyLabelClickAction:(ReplayContentControl *)control
{
    if ([self.delegate respondsToSelector:@selector(HealthCommentCell:didTapReplyLabel:commentModel:)])
    {
        [self.delegate HealthCommentCell:self didTapReplyLabel:control commentModel:self.model];
        
    }
    
}
- (IBAction)replyButtonAction:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(HealthCommentCell:replyButtonAction:commentModel:)])
    {
        
        [self.delegate HealthCommentCell:self replyButtonAction:button commentModel:self.model];
    }
    
}
- (void)showAllReply:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(HealthCommentCell:showAllButtonAction:)])
    {
        if (self.model.expand)
        {
            self.model.expand = nil;
        }
        else
        {
            self.model.expand = @"1";
        }
        
        [self.delegate HealthCommentCell:self showAllButtonAction:button];
    }
}

#pragma mark - Getter和Setter
- (UIButton *)showAllReplyButton {
    if (!_showAllReplyButton)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.replyContent addSubview:button];
        
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        button.titleLabel.font            = [UIFont systemFontOfSize:12];
        
        [button setTitleColor:HEXRGB(0x5382c5) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(showAllReply:) forControlEvents:UIControlEventTouchUpInside];
        
        _showAllReplyButton = button;
    }
    
    return _showAllReplyButton;
}

@end

@implementation ReplayContentControl


@end
