//
//  TrainDetailSopController.m
//  MYCS
//
//  Created by yiqun on 16/8/29.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TrainDetailSopController.h"
#import "TableLineCell.h"
#import "TranTableCell.h"
#import "HeaderView.h"
#import "SopDetail.h"
#import "NSDate+Util.h"
#import "UIImageView+WebCache.h"
#import "MediaPlayerViewController.h"
#import "NSMutableAttributedString+Attr.h"
#import "SOPDownLoadView.h"
#import "UIAlertView+Block.h"



@interface TrainDetailSopController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *trainSopTable;

@property (strong,nonatomic)NSArray * allKeysArray;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic,strong) SopDetail *sopDetail;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *taskLable;
@property (weak, nonatomic) IBOutlet UILabel *companyLable;
@property (weak, nonatomic) IBOutlet UILabel *endTimaeLabel;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLable;

@property (nonatomic,retain)NSArray * digitalArr;
@property (nonatomic,retain)UIButton *downButton;
@property (weak, nonatomic) IBOutlet UIButton *cacheButton;
@property (weak, nonatomic) IBOutlet UIButton *starButton;

@end

@implementation TrainDetailSopController

#pragma mark - Getter和Setter
- (NSArray *)digitalArr {
    if (!_digitalArr) {
        _digitalArr = @[@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十"];
    }
    return _digitalArr;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"任务详情";

    self.trainSopTable.tableFooterView = [UIView new];
    self.trainSopTable.tableHeaderView = self.headerView;
    self.trainSopTable.separatorStyle = UITableViewCellSelectionStyleNone;
    self.trainSopTable.backgroundColor = bgsColor;
    
    self.allKeysArray = @[@"教程一",@"教程二",@"教程三",@"教程四",@"教程五",@"教程六",@"教程七",@"教程八",@"教程九",@"教程十",@"教程十一",@"教程十二",@"教程十三",@"教程十四",@"教程十五",@"教程十六",@"教程十七",@"教程十八"];
    
    self.trainSopTable.dataSource = self;
    self.trainSopTable.delegate = self;
    
    
//    [self setNavItem];
}

- (IBAction)backAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cacheAction:(UIButton *)sender {
    self.backButton.enabled = NO;
    self.cacheButton.enabled = NO;
    
    [SOPDownLoadView showWith:self.sopDetail InView:self.navigationController.view belowView:self.navigationController.navigationBar action:^{
        
        self.backButton.enabled = YES;
        self.cacheButton.enabled = YES;
        
    }];
}

- (IBAction)starAction:(UIButton *)sender {
    
    if (self.sopDetail.courseIndex==0&&self.sopDetail.chapterIndex==0)
        return;
    
    //查看最后一个章节是否通过，通过不提示
    SopCourseModel *lastCourse = [self.sopDetail.sopCourse lastObject];
    ChapterModel *lastChapter = [lastCourse.chapters lastObject];
    if (lastChapter.passStatus) return;
    
    NSString *tips = [NSString stringWithFormat:@"上次考核到教程%@的章节%@,是否从教程%@的章节%@继续考核?",self.digitalArr[self.sopDetail.courseIndex],self.digitalArr[self.sopDetail.chapterIndex],self.digitalArr[self.sopDetail.courseIndex],self.digitalArr[self.sopDetail.chapterIndex]];
    [self showAlertWith:tips];
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
- (void)buildUIWith:(SopDetail *)detail {
    
    self.sopDetail = detail;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:detail.picUrl] placeholderImage:PlaceHolderImage];

    self.taskLable.text = detail.taskName;
    self.companyLable.text = detail.enterpriseName;
    self.endTimaeLabel.text = [NSString stringWithFormat:@"截止时间:%@",[NSDate dateWithTimeInterval:[detail.endTime integerValue] format:@"yyyy-MM-dd"]];
    
    self.passLabel.text = detail.passNum;
    self.rankLable.text = detail.rank;
    
    [self.trainSopTable reloadData];
    
    //查看最后一个章节是否通过，通过不提示
    SopCourseModel *lastCourse = [self.sopDetail.sopCourse lastObject];
    ChapterModel *lastChapter = [lastCourse.chapters lastObject];
    if (lastChapter.passStatus) {
        
        [self.starButton setTitle:@"结束考核" forState:UIControlStateNormal];
        [self.starButton setTitleColor:HEXRGB(0x999999) forState:UIControlStateNormal];
        self.starButton.enabled = NO;
    }else if (self.sopDetail.courseIndex==0&&self.sopDetail.chapterIndex==0){
        
        [self.starButton setTitle:@"开始考核" forState:UIControlStateNormal];
    }
    else{
        [self.starButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.starButton setTitle:@"继续考核" forState:UIControlStateNormal];
        
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    HeaderView *headerView = [[HeaderView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 60)];
    [headerView setTitleString:[self.allKeysArray objectAtIndex:section]];
    
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return indexPath.row == 0 ? 105:70;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.sopDetail.sopCourse.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    SopCourseModel *model = self.sopDetail.sopCourse[section];
    return model.chapters.count+1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    SopCourseModel * model = self.sopDetail.sopCourse[indexPath.section];
    if (indexPath.row == 0) {
        
        NSString * EditorID = [NSString stringWithFormat:@"TranTableCell%ld",(long)indexPath.section];
        
        UINib * nib = [UINib nibWithNibName:@"TranTableCell" bundle:[NSBundle mainBundle]];
        [self.trainSopTable registerNib:nib forCellReuseIdentifier:EditorID];
        
        TranTableCell * cell = [tableView dequeueReusableCellWithIdentifier:EditorID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:PlaceHolderImage];
        cell.titleLabel.text = model.courseName;
    
        cell.rateLabel.attributedText = [NSMutableAttributedString transitionString:@"合格指标" andStr:[NSString stringWithFormat:@"%d%%",model.passRate]];
        
        return cell;
        
    }
    else{
    
        NSString * EditorID = [NSString stringWithFormat:@"TableLineCell%ld",(long)indexPath.row];
        
        UINib * nib = [UINib nibWithNibName:@"TableLineCell" bundle:[NSBundle mainBundle]];
        [self.trainSopTable registerNib:nib forCellReuseIdentifier:EditorID];
        
        TableLineCell * cell = [tableView dequeueReusableCellWithIdentifier:EditorID];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        ChapterModel * chaper = model.chapters[indexPath.row-1];
        
        [cell cellReloadData:chaper andIndexPath:indexPath];
        
        cell.upView.hidden = indexPath.row == 1 ? YES :NO;
        cell.downView.hidden = indexPath.row == model.chapters.count ? YES :NO;
        
        return cell;
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    SopCourseModel * model = self.sopDetail.sopCourse[indexPath.section];
    
    if (indexPath.row != 0) {
        
        ChapterModel * chaper = model.chapters[indexPath.row-1];
        
        [MediaPlayerViewController showWith:self coursePackArray:nil videoDetail:nil courseDetail:nil sopDetail:self.sopDetail chapter:chaper DoctorsHealthDetail:nil isTask:YES isPreview:NO previewTips:nil];
    }
}
#pragma mark - Private
- (void)playVideoWithChapter:(ChapterModel *)model {
    [MediaPlayerViewController showWith:self coursePackArray:nil videoDetail:nil courseDetail:nil sopDetail:self.sopDetail chapter:model DoctorsHealthDetail:nil isTask:YES isPreview:NO previewTips:nil];
}



@end
