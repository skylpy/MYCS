//
//  TrainDetailCourseController.m
//  MYCS
//
//  Created by yiqun on 16/8/29.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TrainDetailCourseController.h"
#import "TableLineCell.h"
#import "CourseDetail.h"
#import "NSDate+Util.h"
#import "UIImageView+WebCache.h"
#import "MediaPlayerViewController.h"
#import "CourseDownLoadView.h"
#import "UIAlertView+Block.h"


@interface TrainDetailCourseController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *taskName;
@property (weak, nonatomic) IBOutlet UILabel *companyName;
@property (weak, nonatomic) IBOutlet UILabel *endTimeName;
@property (weak, nonatomic) IBOutlet UILabel *throughNum;
@property (weak, nonatomic) IBOutlet UILabel *rankNum;
@property (weak, nonatomic) IBOutlet UILabel *indicatorNum;

@property (weak, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UITableView *tranTableView;

@property (nonatomic,strong) CourseDetail *courseDetail;

@property (nonatomic,retain)UIButton *downButton;
@property (nonatomic,retain)NSArray * digitalArr;
@property (weak, nonatomic) IBOutlet UIButton *starButton;

@property (nonatomic,assign) int refreshCount;

@end

@implementation TrainDetailCourseController

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
    
    self.view.backgroundColor = bgsColor;
     self.tranTableView.tableFooterView = [UIView new];
    self.tranTableView.tableHeaderView = self.headerView;
    self.tranTableView.backgroundColor = bgsColor;
    self.tranTableView.delegate = self;
    self.tranTableView.dataSource = self;
    self.tranTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.automaticallyAdjustsScrollViewInsets = false;
    [self setNavItem];
    
}

-(void)setNavItem{
    
    // 导航条右
    self.downButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.downButton.frame = CGRectMake(0, 0, 20, 20);
    [self.downButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    [self.downButton addTarget:self action:@selector(downAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.downButton];
    
}

-(void)downAction:(UIButton *)sender{

    self.downButton.enabled = NO;
    [CourseDownLoadView showWith:self.courseDetail InView:self.navigationController.view belowView:self.navigationController.navigationBar action:^(void) {

        self.downButton.enabled = YES;
    }];
}
- (IBAction)starAction:(UIButton *)sender {
    
    if (self.courseDetail.nextIndex==0) return;
    
    //查看最后一个章节是否通过，通过不提示
    ChapterModel *lastChapter = [self.courseDetail.chapters lastObject];
    if (lastChapter.passStatus) return;
    
    NSString *tips = [NSString stringWithFormat:@"上次考核到第%@章节,是否从第%@章节继续考核?",self.digitalArr[self.courseDetail.nextIndex],self.digitalArr[self.courseDetail.nextIndex]];
    [self showAlertWith:tips];
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
- (void)buildUIWith:(CourseDetail *)courseDetail {

    self.courseDetail = courseDetail;
    
    self.taskName.text = courseDetail.taskName;
    self.companyName.text = courseDetail.enterpriseName;
    self.rankNum.text = courseDetail.rank;
    self.indicatorNum.text = [NSString stringWithFormat:@"%@%%",courseDetail.passRate];
    self.endTimeName.text = [NSString stringWithFormat:@"截止日期：%@",[NSDate dateWithTimeInterval:[courseDetail.endTime integerValue] format:@"yyyy-MM-dd"]];

    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:courseDetail.image] placeholderImage:PlaceHolderImage];
    
    self.throughNum.text = [NSString stringWithFormat:@"%@",courseDetail.passNum];
    
    self.rankNum.text = courseDetail.rank;
    
    self.indicatorNum.text = [NSString stringWithFormat:@"%@%%",courseDetail.passRate];
    
    [self.tranTableView reloadData];
    
    //查看最后一个章节是否通过，通过不提示
    ChapterModel *lastChapter = [courseDetail.chapters lastObject];
    if (lastChapter.passStatus) {
    
        [self setStarTitle:@"结束考核" andColor:HEXRGB(0x999999)];
        self.starButton.enabled = NO;
        
    }else if (courseDetail.nextIndex==0){
    
        [self setStarTitle:@"开始考核" andColor:HEXRGB(0x47c1a8)];
    }
    else{
        
        [self setStarTitle:@"继续考核" andColor:[UIColor orangeColor]];
    }
}

-(void)setStarTitle:(NSString *)title andColor:(UIColor *)color{

    [self.starButton setTitle:title forState:UIControlStateNormal];
    [self.starButton setTitleColor:color forState:UIControlStateNormal];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 70;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.courseDetail.chapters.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * EditorID = [NSString stringWithFormat:@"TableLineCell%ld",(long)indexPath.row];

    UINib * nib = [UINib nibWithNibName:@"TableLineCell" bundle:[NSBundle mainBundle]];
    [self.tranTableView registerNib:nib forCellReuseIdentifier:EditorID];
    
    TableLineCell * cell = [tableView dequeueReusableCellWithIdentifier:EditorID];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.upView.hidden = indexPath.row == 0 ? YES :NO;
    cell.downView.hidden = indexPath.row == self.courseDetail.chapters.count - 1 ? YES :NO;
    ChapterModel *model = self.courseDetail.chapters[indexPath.row];
    
    [cell cellReloadData:model andIndexPath:indexPath];
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    ChapterModel * chaper = self.courseDetail.chapters[indexPath.row];
    
   [self playVideoWithChapter:chaper];
}
#pragma mark - Private
- (void)playVideoWithChapter:(ChapterModel *)model {
    [MediaPlayerViewController showWith:self coursePackArray:nil videoDetail:nil courseDetail:self.courseDetail sopDetail:nil chapter:model DoctorsHealthDetail:nil isTask:YES isPreview:NO previewTips:nil];
}


@end
