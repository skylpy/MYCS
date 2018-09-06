//
//  OfficeListViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//


#import "OfficeListViewController.h"

#import "OfficeContentModel.h"

#import "MJRefresh.h"
#import "OfficeListCell.h"

#import "OfficePagesViewController.h"

@interface OfficeListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSMutableArray * baseDataSource;

@property (nonatomic,assign) int page;

@end

@implementation OfficeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseDataSource = [NSMutableArray array];
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
}
#pragma mark -- HTTP
- (void)loadNewData{
    
    self.page = 1;
    
    [OfficeUnDetailModel OfficeListsWithUid:_checkID page:_page pageSize:10 success:^(NSArray *officeLists) {
        
        [self.baseDataSource removeAllObjects];
        self.baseDataSource = [NSMutableArray arrayWithArray:officeLists];
        
        [self.tableView headerEndRefreshing];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView headerEndRefreshing];
        
    }];
    
    
}

- (void)loadMoreData{
    
    self.page ++;
    
    [OfficeUnDetailModel OfficeListsWithUid:_checkID page:_page pageSize:10 success:^(NSArray *officeLists) {
        
        [self.baseDataSource addObjectsFromArray:officeLists];
        
        [self.tableView reloadData];
        
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        self.page --;
        
        [self.tableView footerEndRefreshing];
        
    }];
    
}
#pragma mark -- tableView Delegate And DataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.baseDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *reuseID = @"OfficeListCell";
    OfficeListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    OfficeUnDetailModel * model = self.baseDataSource[indexPath.row];
    
    [cell setModel:model];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    OfficeUnDetailModel *model = _baseDataSource[indexPath.row];
    
    OfficePagesViewController *officePageVC = [[UIStoryboard storyboardWithName:@"Office" bundle:nil] instantiateViewControllerWithIdentifier:@"OfficePagesViewController"];
    
    officePageVC.type = OfficeTypeOffice;
    officePageVC.uid = model.uid;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:officePageVC animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
#pragma mark -- setting and getting
- (void)setCheckID:(NSString *)checkID
{
    _checkID = checkID;
    
    if (self.baseDataSource.count == 0)
    {
        [self.tableView headerBeginRefreshing];

    }
    
}

@end
