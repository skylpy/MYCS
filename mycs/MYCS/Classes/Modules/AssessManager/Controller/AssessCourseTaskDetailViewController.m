//
//  AssessCourseTaskDetailViewController.m
//  MYCS
//
//  Created by Yell on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AssessCourseTaskDetailViewController.h"
#import "AssessTaskDetailTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "AssessModel.h"
#import "NSDate+Util.h"
#import "MJRefresh.h"
@interface AssessCourseTaskDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *taskImageView;
@property (weak, nonatomic) IBOutlet UILabel *taskTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *hospitalNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *passRateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (nonatomic,strong) NSMutableArray * listDataSource;


@end

@implementation AssessCourseTaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.listTableView.delegate =self;
    self.listTableView.dataSource = self;
    
    self.listTableView.tableFooterView = [[UIView alloc]init];
    
    self.listDataSource = [NSMutableArray array];
    [self setTitleDetail];
    [self.listTableView addHeaderWithTarget:self action:@selector(loadListData)];
    [self.listTableView headerBeginRefreshing];
    
    UIBarButtonItem * btn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(addToDownloadView)];
    self.navigationItem.rightBarButtonItem = btn;
}


-(void)addToDownloadView
{
    
}

#pragma mark -tableViewDataSource&delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * idStr = @"AssessTaskDetailTableViewCell";
    AssessTaskDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr forIndexPath:indexPath];
    AssessChapterModel * model = self.listDataSource[indexPath.row];
    
    cell.chapterLabel.text = [@"章节" stringByAppendingString:[self digitUppercase:model.listOrder.intValue]];
    cell.model =model;

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

-(void)setTitleDetail
{
    [self.taskImageView sd_setImageWithURL:[NSURL URLWithString:self.model.image] placeholderImage:PlaceHolderImage];
    self.taskTitleLabel.text = self.model.taskName;
    self.rankLabel.text = self.model.rank;
    self.endTimeLabel.text = [NSDate dateWithTimeInterval:[self.model.endTime floatValue] format:@"yyyy-MM-dd"];
    self.passRateLabel.text =[NSString stringWithFormat:@"%@%%",self.model.passRate];
    self.hospitalNameLabel.text = self.model.enterpriseName;
}

-(void)loadListData
{
    [AssessModel getCourseListWithCourseId:self.model.courseId taskId:self.model.taskId Success:^(NSArray *list) {
        [self.listDataSource removeAllObjects];
        [self.listDataSource addObjectsFromArray:list];
        [self.listTableView reloadData];
        [self.listTableView headerEndRefreshing];
    } failure:^(NSError *error) {
        [self showError:error];
        [self.listTableView headerEndRefreshing];
    }];
}

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
