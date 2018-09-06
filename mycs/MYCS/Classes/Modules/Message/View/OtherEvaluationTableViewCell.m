//
//  OtherEvaluationTableViewCell.m
//  MYCS
//
//  Created by Yell on 16/1/22.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "OtherEvaluationTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Util.h"
#import "UILabel+Attr.h"
@interface OtherEvaluationTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *replyBGView;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *btnView;



@end


@implementation OtherEvaluationTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.replyLabel.numberOfLines = 0;
    self.contentLabel.numberOfLines = 0;
}

-(void)setModel:(EvaluationOtherModel *)model
{
    _model = model;
    
    if (self.stutasType == EvaluationStutasTypeSend)
    {
        self.btnView.hidden = YES;
    }
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.from_image] placeholderImage:[UIImage imageNamed:@"face-h"]];
    self.nameLabel.text = model.from_realname;
    self.contentLabel.text = model.content;
    self.timeLabel.text = [NSDate dateWithTimeInterval:model.addTime.floatValue format:@"yyyy-MM-dd HH:mm"];
    
    //reply_realname:",  //被评论人的名字
    //from_realname       //评论人的名字
    
    NSString * targeStr;
    
    if (self.targeType == EvaluationTargetTypeCase)
    {
        targeStr = @"案例中心";
    }else if (self.targeType == EvaluationTargetTypeExchange)
    {
        targeStr = @"学术交流";
    }else if (self.targeType == EvaluationTargetTypeVideo)
    {
        targeStr = @"视频空间";
    }
    
    NSString * realName;
    if (model.reply_realname == nil)
    {
        realName = @"@null";
    }else
    {
        realName = [NSString stringWithFormat:@"@%@",model.reply_realname];
    }
    
    if(model.reply_content == nil || [model.reply_content isEqualToString:@""])
    {
        self.replyLabel.text = [NSString stringWithFormat:@"%@的%@:",realName,targeStr];

    }
    else
    {
     self.replyLabel.text = [NSString stringWithFormat:@"%@的%@:%@",realName,targeStr,model.reply_content];
    }
    
    //设置富文本
    NSRange rangeFrom = [ self.replyLabel.text rangeOfString:realName];
    NSRange beginRange = NSMakeRange(rangeFrom.length, self.replyLabel.text.length-rangeFrom.length);
    NSRange rangeReply = [self.replyLabel.text rangeOfString:realName options:NSCaseInsensitiveSearch range:beginRange];
    [self.replyLabel attrInRange:rangeFrom];
    [self.replyLabel attrInRange:rangeReply];
    
    
}
- (IBAction)replyAction:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(selectCell:WithModel:)]) {
        [self.delegate selectCell:self WithModel:self.model];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
}

@end
