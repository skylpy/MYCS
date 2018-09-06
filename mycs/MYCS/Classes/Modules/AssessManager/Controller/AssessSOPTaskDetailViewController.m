//
//  AssessSOPTaskDetailViewController.m
//  MYCS
//
//  Created by Yell on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AssessSOPTaskDetailViewController.h"
#import "AssessTaskDetailTableViewCell.h"
#import "AssessSOPProgessButton.h"
#import "AssessSOPDetailListBtnFrame.h"
#import "AssessModel.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Util.h"
#import "MJRefresh.h"

@interface AssessSOPTaskDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
//SOP详情
@property (weak, nonatomic) IBOutlet UIImageView *SOPimageView;
@property (weak, nonatomic) IBOutlet UILabel *SOPtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskEndTimeLabel;

//教程详情
@property (weak, nonatomic) IBOutlet UIImageView *CourseImageView;
@property (weak, nonatomic) IBOutlet UILabel *CourseTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *passRateLabel;

//学习进度View
@property (weak, nonatomic) IBOutlet UIView *progessTitleView;
@property (weak, nonatomic) IBOutlet UIView *progessView;
@property (weak, nonatomic) IBOutlet UIView *btnsView;
@property (weak, nonatomic) IBOutlet UIButton *AllBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progessViewHeightconstraint;
@property (strong,nonatomic) NSMutableArray * courseBtnsList;

//章节列表
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (nonatomic,strong) NSMutableArray * listDataSource;

//tool
@property (strong,nonatomic) AssessSOPDetailListBtnFrame * listBtnFrameModels;
@property (weak,nonatomic) AssessSOPProgessButton * selectedBtn;


@end

@implementation AssessSOPTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listTableView.delegate = self;
    self.listTableView.dataSource =self;
    self.listTableView.tableFooterView = [[UIView alloc]init];
    
    
    self.listDataSource = [NSMutableArray array];
    self.courseBtnsList = [NSMutableArray array];
    
    [self.AllBtn setTitle:@"查看全部" forState:UIControlStateNormal];
    [self.AllBtn setTitle:@"收起列表" forState:UIControlStateSelected];
    
    self.listBtnFrameModels = [[AssessSOPDetailListBtnFrame alloc]init];
    self.SOPtitleLabel.text = self.model.taskName;
    self.taskEndTimeLabel.text = [NSDate dateWithTimeInterval:[self.model.endTime floatValue] format:@"yyyy-MM-dd"];
    
    UIBarButtonItem * btn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(addToDownloadView)];
    self.navigationItem.rightBarButtonItem = btn;
    
    [self.listTableView addHeaderWithTarget:self action:@selector(loadListData)];
    [self.listTableView headerBeginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (IBAction)AlltButtonAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    NSInteger btnCount;
    
    if (sender.selected) {
        btnCount = self.listDataSource.count;
        self.progessViewHeightconstraint.constant = self.listBtnFrameModels.ViewHeight+self.progessTitleView.height+self.AllBtn.height;
        
    }else
    {
        btnCount =  self.listBtnFrameModels.BtnCountInRow;
        self.progessViewHeightconstraint.constant = self.listBtnFrameModels.hiddenViewHeight+self.progessTitleView.height+self.AllBtn.height;

    }
    
    
    [self setCourseTitleBtnsShowWithCount:(int)btnCount];
    
}

-(void)CourseBtnAction:(AssessSOPProgessButton *)button
{
    if (button == self.selectedBtn)
        return;
    
    button.selected = YES;
    self.selectedBtn.selected = NO;
    self.selectedBtn = button;
    [self resetCourseDetailAndList];

}

-(void)addToDownloadView
{
    
}

#pragma mark -tableViewDataSource&delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.selectedBtn == nil)
    {
        return 0;
    }
    else{
        AssessCourseModel * CourseModel = self.listDataSource[self.selectedBtn.tag];

        return CourseModel.chapter.list.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * idStr = @"AssessTaskDetailTableViewCell";
    AssessTaskDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr forIndexPath:indexPath];
    
    AssessCourseModel * CourseModel = self.listDataSource[self.selectedBtn.tag];
    
    AssessChapterModel * model = CourseModel.chapter.list[indexPath.row];
    
    cell.chapterLabel.text = [@"章节" stringByAppendingString:[self digitUppercase:model.listOrder.intValue]];
    cell.model =model;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



#pragma mark -网络链接

-(void)loadListData
{
    [AssessModel getSOPListWithSopId:self.model.sopId taskId:self.model.taskId Success:^(NSArray *list) {
        [self.listDataSource removeAllObjects];
        [self.listDataSource addObjectsFromArray:list];
        [self setCourseTitleBtnsWithList:self.listDataSource];
        [self.listTableView headerEndRefreshing];
    } failure:^(NSError *error) {
        [self showError:error];
        [self.listTableView headerEndRefreshing];
        
    }];
}

#pragma mark -设置教程内容
-(void)resetCourseDetailAndList
{
    AssessCourseModel * model = self.listDataSource[self.selectedBtn.tag];
    self.CourseTitleLabel.text = model.name;
    self.passRateLabel.text = [NSString stringWithFormat:@"%@%%",model.pass_rate];
    
//    self.CourseImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:<#(UIImage *)#>
    
    [self.listTableView reloadData];

}

-(void)setCourseTitleBtnsShowWithCount:(int)count
{
    int num = 0;
    BOOL btnStutas = NO;
    for (AssessSOPProgessButton * btn in self.courseBtnsList) {
        
        if (num == count)
            btnStutas = YES;
        
        btn.hidden = btnStutas;
        num++;
    }
}


-(void)setCourseTitleBtnsWithList:(NSArray *)list
{
    [self.listBtnFrameModels calculateBtnsFrameWithArray:list View:self.btnsView];
    
    if (self.courseBtnsList.count>0)
        return;
    
    int tag = 0;
    for (AssessSOPDetailBtnFrameModel * model in self.listBtnFrameModels.modelList) {
        AssessSOPProgessButton * btn = [AssessSOPProgessButton buttonWithType:UIButtonTypeCustom];
        btn.frame = model.btnModelFrame;
        btn.tag = tag;
        [btn setTitle:[@"教程" stringByAppendingString:[self digitUppercase:tag+1]] forState:UIControlStateNormal];
        [btn setTitleColor:HEXRGB(0x33333) forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btn setBackgroundColor:HEXRGB(0xf4f4f4)];
        
        btn.titleLabel.font = [UIFont systemFontOfSize:14];

        btn.CourseId = model.courseId;
        
        [btn addTarget:self action:@selector(CourseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.courseBtnsList addObject:btn];
        [self.btnsView addSubview:btn];
        
        if (tag == 0 && self.selectedBtn ==nil)
        {
            self.selectedBtn = btn;
            btn.selected = YES;
        }
        
        tag++;
    }
    
    [self setCourseTitleBtnsShowWithCount:self.listBtnFrameModels.BtnCountInRow];
    [self resetCourseDetailAndList];

}


//tool
-(NSString *)digitUppercase:(int)row
{
    NSArray *Base=@[@"零",@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九"];
    NSMutableString *TitleStr=[[NSMutableString alloc] init];
    
    if (row>=10) {
        
        if (row/10>1)
            [TitleStr appendString:Base[row/10]];
        
        [TitleStr appendString:@"十"];
        
        if (row%10>0)
            
            [TitleStr appendString:Base[row%10]];
        
    }else
    {
        [TitleStr appendString:Base[row]];
    }
    
    NSLog(@"%@",TitleStr);
    return TitleStr;
}


@end
