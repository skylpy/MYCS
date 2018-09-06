//
//  LiveViewController.m
//  MYCS
//
//  Created by GuiHua on 16/6/17.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "LiveViewController.h"
#import "UIAlertView+Block.h"
#import "ShowVerificationCodeView.h"
#import "LanscapeNaviController.h"
#import "WatchLiveViewController.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"
#import "UITableView+UITableView_Util.h"


static NSString *const reuseID = @"LiveCell";

@interface LiveViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) int page;

@end

@implementation LiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView addHeaderWithCallback:^{
        [self.tableView removeNoDataTipsView];
        [self reloadNewsData];
    }];
    [self.tableView addFooterWithCallback:^{
        [self.tableView removeNoDataTipsView];
        [self reloadMoreData];
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadNewsData) name:ChangeLiveStatus object:nil];
}

-(void)setLiveType:(LiveType)liveType
{
    _liveType = liveType;
    self.dataArr = [NSMutableArray array];
    [self.tableView headerBeginRefreshing];
    
}

-(void)reloadNewsData
{
    self.page = 1;
    [LiveListModel requestListDataWithStatus:[NSString stringWithFormat:@"%d",self.liveType] Action:@"list" Sort:@"client" Page:self.page PageSize:15 Success:^(NSArray *list) {
        
        [self.dataArr removeAllObjects];
        [self.dataArr addObjectsFromArray:list];
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
-(void)reloadMoreData
{
    self.page += 1;
    [LiveListModel requestListDataWithStatus:[NSString stringWithFormat:@"%d",self.liveType] Action:@"list" Sort:@"client" Page:self.page PageSize:15 Success:^(NSArray *list) {
        
        [self.dataArr addObjectsFromArray:list];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        
    } Failure:^(NSError *error) {
        [self showError:error];
        [self.tableView footerEndRefreshing];
    }];
}
#pragma mark - TableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArr.count;
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
    //
    LiveCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    cell.liveType = self.liveType;
    LiveListModel *model = self.dataArr[indexPath.section];
    cell.model = model;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LiveListModel *detail = self.dataArr[indexPath.section];
    
    if (detail.ext_permission == 2 && ![AppManager hasLogin])
    {
        [[[UIAlertView alloc] initWithTitle:@"提示" message:@"当前直播需要登录才能观看，\n您是否要登录？"cancelButtonTitle:@"取消" otherButtonTitle:@"确定"] showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            
            if (buttonIndex == 1)
            {
                [AppManager checkLogin];
            }
            
        }];
    }else if (detail.ext_permission == 3)
    {
        [ShowVerificationCodeView showInView:[UIApplication sharedApplication].keyWindow actionBlock:^(ShowVerificationCodeView *view, NSString *idStr) {
            
            [LiveListModel checkCheckWordWithRoomId:detail.pk checkWord:idStr action:@"check" Success:^(SCBModel *model) {
                
                [view removeFromSuperview];
                [self presentViewController:detail.pk and:detail];
                
            } Failure:^(NSError *error) {
                
                [self showError:error];
                [view showAction];
            }];
        }];
    }else
    {
        [self presentViewController:detail.pk and:detail];
    }
    
}
-(void)presentViewController:(NSString *)roomID and:(LiveListModel *)model
{
    WatchLiveViewController *watchVC = [WatchLiveViewController new];
    LanscapeNaviController *naviVC = [[LanscapeNaviController alloc] initWithRootViewController:watchVC];
    if (self.liveType == EndLive)
    {
        watchVC.liveEnd = YES;
    }
    
    watchVC.roomId = roomID;
    watchVC.liveType = self.liveType;
    watchVC.listModel = model;
    [self presentViewController:naviVC animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

@interface LiveCell ()

@property (weak, nonatomic) IBOutlet UIButton *timeButton;

@property (weak, nonatomic) IBOutlet UIButton *watchButton;

@property (weak, nonatomic) IBOutlet UILabel * titleL;

@property (weak, nonatomic) IBOutlet UILabel * userL;

@property (weak, nonatomic) IBOutlet UILabel * statuL;

@property (weak, nonatomic) IBOutlet UIImageView * bgImageView;

@property (weak, nonatomic) IBOutlet UIButton *statuButton;

@end

@implementation LiveCell


-(void)setLiveType:(LiveType)liveType
{
    _liveType = liveType;
}
-(void)setModel:(LiveListModel *)model
{
    _model = model;
    [self.bgImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:PlaceHolderImage];
    self.titleL.text = model.title;
    self.userL.text = [NSString stringWithFormat:@"主讲: %@",model.anchor];
    if (self.liveType == OnLive)
    {
        self.statuL.text = @"直播中";
    }else if (self.liveType == AfterLive)
    {
        self.statuL.text = @"未开播";
    }else if (self.liveType == EndLive)
    {
        self.statuL.text = @"已结束";
    }
    
    if (model.ext_permission == 1)
    {
        self.statuButton.hidden = YES;
    }else if (model.ext_permission == 2)
    {
        [self.statuButton setImage:[UIImage imageNamed:@"live_register"] forState:UIControlStateNormal];
        self.statuButton.hidden = NO;
        
    }else if (model.ext_permission == 3)
    {
         [self.statuButton setImage:[UIImage imageNamed:@"live_verification-code"] forState:UIControlStateNormal];
        self.statuButton.hidden = NO;
    }else
    {
        self.statuButton.hidden = YES;
    }
    
    [self.watchButton setTitle:model.online forState:UIControlStateNormal];
    [self.timeButton setTitle:model.live_time_str forState:UIControlStateNormal];
    
}
@end










