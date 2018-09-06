//
//  TrainCourseDetailController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TrainCourseDetailController.h"
#import "CourseDetail.h"
#import "NSDate+Util.h"
#import "UIImageView+WebCache.h"
#import "TrainSopCourseController.h"
#import "MediaPlayerViewController.h"
#import "CourseDownLoadView.h"
#import "UIAlertView+Block.h"

static NSString *const reuseId = @"TrainChapterCell";

@interface TrainCourseDetailController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *enterLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *passRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@property (nonatomic,strong) CourseDetail *courseDetail;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *digitalArr;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *cacheButton;

@property (nonatomic,assign) int refreshCount;

@end

@implementation TrainCourseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [UIView new];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)buildUIWith:(CourseDetail *)courseDetail {
    self.courseDetail = courseDetail;
    
    self.courseNameLabel.text = courseDetail.taskName;
    self.enterLabel.text = courseDetail.enterpriseName;
    self.rankLabel.text = courseDetail.rank;
    self.passRateLabel.text = [NSString stringWithFormat:@"%@%%",courseDetail.passRate];
    self.endTimeLabel.text = [NSDate dateWithTimeInterval:[courseDetail.endTime integerValue] format:@"yyyy-MM-dd"];
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:courseDetail.image] placeholderImage:PlaceHolderImage];
    
    [self.tableView reloadData];
    
}

#pragma mark - Action
- (IBAction)cacheAction:(UIButton *)sender {
    
    self.backButton.enabled = NO;
    self.cacheButton.enabled = NO;
    [CourseDownLoadView showWith:self.courseDetail InView:self.navigationController.view belowView:self.navigationController.navigationBar action:^(void) {
        self.backButton.enabled = YES;
        self.cacheButton.enabled = YES;
    }];
    
}

- (IBAction)backButtonAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.courseDetail.chapters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TrainChapterCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    cell.chapterOrderLabel.text = [NSString stringWithFormat:@"章节%@",self.digitalArr[indexPath.row]];
    
    ChapterModel *model = self.courseDetail.chapters[indexPath.row];
    cell.chapter = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TrainChapterCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self playVideoWithChapter:cell.chapter];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

#pragma mark - Private
- (void)playVideoWithChapter:(ChapterModel *)model {
    [MediaPlayerViewController showWith:self coursePackArray:nil videoDetail:nil courseDetail:self.courseDetail sopDetail:nil chapter:model DoctorsHealthDetail:nil isTask:YES isPreview:NO previewTips:nil];
}

#pragma mark - Network
- (void)loadData {
    
    [self showLoadingHUD];
    
    [CourseDetail courseDetailToDoTaskWithacourseId:self.courseId taskId:self.taskId success:^(CourseDetail *courseDetail) {
        
        [self buildUIWith:courseDetail];
        [self dismissLoadingHUD];
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        [self showError:error];
    }];
    
}

#pragma mark - Getter和Setter
- (NSArray *)digitalArr {
    if (!_digitalArr) {
        _digitalArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十"];
    }
    return _digitalArr;
}

- (void)setCourseDetail:(CourseDetail *)courseDetail {
    _courseDetail = courseDetail;
    
    if (self.refreshCount==0)
    {
        if (courseDetail.nextIndex==0) return;
        
        //查看最后一个章节是否通过，通过不提示
        ChapterModel *lastChapter = [courseDetail.chapters lastObject];
        if (lastChapter.passStatus) return;
        
        NSString *tips = [NSString stringWithFormat:@"上次考核到第%@章节,是否从第%@章节继续考核?",self.digitalArr[courseDetail.nextIndex],self.digitalArr[courseDetail.nextIndex]];
        [self showAlertWith:tips];
    }
    
    self.refreshCount++;
}

- (void)showAlertWith:(NSString *)tips {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:tips cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];
    
    [alertView showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        
        //点击确定按钮
        if (buttonIndex==1)
        {
            ChapterModel *chapter = self.courseDetail.chapters[self.courseDetail.nextIndex];
            [self playVideoWithChapter:chapter];
        }
        
    }];
}


@end
