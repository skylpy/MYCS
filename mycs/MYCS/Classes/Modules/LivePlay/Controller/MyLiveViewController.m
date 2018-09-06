//
//  MyLiveViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/4/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MyLiveViewController.h"
#import "OnLiveViewController.h"
#import "MJRefresh.h"
#import "UITableView+UITableView_Util.h"
#import "UIImageView+WebCache.h"
#import "ReleaseLiveViewController.h"
#import "LiveNaviViewController.h"
#import "WatchLiveViewController.h"
#import "LanscapeNaviController.h"

static NSString *const reuseID = @"MyLiveCell";

@interface MyLiveViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) int page;

@end

@implementation MyLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;
    //
    self.dataSource = [NSMutableArray array];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView addHeaderWithCallback:^{
        [self loadNewsData];
        [self.tableView removeNoDataTipsView];
    }];
    [self.tableView addFooterWithCallback:^{
        [self loadMoreData];
    }];
    
    [self.tableView headerBeginRefreshing];
}

-(void)loadNewsData
{
    self.page = 1;
    [LiveListModel requestListDataWithStatus:@"0" Action:@"list" Sort:@"manage" Page:self.page PageSize:10 Success:^(NSArray *list) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:list];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        if (list.count == 0)
        {
            [self.tableView setNoDataTipsView:0];
        }
        
    } Failure:^(NSError *error) {
        [self showError:error];
        [self.tableView headerEndRefreshing];
    }];
}
-(void)loadMoreData
{
    self.page += 1;
    [LiveListModel requestListDataWithStatus:@"0" Action:@"list" Sort:@"manage" Page:self.page PageSize:10 Success:^(NSArray *list) {
        
        [self.dataSource addObjectsFromArray:list];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        
    } Failure:^(NSError *error) {
        [self showError:error];
        [self.tableView footerEndRefreshing];
    }];

}
#pragma mark - TableView的代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 9.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MyLiveCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    LiveListModel *model = self.dataSource[indexPath.section];
    cell.model = model;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LiveListModel *model = self.dataSource[indexPath.section];
    
    if (model.status == 4)
    {
        WatchLiveViewController *watchVC = [WatchLiveViewController new];
        LanscapeNaviController *naviVC = [[LanscapeNaviController alloc] initWithRootViewController:watchVC];
        
        watchVC.liveEnd = YES;
        watchVC.liveType = 4;
        watchVC.roomId = model.pk;
        watchVC.listModel = model;
        [self presentViewController:naviVC animated:YES completion:nil];
        
        return;
    }
    
    OnLiveViewController *watchVC = [OnLiveViewController new];
    
    watchVC.IsHorizontal = YES;
    watchVC.roomId = model.pk;
    watchVC.listModel = model;
    watchVC.sureButtonBlock = ^(){
        [self loadNewsData];
    };
     LiveNaviViewController *naviVC = [[LiveNaviViewController alloc] initWithRootViewController:watchVC];
    [[AppDelegate sharedAppDelegate].rootNavi presentViewController:naviVC animated:YES completion:nil];
    
}
- (IBAction)releaseButtonAction:(UIBarButtonItem *)sender
{
    [self performSegueWithIdentifier:@"releasePush" sender:nil];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"releasePush"])
    {
        ReleaseLiveViewController *releaseVC = segue.destinationViewController;
        releaseVC.releaseButtonBlock = ^(){
            [self.tableView headerBeginRefreshing];
        };
    }
}

@end

@interface MyLiveCell ()

@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UIButton *watchButton;

@property (weak, nonatomic) IBOutlet UILabel * titleL;

@property (weak, nonatomic) IBOutlet UILabel * userL;

@property (weak, nonatomic) IBOutlet UILabel * statuL;

@property (weak, nonatomic) IBOutlet UIImageView * bgImageView;

@end

@implementation MyLiveCell


-(void)setModel:(LiveListModel *)model
{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:PlaceHolderImage];
    self.titleL.text = model.title;
    self.userL.text = [NSString stringWithFormat:@"主讲: %@",model.anchor];
    if (model.status == 2)
    {
        self.statuL.text = @"直播中";
    }else if (model.status == 1)
    {
        self.statuL.text = @"未开播";
    }else if (model.status == 4)
    {
        self.statuL.text = @"已结束";
    }else if (model.status == 3)
    {
        self.statuL.text = @"已取消";
    }
    
    [self.watchButton setTitle:model.online forState:UIControlStateNormal];
    [self.timeButton setTitle:model.live_time_str forState:UIControlStateNormal];
    
}
@end










