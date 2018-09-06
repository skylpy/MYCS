//
//  AssessTaskListTableViewCell.m
//  MYCS
//
//  Created by Yell on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AssessTaskListTableViewCell.h"
#import "NSDate+Util.h"
#import "UIImageView+WebCache.h"
#import <QuartzCore/QuartzCore.h>
@interface AssessTaskListTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapterCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;



@end

@implementation AssessTaskListTableViewCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.stateLabel.transform = CGAffineTransformMakeRotation(-20*M_PI/180);
    self.stateLabel.layer.borderWidth = 2;
    self.stateLabel.layer.cornerRadius = 2;
    self.stateLabel.layer.masksToBounds = YES;
}

-(void)setModel:(WaitToDoTask *)model
{
    _model = model;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:PlaceHolderImage];
    self.titleLabel.text = _model.taskName;
    self.chapterCountLabel.text = [NSString stringWithFormat:@"共%@章节",_model.chaptersNum];
    self.endTimeLabel.text = [NSString stringWithFormat:@"截止时间:%@", [NSDate dateWithTimeInterval:[_model.endTime floatValue] format:@"yyyy-MM-dd"]];
    

    NSString * stateStr;
    UIColor * Textcolor;
    self.userInteractionEnabled = YES;

    switch (model.taskStatus.integerValue) {
        case 0:
            stateStr = @"未达标";
            Textcolor = HEXRGB(0xf66060);

            break;
        case 1:
            stateStr = @"已达标";
            Textcolor = HEXRGB(0x47c1a9);

            break;
        case 2:
            stateStr = @"未参加";
            Textcolor = HEXRGB(0xff9b60);
            break;
            
        default:
            break;
    }
    

    if (model.isEnd.integerValue == 1)
    {
        Textcolor = HEXRGB(0xcccccc);
        self.userInteractionEnabled = NO;
    }
    
    self.stateLabel.layer.borderWidth = 1;
    self.stateLabel.textColor = Textcolor;
    self.stateLabel.layer.borderColor = Textcolor.CGColor;
    self.stateLabel.text =stateStr;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
