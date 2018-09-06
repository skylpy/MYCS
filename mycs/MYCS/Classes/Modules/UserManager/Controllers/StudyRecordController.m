//
//  StudyRecordController.m
//  MYCS
//
//  Created by wzyswork on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "StudyRecordController.h"

#import "MJRefresh.h"
#import "StudyRecordTableViewCell.h"

#import "StudyRecord.h"

@interface StudyRecordController ()

@property (strong, nonatomic) NSMutableArray *dataSource;

@property (assign, nonatomic) int page;

@end

@implementation StudyRecordController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
}
#pragma mark -- setting and getting
-(void)setMemberID:(NSString *)memberID
{
    _memberID = memberID;
    
    [self loadNewData];
}
#pragma mark -- HTTP
- (void)loadNewData
{
    
    self.page = 1;
    
    [StudyRecord requestStudyRecordListWithUerId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] memberID:self.memberID pageNo:self.page pageSize:@"10" success:^(NSArray *list) {
        
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:list];
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView headerEndRefreshing];
        [self showError:error];
    }];
    
    
}

- (void)loadMoreData
{
    self.page ++;
    
    [StudyRecord requestStudyRecordListWithUerId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] memberID:self.memberID pageNo:self.page pageSize:@"10" success:^(NSArray *list) {
        
        [self.dataSource addObjectsFromArray:list];
        
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        self.page --;
        [self.tableView footerEndRefreshing];
        [self showError:error];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = HEXRGB(0xcccccc);
    view.frame = CGRectMake(0, 0, [tableView width], 35);
    
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 1, 70, 33)];
    leftLabel.text = @"发布时间";
    leftLabel.font = [UIFont systemFontOfSize:13];
    leftLabel.backgroundColor = HEXRGB(0xF0F0F0);
    leftLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:leftLabel];
    
    UILabel *centerLabel = [[UILabel alloc] initWithFrame:CGRectMake([leftLabel x]+[leftLabel width]+1, 1, [tableView width]-70*2+1, 33)];
    centerLabel.text = @"学习课程";
    centerLabel.font = [UIFont systemFontOfSize:13];
    centerLabel.backgroundColor = HEXRGB(0xF0F0F0);
    centerLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:centerLabel];
    
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake([centerLabel x]+[centerLabel width]+1, 1, 66, 33)];
    rightLabel.text = @"已发人次";
    rightLabel.font = [UIFont systemFontOfSize:13];
    rightLabel.backgroundColor = HEXRGB(0xF0F0F0);
    rightLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:rightLabel];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"StudyRecordTableViewCell";
    StudyRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    [cell.nameLabel setWidth:[tableView width]-70*2 + 1];
    [cell.numberLabel setX:[cell.nameLabel x]+[cell.nameLabel width]+1];
    
    if (self.dataSource.count > indexPath.row)
    {
        StudyRecord *temp = [self.dataSource objectAtIndex:indexPath.row];
        
        cell.timeLabel.text = temp.addTime;
        cell.nameLabel.text = temp.courseName;
        cell.numberLabel.text = temp.staff;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    return cell;
}

@end
