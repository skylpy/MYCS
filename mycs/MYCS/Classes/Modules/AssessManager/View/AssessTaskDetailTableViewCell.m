//
//  AssessTaskDetailTableViewCell.m
//  MYCS
//
//  Created by Yell on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AssessTaskDetailTableViewCell.h"
@interface AssessTaskDetailTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *standardLabel;
@property (weak, nonatomic) IBOutlet UILabel *AssessLabel;
@property (weak, nonatomic) IBOutlet UILabel *chapterNameLabel;

@end

@implementation AssessTaskDetailTableViewCell


-(void)setModel:(AssessChapterModel *)model
{

    _model = model;
    
    self.chapterNameLabel.text = _model.name;
    
    if (_model.canDo == NO) {
        
        self.AssessLabel.text =@"开始考核";
        self.AssessLabel.textColor = HEXRGB(0xcccccc);
        self.standardLabel.text =@"未达标";
        self.standardLabel.textColor = HEXRGB(0xcccccc);
        self.chapterNameLabel.textColor = HEXRGB(0xcccccc);
        self.userInteractionEnabled = NO;
        
    }else
    {
        
        if (_model.passStatus == YES)
        {
            self.standardLabel.text =@"已达标";
            self.standardLabel.textColor = HEXRGB(0x47c1a9);
            self.AssessLabel.text =@"继续学习";
            self.AssessLabel.textColor = HEXRGB(0x47c1a9);
            
        }else
        {
            self.standardLabel.text =@"未达标";
            self.standardLabel.textColor = HEXRGB(0xf66060);
            self.AssessLabel.text =@"开始考核";
            self.AssessLabel.textColor = HEXRGB(0xff9b60);
        }
        
        self.chapterNameLabel.textColor = HEXRGB(0x333333);
        self.userInteractionEnabled = YES;
        
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
