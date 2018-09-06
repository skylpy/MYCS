//
//  FeatureViewController.m
//  MYCS
//
//  Created by GuiHua on 16/7/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "FeatureViewController.h"
#import "HealthHomeCell.h"
#import "ZHCycleView.h"
#import "HealthDetailController.h"
#import "DoctorsHealthList.h"
#import "MJRefresh.h"
#import "UITableView+UITableView_Util.h"

@interface FeatureViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *menuView;

///最新表格
@property (weak, nonatomic) IBOutlet UITableView *newsTableView;
///热门表格
@property (weak, nonatomic) IBOutlet UITableView *hotTableView;
///顶部按钮数组
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnArrs;
///绿色View的x距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greenViewLeading;
///选中按钮
@property (nonatomic, strong) UIButton *selectBtn;
//最新轮播图
@property (nonatomic, strong) ZHCycleView *newsLoopScrollView;
//热门轮播图
@property (nonatomic, strong) ZHCycleView *hotLoopScrollView;
///最新数据数组
@property (nonatomic ,strong) NSMutableArray *newsDataArr;
///热门数据数组
@property (nonatomic ,strong) NSMutableArray *hotDataArr;
//轮播图数据数组
@property (nonatomic ,strong) NSMutableArray *bannarArr;
//轮播图图片数组
@property (nonatomic ,strong) NSMutableArray *bannarImageUrlArr;
///最新列表页数
@property (nonatomic ,assign) int newsPage;
///热门列表页数
@property (nonatomic ,assign) int hotPage;
///1为最新，2为热门
@property (nonatomic ,copy) NSString *itemType;
///专访视频的类型ID
@property (nonatomic ,copy) NSString *diseaseCategoryId;

@end

@implementation FeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemType = @"1";
    self.diseaseCategoryId = @"-1";
    
    self.hotTableView.hidden = YES;
    self.newsTableView.hidden = NO;
    
    self.hotDataArr = [NSMutableArray array];
    self.newsDataArr = [NSMutableArray array];
    self.bannarArr = [NSMutableArray array];
    self.bannarImageUrlArr = [NSMutableArray array];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.newsTableView addHeaderWithCallback:^{
        [self loadNewData];
    }];
    [self.newsTableView addFooterWithCallback:^{
        [self loadMoreData];
    }];
    
    [self.hotTableView addHeaderWithCallback:^{
        [self loadNewData];
    }];
    [self.hotTableView addFooterWithCallback:^{
        [self loadMoreData];
    }];
    
    self.selectBtn = [self.btnArrs firstObject];
    
    [self getBannarData];
}
#pragma mark - 开始加载数据
-(void)loadData
{
    self.selectBtn = [self.btnArrs firstObject];
    
    if (self.itemType.intValue == 1)
    {
        if (self.newsDataArr.count == 0) [self.newsTableView headerBeginRefreshing];
    }
    else
    {
        if (self.hotDataArr.count == 0) [self.hotTableView headerBeginRefreshing];
    }
    
}
#pragma mark - 加载轮播图数据
-(void)getBannarData
{
    
    [DoctorsHealthList getBannarWithCategory:@"2" Success:^(NSArray *lists) {
    
        [self.bannarImageUrlArr removeAllObjects];
        [self.bannarArr removeAllObjects];
        [self.bannarArr addObjectsFromArray:lists];
        for (DoctorsHealthBannar *model in lists) {
            
            [self.bannarImageUrlArr addObject:model.img_url];
        }
        
    } failure:^(NSError *error) {
        
        [self showError:error];
    }];
}
#pragma mark - 设置最新表格轮播图
-(void)addNewsHeaderViewWith:(NSArray *)list
{
    if(list.count == 0)
    {
        return;
    }

    _newsLoopScrollView = [ZHCycleView cycleViewWithFrame:CGRectMake(0, 0, ScreenW, 0.56*ScreenW) imageUrlGroups:list placeHolderImage:PlaceHolderImage selectAction:^(NSInteger index) {
        
        if (self.bannarImageUrlArr.count == 0)return;
        
        [self pushDetailWith:index];
        
    }];
    
    _newsLoopScrollView.currentPageTintColor = HEXRGB(0x47c1a8);
    _newsLoopScrollView.pageTintColor        = HEXRGB(0xffffff);
    
    self.newsTableView.tableHeaderView = _newsLoopScrollView;
}
#pragma mark - 设置热门表格轮播图
-(void)addHotHeaderViewWith:(NSArray *)list
{
    if(list.count == 0)
    {
        return;
    }

    _hotLoopScrollView = [ZHCycleView cycleViewWithFrame:CGRectMake(0, 0, ScreenW, 0.56*ScreenW) imageUrlGroups:list placeHolderImage:PlaceHolderImage selectAction:^(NSInteger index) {
        
        if (self.bannarImageUrlArr.count == 0)return;
        
        [self pushDetailWith:index];
        
    }];
    
    _hotLoopScrollView.currentPageTintColor = HEXRGB(0x47c1a8);
    _hotLoopScrollView.pageTintColor        = HEXRGB(0xffffff);
    
    self.hotTableView.tableHeaderView = _hotLoopScrollView;
}
-(void)pushDetailWith:(NSInteger)index
{
    
    DoctorsHealthBannar *model = self.bannarArr[index];
    
    HealthDetailController * HealthDetailVC = [[UIStoryboard storyboardWithName:@"DoctorsHealth" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthDetailController"];
    
    HealthDetailVC.detailId = model.orderId;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:HealthDetailVC animated:YES];
}
#pragma mark - 最新与热门按钮Action
- (IBAction)buttonAction:(UIButton *)sender
{
    self.selectBtn.selected = NO;
    self.selectBtn = sender;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.selectBtn.selected = YES;
        
        [self.view layoutIfNeeded];
        
        self.greenViewLeading.constant = self.selectBtn.x;
        
        
    } completion:^(BOOL finished) {
        
        if (sender.tag == 0)
        {
            self.itemType = @"1";
            self.hotTableView.hidden = YES;
            self.newsTableView.hidden = NO;
            if (self.bannarArr.count == 0) [self getBannarData];
            [self.newsTableView headerBeginRefreshing];
//            if (self.newsDataArr.count == 0) [self.newsTableView headerBeginRefreshing];
        }
        else if (sender.tag == 1)
        {
            self.itemType = @"2";
            self.hotTableView.hidden = NO;
            self.newsTableView.hidden = YES;
            if (self.bannarArr.count == 0) [self getBannarData];
            [self.hotTableView headerBeginRefreshing];
        }
        
    }];
    
    
}
#pragma mark - TableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.itemType.intValue == 1)
    {
        return self.newsDataArr.count;
        
    }else
    {
        return self.hotDataArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"HealthHomeCell";
    
    UINib * nib = [UINib nibWithNibName:@"HealthHomeCell"
                                 bundle: [NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:cellId];
    
    HealthHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    DoctorsHealthList *model;
    
    if (self.itemType.intValue == 1)
    {
        model = self.newsDataArr[indexPath.row];
        
    }else
    {
        model = self.hotDataArr[indexPath.row];
    }
    
    [cell setTypeLHide];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DoctorsHealthList *model;
    
    if (self.itemType.intValue == 1)
    {
        model = self.newsDataArr[indexPath.row];
        
    }else
    {
        model = self.hotDataArr[indexPath.row];
    }
    
    HealthDetailController * HealthDetailVC = [[UIStoryboard storyboardWithName:@"DoctorsHealth" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthDetailController"];
    
    HealthDetailVC.buttonType = 0;
    HealthDetailVC.detailId = model.des_id;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:HealthDetailVC animated:YES];;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == self.newsTableView)
    {
        if (self.newsDataArr.count == 0 || self.bannarImageUrlArr.count == 0)
        {
            return 0;
        }
        
    }else
    {
        if (self.hotDataArr.count == 0 || self.bannarImageUrlArr.count == 0)
        {
            return 0;
        }
    }
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 0.56*ScreenW;
}
// 去掉UItableview headerview黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat sectionHeaderHeight = 5;
    if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }
    else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
        scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
    }
}
#pragma mark - 加载最新数据
-(void)loadNewData
{
    [self.newsTableView removeNoDataTipsView];
    [self.hotTableView removeNoDataTipsView];

    self.hotPage = 1;
    self.newsPage = 1;
    
    [DoctorsHealthList getListsWithCategory:@"2" itemType:self.itemType diseaseCategoryId:self.diseaseCategoryId page:1 Success:^(NSArray *lists) {
        
        if (self.itemType.intValue == 1)
        {
            [self.newsDataArr removeAllObjects];
            [self.newsDataArr addObjectsFromArray:lists];
            [self.newsTableView headerEndRefreshing];
            [self addNewsHeaderViewWith:self.bannarImageUrlArr];
            [self.newsTableView reloadData];
            
            if (lists.count == 0)
            {
                [self.newsTableView setNoDataTipsView:0];
            }
            
        }else
        {
            [self.hotDataArr removeAllObjects];
            [self.hotDataArr addObjectsFromArray:lists];
            [self.hotTableView headerEndRefreshing];
            [self addHotHeaderViewWith:self.bannarImageUrlArr];
            [self.hotTableView reloadData];
            
            if (lists.count == 0)
            {
                [self.hotTableView setNoDataTipsView:0];
            }
            
        }
        
    } failure:^(NSError *error) {
        
        if (self.itemType.intValue == 1)
        {
            [self.newsTableView headerEndRefreshing];
            
        }else
        {
            [self.hotTableView headerEndRefreshing];
        }
        
        [self showError:error];
        
    }];
}
#pragma mark - 加载更多数据
-(void)loadMoreData
{
    
    self.hotPage += 1;
    self.newsPage += 1;
    
    int page;
    
    if (self.itemType.intValue == 1)
    {
        page = self.newsPage;
    }else
    {
        page = self.hotPage;
    }
    
    [DoctorsHealthList getListsWithCategory:@"2" itemType:self.itemType diseaseCategoryId:self.diseaseCategoryId page:page Success:^(NSArray *lists) {
        
        if (self.itemType.intValue == 1)
        {
            [self.newsDataArr addObjectsFromArray:lists];
            [self.newsTableView footerEndRefreshing];
            [self.newsTableView reloadData];
            
        }else
        {
            [self.hotDataArr addObjectsFromArray:lists];
            [self.hotTableView footerEndRefreshing];
            [self.hotTableView reloadData];
        }
        
        
    } failure:^(NSError *error) {
        
        if (self.itemType.intValue == 1)
        {
            [self.newsTableView footerEndRefreshing];
            
        }else
        {
            [self.hotTableView footerEndRefreshing];
        }
        
        [self showError:error];
        
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
