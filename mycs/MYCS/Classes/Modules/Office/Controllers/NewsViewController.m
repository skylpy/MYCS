//
//  NewsViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "NewsViewController.h"

#import "MJRefresh.h"
#import "NewsListCell.h"

#import "InfomationModel.h"

#import "WebViewDetailController.h"

@interface NewsViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSMutableArray * baseDataSource;

@property (nonatomic,assign) int page;


@end

@implementation NewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseDataSource = [NSMutableArray array];
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    self.tableView.rowHeight = 86;
    
}
#pragma mark -- HTTP
- (void)loadNewData{
    
    self.page = 1;
    
    [InfomationModel InformationListWithCheckID:_checkID Page:_page pageSize:10 success:^(NSArray *list) {
        
        [self.baseDataSource removeAllObjects];
        self.baseDataSource = [NSMutableArray arrayWithArray:list];
        
        [self.tableView headerEndRefreshing];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView headerEndRefreshing];
    }];
    
}

- (void)loadMoreData{
    
    self.page ++;
    
    [InfomationModel InformationListWithCheckID:_checkID Page:_page pageSize:10 success:^(NSArray *list) {
        
        [self.baseDataSource addObjectsFromArray:list];
        
        [self.tableView reloadData];
        
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        self.page --;
        
        [self.tableView footerEndRefreshing];
    }];
    
}
#pragma mark -- tableView Delegate and DataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _baseDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseID = @"NewsListCell";
    
    NewsListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    InfomationModel *model = self.baseDataSource[indexPath.row];
    
    [cell setModel:model];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InfomationModel *model = self.baseDataSource[indexPath.row];
    
    WebViewDetailController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewDetailController"];
    
    NewsListCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    webVC.shareImage = cell.iconImageView.image;
    webVC.isCollege = YES;
    
    webVC.urlStr = model.linkURL;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:webVC animated:YES];
    
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
