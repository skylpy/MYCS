//
//  TableLineCell.m
//  MYCS
//
//  Created by yiqun on 16/8/29.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TableLineCell.h"
#import "ChapterModel.h"

// 浅灰——背景颜色
#define bgColor ([UIColor colorWithRed:((240)/255.0) green:((240)/255.0) blue:((240)/255.0) alpha:(1.0)])

@implementation TableLineCell

-(void)setChapters:(ChapterModel *)chapters{

    self.chapters = chapters;
    
    
    
}

-(void)cellReloadData:(ChapterModel *)chaper andIndexPath:(NSIndexPath *)indexPath {
    
    self.chapterName.text = chaper.name;
    
    self.passRateLabel.text = [NSString stringWithFormat:@"%@%%",chaper.chapter_rate];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",chaper.duration];
    
    
    if (!chaper.cando)
    {
        self.userInteractionEnabled = NO;
        self.chapterName.textColor = HEXRGB(0x999999)
        ;
        self.passRateLabel.textColor = HEXRGB(0x999999);
        self.timeLabel.textColor = HEXRGB(0x999999);
        self.iconView.image = [UIImage imageNamed:@"scr_n"];
        self.upView.backgroundColor = bgColor;
        self.downView.backgroundColor = bgColor;
    }
    else
    {
        self.userInteractionEnabled = YES;
        
        if (chaper.passStatus)
        {
            self.chapterName.textColor = HEXRGB(0x333333);
            self.passRateLabel.textColor = HEXRGB(0x47c1a8);
            self.timeLabel.textColor = HEXRGB(0x999999);
            self.iconView.image = [UIImage imageNamed:@"scr_o"];
            self.upView.backgroundColor = HEXRGB(0x47c1a8);
            self.downView.backgroundColor = HEXRGB(0x47c1a8);
        }
        else
        {
            self.chapterName.textColor = HEXRGB(0x333333);
            self.passRateLabel.textColor = HEXRGB(0x47c1a8);
            self.timeLabel.textColor = [UIColor orangeColor];
            self.iconView.image = [UIImage imageNamed:@"scr_h"];
            self.downView.backgroundColor = bgColor;
            self.upView.backgroundColor = HEXRGB(0x47c1a8);
        }
    }
    
}

@end
