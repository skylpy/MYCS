//
//  NewsListViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/3/17.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "NewsListViewController.h"
#import "MJRefresh.h"
#import "InfomationModel.h"
#import "InformationCell.h"
#import "WebViewDetailController.h"

static NSString *const reuseId = @"InformationCell";

@interface NewsListViewController ()<UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) int page;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) int cid;

@end

@implementation NewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.dataSource = [NSMutableArray array];
    
    [self registerCell];
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    self.tableView.tableFooterView = [UIView new];
}

- (void)loadTableView
{
    [self.tableView headerBeginRefreshing];
}

- (void)registerCell {
    self.tableView.rowHeight = 86;
    UINib * nib = [UINib nibWithNibName:@"InformationCell"
                                 bundle: [NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseId];
}

#pragma mark - Network
- (void)loadNewData {
    
    self.page = 1;
    
    [InfomationModel InformationListWithPage:self.page pageSize:10 cid:self.cid fromeCache:YES success:^(NSArray *list) {
        
        if (list.count == 0)
        {
            return;
        }
        
        self.dataSource = [NSMutableArray arrayWithArray:list];
        
        [self.tableView reloadData];
        
        [self.tableView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView headerEndRefreshing];
        
    }];
    
}

- (void)loadMoreData {
    
    self.page ++;
    
    [InfomationModel InformationListWithPage:self.page pageSize:10 cid:self.cid fromeCache:YES success:^(NSArray *list) {
        
        if (list.count == 0)
        {
            return;
        }
        
        [self.dataSource addObjectsFromArray:list];
        
        [self.tableView reloadData];
        
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.tableView footerEndRefreshing];
        
    }];
    
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    InfomationModel *model = self.dataSource[indexPath.row];

    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WebViewDetailController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewDetailController"];
    
    //传递分享的图片
    InformationCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    webVC.shareImage = cell.ImageView.image;
    
    InfomationModel *model = self.dataSource[indexPath.row];
    
    webVC.urlStr = model.linkURL;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:webVC animated:YES];
    
}

#pragma mark - Getter&Setter
- (void)setType:(NewsType)type {
    _type = type;

    if (type==NewsTypeLast)
    {
        self.cid = 46;
    }
    else if (type==NewsTypeSkill)
    {
        self.cid = 47;
    }
    else if (type==NewsTypeCenter)
    {
        self.cid = 54;
    }
}

@end
