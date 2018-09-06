//
//  TrainSopDetailController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TrainSopDetailController.h"
#import "SopDetail.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Util.h"
#import "UIImage+Color.h"
#import "TrainSopCourseController.h"
#import "MediaPlayerViewController.h"
#import "SOPDownLoadView.h"
#import "UIAlertView+Block.h"

@interface TrainSopDetailController ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *enterLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *courseContentView;
@property (weak, nonatomic) IBOutlet UIButton *showAllCourseButton;

@property (nonatomic,strong) SopDetail *sopDetail;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseContentViewConstH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentConstH;

@property (nonatomic,assign) CGFloat contentH;

@property (nonatomic,strong) NSArray *digitalArr;

@property (nonatomic,strong) UIButton *selectButton;

@property (nonatomic,strong) TrainSopCourseController *courseVC;

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UIButton *cacheButton;

@property (nonatomic,assign) int refreshCount;

@end

@implementation TrainSopDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.courseVC = [self.childViewControllers firstObject];
    self.showAllCourseButton.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setCellClickAction];
}

- (void)buildUIWith:(SopDetail *)detail {
    
    self.sopDetail = detail;

    [self.iconView sd_setImageWithURL:[NSURL URLWithString:detail.picUrl] placeholderImage:PlaceHolderImage];
    
    self.nameLabel.text = detail.taskName;
    self.enterLabel.text = detail.enterpriseName;
    self.endTimeLabel.text = [NSDate dateWithTimeInterval:[detail.endTime integerValue] format:@"yyyy-MM-dd"];
    
    [self addCourseButtonWith:detail.sopCourse];
}

- (void)addCourseButtonWith:(NSArray *)sopCourse {
    
    //移除子试图
    [self.courseContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat margin = 10;
    NSInteger count = 5;
    
    CGFloat buttonW = (ScreenW-(count+1)*margin)/count;
    CGFloat buttonH = 40;
    
    for (int i = 0; i<sopCourse.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.courseContentView addSubview:button];
        
        [button setBackgroundImage:[UIImage imageWithColor:HEXRGB(0x47c1a8)] forState:UIControlStateSelected];
        [button setBackgroundImage:[UIImage imageWithColor:HEXRGB(0xf4f4f4)] forState:UIControlStateNormal];
        [button setTitleColor:HEXRGB(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:HEXRGB(0xffffff) forState:UIControlStateSelected];
        
        NSString *title = [NSString stringWithFormat:@"教程%@",self.digitalArr[i]];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [button setTitle:title forState:UIControlStateNormal];
        [button addTarget:self action:@selector(courseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = i;
        
        CGFloat col = i%count;
        CGFloat row = i/count;
        
        CGFloat buttonX = margin + (buttonW+margin)*col;
        CGFloat buttonY = (buttonH + margin)*row;
        
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        self.contentH = CGRectGetMaxY(button.frame);
        
        if (row > 0)
        {
            self.showAllCourseButton.hidden = NO;
        }
    }
    
    UIButton *button = [self.courseContentView.subviews firstObject];
    [self courseButtonAction:button];
    
}

#pragma mark - Action
- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)showAllCourseButtonAction:(UIButton *)button {
    
    button.selected = !button.selected;
    
    CGFloat contentH;
    if (button.selected)
    {
        contentH = self.contentH;
    }
    else
    {
        contentH = 40;
    }
    
    self.contentConstH.constant = contentH;
    [self.view layoutIfNeeded];
    self.courseContentViewConstH.constant = CGRectGetMaxY(self.showAllCourseButton.frame);
    [self.view layoutIfNeeded];
    
}

- (void)courseButtonAction:(UIButton *)button {
    
    self.selectButton.selected = NO;
    self.selectButton = button;
    self.selectButton.selected = YES;
    
}

- (void)setCellClickAction {
    
    __weak typeof(self) weakSelf = self;
    self.courseVC.cellAction = ^(SopCourseModel *sopCourse,ChapterModel *model){
        
        [MediaPlayerViewController showWith:weakSelf coursePackArray:nil videoDetail:nil courseDetail:nil sopDetail:weakSelf.sopDetail chapter:model DoctorsHealthDetail:nil isTask:YES isPreview:NO previewTips:nil];
        
    };
    
}

- (IBAction)cacheAction:(UIButton *)sender {
    
    self.backButton.enabled = NO;
    self.cacheButton.enabled = NO;
    
    [SOPDownLoadView showWith:self.sopDetail InView:self.navigationController.view belowView:self.navigationController.navigationBar action:^{
        
        self.backButton.enabled = YES;
        self.cacheButton.enabled = YES;

    }];
    
}

#pragma mark - Private
- (void)playVideoWithChapter:(ChapterModel *)model {
    [MediaPlayerViewController showWith:self coursePackArray:nil videoDetail:nil courseDetail:nil sopDetail:self.sopDetail chapter:model DoctorsHealthDetail:nil isTask:YES isPreview:NO previewTips:nil];
}

#pragma mark - Network
- (void)loadData {
    
    [self showLoadingHUD];
    
    [SopDetail sopDetailToDoTaskWithSopId:self.SOPId taskId:self.taskId success:^(SopDetail *sopDetail) {
        
        [self buildUIWith:sopDetail];
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

- (void)setSelectButton:(UIButton *)selectButton {
    _selectButton = selectButton;
    
    SopCourseModel *model = self.sopDetail.sopCourse[selectButton.tag];
    self.courseVC.sopCourse = model;
}

- (void)setSopDetail:(SopDetail *)sopDetail {
    _sopDetail = sopDetail;
    
    if (self.refreshCount==0)
    {
        if (sopDetail.courseIndex==0&&sopDetail.chapterIndex==0)
            return;
        
        //查看最后一个章节是否通过，通过不提示
        SopCourseModel *lastCourse = [sopDetail.sopCourse lastObject];
        ChapterModel *lastChapter = [lastCourse.chapters lastObject];
        if (lastChapter.passStatus) return;

        NSString *tips = [NSString stringWithFormat:@"上次考核到教程%@的章节%@,是否从教程%@的章节%@继续考核?",self.digitalArr[sopDetail.courseIndex],self.digitalArr[sopDetail.chapterIndex],self.digitalArr[sopDetail.courseIndex],self.digitalArr[sopDetail.chapterIndex]];
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
            SopCourseModel *courseModel = self.sopDetail.sopCourse[self.sopDetail.courseIndex];
            ChapterModel *chapter = courseModel.chapters[self.sopDetail.chapterIndex];
            [self playVideoWithChapter:chapter];
        }
        
    }];
}


@end
