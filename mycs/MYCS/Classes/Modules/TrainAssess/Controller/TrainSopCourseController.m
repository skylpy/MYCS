//
//  TrainSopCourseController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/27.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TrainSopCourseController.h"
#import "UIImageView+WebCache.h"

static NSString *const reuseId = @"TrainChapterCell";

@interface TrainSopCourseController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *courseDescLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *digitalArr;

@end

@implementation TrainSopCourseController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sopCourse.chapters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TrainChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    cell.chapterOrderLabel.text = [NSString stringWithFormat:@"章节%@",self.digitalArr[indexPath.row]];
    
    ChapterModel *model = self.sopCourse.chapters[indexPath.row];
    cell.chapter = model;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.cellAction)
    {
        TrainChapterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.cellAction(self.sopCourse,cell.chapter);
    }
    
}

#pragma mark - Getter和Setter
- (void)setSopCourse:(SopCourseModel *)sopCourse {
    _sopCourse = sopCourse;
    
    self.courseDescLabel.text = sopCourse.courseName;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:sopCourse.image] placeholderImage:PlaceHolderImage];
    NSString *passRate = [NSString stringWithFormat:@"%d%%",sopCourse.passRate];
    self.rateLabel.text = passRate;
    
    [self.tableView reloadData];
}

#pragma mark - Getter和Setter
- (NSArray *)digitalArr {
    if (!_digitalArr) {
        _digitalArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十"];
    }
    return _digitalArr;
}

@end

@interface TrainChapterCell ()

@property (weak, nonatomic) IBOutlet UILabel *chapterNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *grateRateLabel;

@end

@implementation TrainChapterCell

- (void)setChapter:(ChapterModel *)chapter {
    _chapter = chapter;
    
    self.chapterNameLabel.text = chapter.name;
    self.grateRateLabel.text = chapter.chapter_rate;
    
    NSString *passText = chapter.passStatus?@"已达标":@"未达标";
    self.passLabel.text = passText;
    
    NSString *status = chapter.cando&&chapter.passStatus?@"继续学习":@"开始考核";
    self.statusLabel.text = status;
    
    if (!chapter.cando)
    {
        self.userInteractionEnabled = NO;
        self.chapterOrderLabel.textColor = HEXRGB(0x999999)
        ;
        self.chapterOrderLabel.textColor = HEXRGB(0x999999);
        self.passLabel.textColor = HEXRGB(0x999999);
        self.statusLabel.textColor = HEXRGB(0x999999);
    }
    else
    {
        self.userInteractionEnabled = YES;

        if (chapter.passStatus)
        {
            self.chapterOrderLabel.textColor = HEXRGB(0x333333);
            self.chapterNameLabel.textColor = HEXRGB(0x333333);
            self.passLabel.textColor = HEXRGB(0x47c1a8);
            self.statusLabel.textColor = HEXRGB(0x47c1a8);
        }
        else
        {
            self.chapterOrderLabel.textColor = HEXRGB(0x333333);
            self.chapterNameLabel.textColor = HEXRGB(0x333333);
            self.passLabel.textColor = HEXRGB(0xf66060);
            self.statusLabel.textColor = [UIColor orangeColor];
        }
    }
    
}

@end
