//
//  InsidersEvaluationTableViewCell.m
//  MYCS
//
//  Created by Yell on 16/1/22.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "InsidersEvaluationTableViewCell.h"
#import "NSDate+Util.h"
#import "UILabel+Attr.h"
#import "UIImageView+WebCache.h"
@interface InsidersEvaluationTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

@end

@implementation InsidersEvaluationTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentLabel.numberOfLines = 0;

}

-(void)setStutasType:(EvaluationStutasType)stutasType
{
    _stutasType = stutasType;
    if (stutasType == EvaluationStutasTypeAccept)
    {
        self.replyLabel.hidden = YES;
    }else
    {
        self.replyLabel.hidden = NO;
    }
}

-(void)setModel:(EvaluationInsidersModel *)model
{
    _model = model;
    
    if (self.stutasType == EvaluationStutasTypeSend)
    {
        self.replyLabel.text = [NSString stringWithFormat:@"@%@",model.reply_realname];
        
        //设置富文本
        NSRange rangeFrom = [ self.replyLabel.text rangeOfString:self.replyLabel.text];
        [self.replyLabel attrInRange:rangeFrom];
        
    }
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"face-h"]];
    
    self.nameLabel.text = model.from_realname;
    
    self.contentLabel.text = model.content;
    self.timeLabel.text = [NSDate dateWithTimeInterval:model.addTime.floatValue format:@"yyyy-MM-dd HH:mm"];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
}

@end
