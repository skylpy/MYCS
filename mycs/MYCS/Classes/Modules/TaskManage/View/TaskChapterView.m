//
//  TaskChapterView.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/21.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskChapterView.h"
#import "NSString+Size.h"
#import "NSMutableAttributedString+Attr.h"
#import "UIView+LineView.h"

@interface TaskCourseView ()

@property (nonatomic,strong) NSArray *numberArr;

@end

@implementation TaskCourseView

- (CGFloat)heightWith:(TaskCourseList *)course {
    
    CGFloat viewMaxW = ScreenW-35;
    
    self.backgroundColor = HEXRGB(0xcccccc);
    
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = HEXRGB(0x333333);
    
    NSString *titleString = [NSString stringWithFormat:@"教程%@、%@",self.numberArr[self.index],course.name];
    titleLabel.text = titleString;
    
    CGFloat titleLabelH = [course.name heightWithFont:[UIFont systemFontOfSize:15] constrainedToWidth:viewMaxW];
    
    titleLabel.frame = CGRectMake(15, 15, viewMaxW, titleLabelH+4);
    
    CGFloat chapterViewY = CGRectGetMaxY(titleLabel.frame)+15;
    
    for (int i = 0; i<course.chapters.count; i++)
    {
        TaskChapters *chapter = course.chapters[i];
        TaskChapterView *chapterView = [TaskChapterView new];
        [self addSubview:chapterView];
        
        chapterView.index = i;
        
        CGFloat viewH = [chapterView configWith:chapter];
        
        chapterView.frame = CGRectMake(0, chapterViewY, ScreenW, viewH);
        chapterViewY += viewH;
    }
    
    return chapterViewY;
    
}

- (NSArray *)numberArr {
    if (!_numberArr)
    {
        _numberArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二十一",@"二十二",@"二十三",@"二十四",@"二十五",@"二十六",@"二十七",@"二十八",@"二十九",@"三十"];
    }
    return _numberArr;
}

@end

@interface TaskChapterView ()

@property (nonatomic,strong) NSArray *numberArr;

@property (nonatomic,strong) TaskChapters * taskChapters;
@end

@implementation TaskChapterView

- (CGFloat)configWith:(TaskChapters *)chapter {
    
    _taskChapters = chapter;
    
    CGFloat viewMaxW = ScreenW-35;
    
    self.backgroundColor = HEXRGB(0xf6f6f6);
    
    //标题
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = HEXRGB(0x333333);
    
    NSString *titleString = [NSString stringWithFormat:@"第%@章：%@",self.numberArr[self.index],chapter.title];
    titleLabel.text = titleString;
    
    CGFloat titleLabelH = [titleString heightWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:viewMaxW];
    
    titleLabel.frame = CGRectMake(15, 15, viewMaxW-40, titleLabelH+4);
    
    //通过率
    UILabel *rateLabel = [UILabel new];
    [self addSubview:rateLabel];
    rateLabel.text = chapter.percent;
    [rateLabel sizeToFit];
    rateLabel.center = titleLabel.center;
    rateLabel.x = ScreenW-60;
    rateLabel.font = [UIFont systemFontOfSize:13];
    rateLabel.textColor = HEXRGB(0x999999);
    
    CGFloat paperViewY = CGRectGetMaxY(titleLabel.frame)+15;
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 10, ScreenW, 30);
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, CGRectGetMaxX(rateLabel.frame), 0, 0)];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    
    if (chapter.isExpand)
    {
        
        [button setImage:[UIImage imageNamed:@"arrows_shrink"] forState:UIControlStateNormal];
        
        for (int i = 0; i<chapter.papers.count; i++)
        {
            TaskPapers *paper = chapter.papers[i];
            TaskPaperView *paperView = [TaskPaperView new];
            [self addSubview:paperView];
            paperView.index = i;
            
            CGFloat paperViewH = [paperView configWith:paper];
            paperView.frame = CGRectMake(0, paperViewY, ScreenW, paperViewH);
            
            paperViewY += paperViewH;
        }
        
    }else
    {
        
        [button setImage:[UIImage imageNamed:@"arrows_unfold"] forState:UIControlStateNormal];
    }
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, paperViewY - 1, ScreenW, 1)];
    lineView.backgroundColor = HEXRGB(0xd1d1d1);
    [self addSubview:lineView];
    
    return paperViewY;
}

-(void)buttonAction:(UIButton *)button
{
    
    _taskChapters.expand = !_taskChapters.expand;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"expandDetail" object:nil];
}
- (NSArray *)numberArr {
    if (!_numberArr)
    {
        _numberArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二十一",@"二十二",@"二十三",@"二十四",@"二十五",@"二十六",@"二十七",@"二十八",@"二十九",@"三十"];
    }
    return _numberArr;
}

@end

@interface TaskPaperView ()

@property (nonatomic,strong) NSArray *numberArr;

@end

@implementation TaskPaperView

- (CGFloat)configWith:(TaskPapers *)paper {
    
    CGFloat viewMaxW = ScreenW-35;
    
    self.backgroundColor = [UIColor whiteColor];
    
    //分割线
    UIView *lineView = [UIView new];
    lineView.backgroundColor = HEXRGB(0xd1d1d1);
    lineView.frame = CGRectMake(0, 0, ScreenW, 0.8);
    [self addSubview:lineView];
    
    //标题
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.textColor = HEXRGB(0x333333);
    
    NSString *titleString = [NSString stringWithFormat:@"试卷%@、%@",self.numberArr[self.index],paper.title];
    titleLabel.text = titleString;
    
    CGFloat titleLabelH = [titleString heightWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:viewMaxW];
    
    titleLabel.frame = CGRectMake(15, 15, viewMaxW, titleLabelH+4);
    
    CGFloat itemViewY = CGRectGetMaxY(titleLabel.frame)+15;
    
    for (int i = 0; i<paper.items.count; i++)
    {
        TaskItems *item = paper.items[i];
        TaskItemView *itemView = [TaskItemView new];
        [self addSubview:itemView];
        itemView.index = i;
        CGFloat itemViewH = [itemView configWith:item];
        itemView.frame = CGRectMake(0, itemViewY, ScreenW, itemViewH);
        itemViewY += itemViewH;
    }
    
    return itemViewY;
    
}

- (NSArray *)numberArr {
    if (!_numberArr)
    {
        _numberArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",@"二十一",@"二十二",@"二十三",@"二十四",@"二十五",@"二十六",@"二十七",@"二十八",@"二十九",@"三十"];
    }
    return _numberArr;
}

@end

@interface TaskItemView ()

@property (nonatomic,strong) NSArray *characterArr;

@property (nonatomic,strong) NSArray *numberArr;

@end

@implementation TaskItemView

- (CGFloat)configWith:(TaskItems *)item {
    
    CGFloat viewMaxW = ScreenW-35;
    
    //设置背景色
    self.backgroundColor = [UIColor whiteColor];
    
    //分割线
    UIView *headLineView = [UIView new];
    [self addSubview:headLineView];
    headLineView.backgroundColor = HEXRGB(0xd1d1d1);
    headLineView.frame = CGRectMake(0, 0, ScreenW, 0.8);
    
    //标题
    UILabel *titleLabel = [UILabel new];
    [self addSubview:titleLabel];
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = HEXRGB(0x999999);
    titleLabel.font = [UIFont systemFontOfSize:13];
    
    NSString *titleString = [NSString stringWithFormat:@"%@、%@",self.numberArr[self.index],item.title];
    titleLabel.text = titleString;
    
    CGFloat titleH = [titleString heightWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:viewMaxW];
    
    titleLabel.frame = CGRectMake(15, 10, viewMaxW, titleH+4);
    
    CGFloat optionY = CGRectGetMaxY(titleLabel.frame)+5;
    //选项
    for (int i = 0; i<item.option.count; i++)
    {
        TaskOption *option = item.option[i];
        
        OptionButton *optionButton = [OptionButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:optionButton];
        
        optionButton.userInteractionEnabled = NO;
        
        
        
        if ([item.type isEqualToString:@"CheckBox"])
        {
            [optionButton setImage:[UIImage imageNamed:@"multiple_m"] forState:UIControlStateNormal];
            [optionButton setImage:[UIImage imageNamed:@"multiple_select"] forState:UIControlStateSelected];
            
        }else if ([item.type isEqualToString:@"RadioJudge"] || [item.type isEqualToString:@"RadioButton"])
        {
            [optionButton setImage:[UIImage imageNamed:@"radio_m"] forState:UIControlStateNormal];
            [optionButton setImage:[UIImage imageNamed:@"radio_select"] forState:UIControlStateSelected];
        }

        NSString *titleString = [NSString stringWithFormat:@"%@、%@",self.characterArr[i],option.content];
        [optionButton setTitle:titleString forState:UIControlStateNormal];
        
        optionButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [optionButton setTitleColor:HEXRGB(0x999999) forState:UIControlStateNormal];
        optionButton.titleLabel.numberOfLines = 0;
        
        optionButton.selected = option.selected;

        //计算高度
        CGFloat optionH = [titleString heightWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:viewMaxW-23-10];
        optionButton.frame = CGRectMake(15, optionY, viewMaxW, optionH+15);
        
//        optionButton.imageView.y = (optionH > 25?7:5);
        
        optionY += CGRectGetHeight(optionButton.frame);
    }
    
    //正确答案
    UILabel *answerLabel = [UILabel new];
    [self addSubview:answerLabel];
    answerLabel.font = [UIFont systemFontOfSize:15];
    NSString *answerString = [NSString stringWithFormat:@"正确答案：%@",item.answer];
    
    NSRange range = [answerString rangeOfString:@"正确答案："];
    answerLabel.attributedText = [NSMutableAttributedString string:answerString value1:HEXRGB(0x333333) range1:NSMakeRange(0, range.length) value2:HEXRGB(0x47c1a9) range2:NSMakeRange(range.length, answerString.length-range.length) font:15];
    
    answerLabel.frame = CGRectMake(15, optionY+5, viewMaxW, 20);
    
    return CGRectGetMaxY(answerLabel.frame)+10;
}

- (NSArray *)characterArr {
    if (!_characterArr) {
        _characterArr = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    }
    return _characterArr;
}

- (NSArray *)numberArr {
    if (!_numberArr)
    {
        _numberArr = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",@"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",@"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",@"40"];
    }
    return _numberArr;
}


@end

@implementation OptionButton

- (instancetype)init {
    if ([super init])
    {
        self.titleLabel.numberOfLines = 0;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.x = 0;
    self.imageView.y = (self.height-self.imageView.height)*0.5;
    
    [self.titleLabel sizeToFit];
    self.titleLabel.x = CGRectGetMaxX(self.imageView.frame)+10;
    self.titleLabel.width = self.width-self.imageView.width-10;
    self.titleLabel.y = (self.height-self.titleLabel.height)*0.5;
    
}

@end
