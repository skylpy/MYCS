//
//  HomeViewController.m
//  MYCS
//
//  Created by GuiHua on 16/7/20.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "HomeViewController.h"
#import "DoctorsPageViewController.h"
#import "OfficeHomeViewController.h"
#import "NewsInformationViewController.h"
#import "WebViewDetailController.h"
#import "HomeMedicineController.h"
#import "VCSDetailViewController.h"
#import "DoctorListsViewController.h"
#import "ActivityHomeController.h"
#import "ClassDetailViewController.h"
#import "HealthHomeViewController.h"
#import "ZHCycleView.h"
#import "UICollectionView+NoDataTips.h"
#import "MJRefresh.h"
#import "VideoShopListModel.h"
#import "ProfileView.h"
#import "AllLiveListViewController.h"

@interface HomeViewController ()<UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) HomeCollectionReusableView *collectionReusableView;

@property (nonatomic,strong) NSMutableArray * dataArrs;

@property (nonatomic ,strong) NSMutableArray *focusArr;

@property (nonatomic, assign) int page;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArrs = [NSMutableArray array];
    self.focusArr = [NSMutableArray array];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    CGFloat with = (ScreenW - 22) * 0.5;
    self.flowLayout.itemSize            = CGSizeMake(with, with * 0.5625 + 70);
    self.flowLayout.headerReferenceSize = CGSizeMake(ScreenW, 0.56*ScreenW + 120);
    
    //网络状况
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityStatusChange:) name:@"kReachabilityStatusChange" object:nil];
   
    [self.collectionView addHeaderWithCallback:^{
        [self loaNewData];
    }];

    [self.collectionView addFooterWithCallback:^{
        [self loaMoreData];
    }];
    
    [self showLoadingView:0.56*ScreenW + 120];
    
    AFNetworkReachabilityStatus status = [AppManager sharedManager].status;
    BOOL hasNetWork = (status!=AFNetworkReachabilityStatusUnknown&&status!=AFNetworkReachabilityStatusNotReachable);
    //有网情况下直接从后台请求
    if (hasNetWork)
    {
        [self.collectionView headerBeginRefreshing];
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if ([AppManager sharedManager].isKickOut)
    {
        [self.collectionView headerEndRefreshing];
        
        if (self.dataArrs.count == 0)
        {
            [self loaNewData];
        }else
        {
            [self.collectionView reloadData];
        }
        
        [AppManager sharedManager].isKickOut = NO;
    }
    
    if (self.collectionReusableView)
    {
        
        [self.collectionReusableView.LoopScrollView destoryTimer];
        [self.collectionReusableView.LoopScrollView setupTimer];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.collectionReusableView)
    {
        [self.collectionReusableView.LoopScrollView destoryTimer];
    }
}
- (void)reachabilityStatusChange:(NSNotification *)noti
{
    [self dismissLoadingView];
    if (self.dataArrs.count == 0)
    {
        //只启动的时候执行一次
        AFNetworkReachabilityStatus status = [AppManager sharedManager].status;
        BOOL hasNetWork = (status!=AFNetworkReachabilityStatusUnknown&&status!=AFNetworkReachabilityStatusNotReachable);
        //有网情况下直接从后台请求
        if (hasNetWork)
        {
            [self showLoadingView:0.56*ScreenW + 120];
            [self.collectionView headerEndRefreshing];
            [self.collectionView headerBeginRefreshing];
            [[NSNotificationCenter defaultCenter]removeObserver:self name:@"kReachabilityStatusChange" object:nil];
        }
    }
}

-(void)loaNewData
{
    self.page = 1;
    
//    [self showLoadingView:0.56*ScreenW + 120];
    
    [VideoShopListModel requestVideoShopListWithAction:@"appindex" page:self.page pageSize:10 fromCache:YES success:^(VideoShopListModel *model) {
        
        [self.dataArrs removeAllObjects];
        [self.focusArr removeAllObjects];
        [self.dataArrs addObjectsFromArray:model.list];
        [self.focusArr addObjectsFromArray:model.focus];
        [self.collectionView reloadData];
        [self.collectionView headerEndRefreshing];
        [self.collectionView removeNoDataTipsView];
        
        if (model.list == 0)
        {
            [self.collectionView setNoDataTipsView:0.56*ScreenW + 120];
        }
        
        [self dismissLoadingView];
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingView];
        [self.collectionView headerEndRefreshing];
        [self showError:error];
        
    }];
    
}
-(void)loaMoreData
{
    self.page += 1;
    
//    [self showLoadingView:0.56*ScreenW + 120];
    
    [VideoShopListModel requestVideoShopListWithAction:@"appindex" page:self.page pageSize:10 fromCache:YES success:^(VideoShopListModel *model) {
        
        [self.dataArrs addObjectsFromArray:model.list];
        [self.collectionView reloadData];
        [self.collectionView footerEndRefreshing];
       
//        [self dismissLoadingView];
        
    } failure:^(NSError *error) {
        
//        [self dismissLoadingView];
        [self.collectionView footerEndRefreshing];
        [self showError:error];
        
    }];
    
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArrs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *idStr        = @"HomeMedicineCell";
    HomeMedicineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idStr forIndexPath:indexPath];
    
    ShopListItemModel *model = self.dataArrs[indexPath.row];
    cell.itemModel           = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ShopListItemModel *model = self.dataArrs[indexPath.row];
    [self pushVCSDetailControllerWith:model];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWith = (ScreenW - 22) / 2;
    return CGSizeMake(itemWith, itemWith * 0.5625 + 70);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader){
        
        self.collectionReusableView =  [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"homeCollectionReusableView"forIndexPath:indexPath];
        
        __weak typeof(self)weakSelf = self;
        self.collectionReusableView.focus = self.focusArr;
        
        self.collectionReusableView.tapButtonViewblock = ^(NSInteger index)
        {
        
            [weakSelf buttonCallBackWithIndex:index];
        };
        
        return self.collectionReusableView;
        
    }
    
    return nil;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(7, 7, 7, 7);
}
- (void)buttonCallBackWithIndex:(NSInteger)index {
    
    
    if (index == 0)
    {
        [self pushVideoList];
    }
    else if (index == 1)
    {
        [self pushDoctorList];
    }
    else if (index == 2)
    {
        [self pushActivityList];
        
    }else if (index == 3)
    {
        [self pushLive];
        
    }else if (index == 4)
    {
        [self pushInterViewList];
        
    } else if (index == 5)
    {
        [self pushCollegeList];
        
    }else if (index == 6)
    {
        [self pushNewsList];
    }
    
}
-(void)pushLive
{
    AllLiveListViewController *allLive = [[UIStoryboard storyboardWithName:@"Live" bundle:nil] instantiateViewControllerWithIdentifier:@"AllLiveListViewController"];
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:allLive animated:YES];
}
//根据模型跳转到视频详情
- (void)pushVCSDetailControllerWith:(ShopListItemModel *)itemModel {
    
    
    if (![itemModel.type isEqualToString:@"coursePack"])
    {
        //创建视频详情的控制器
        UIStoryboard *vcsSB            = [UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil];
        VCSDetailViewController *vcsVC = [vcsSB instantiateViewControllerWithIdentifier:@"VCSDetailViewController"];
        
        vcsVC.videoId = itemModel.modelID;
        
        if ([itemModel.type isEqualToString:@"video"])
        {
            vcsVC.type = VCSDetailTypeVideo;
        }
        else if ([itemModel.type isEqualToString:@"course"])
        {
            vcsVC.type = VCSDetailTypeCourse;
        }
        else if ([itemModel.type isEqualToString:@"sop"])
        {
            vcsVC.type = VCSDetailTypeSOP;
        }
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vcsVC animated:YES];
    }
    else
    {
        [self pushCoursePackDetailWithURL:itemModel.modelID];
        
    }
    
    
}
-(void)pushCoursePackDetailWithURL:(NSString *)url
{
    NSArray *infoArr = [url componentsSeparatedByString:@"id="];
    
    ClassDetailViewController * classVC = [[ClassDetailViewController alloc] init];
    
    classVC.shareURL = url;
    
    classVC.coursePackId = infoArr[1];
    
    NSString *systemVersion;
    if (iS_IOS7)
    {
        systemVersion = @"ios7";
    }
    else
    {
        systemVersion = @"ios8Later";
    }
    
    NSString *urlStr;
    
    if ([AppManager hasLogin])
    {
        User *user = [AppManager sharedManager].user;
        urlStr = [NSString stringWithFormat:@"&userId=%@&userType=%@&staffAdmin=%@&device=%@", user.uid, @(user.userType), user.isAdmin,systemVersion];
    }else
    {
        urlStr = [NSString stringWithFormat:@"&userId=&userType=&staffAdmin=&device=%@",systemVersion];
    }
    
    urlStr = [url stringByAppendingString:urlStr];
    
    [classVC loadRequestWithURL:urlStr showProgressView:YES];
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:classVC animated:YES];
}


- (void)pushInterViewList
{
    HealthHomeViewController *hv = [[UIStoryboard storyboardWithName:@"DoctorsHealth" bundle:nil] instantiateInitialViewController];
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:hv animated:YES];
}

- (void)pushCollegeList
{
    NSString *systemVersion;
    if (iS_IOS7)
    {
        systemVersion = @"ios7";
    }
    else
    {
        systemVersion = @"ios8Later";
    }
    
    OfficeHomeViewController *officeVC = [[UIStoryboard storyboardWithName:@"Office" bundle:nil] instantiateViewControllerWithIdentifier:@"OfficeHomeViewController"];
    officeVC.title                 = @"学院";
    officeVC.url                   = [NSString stringWithFormat:@"http://mycsapi.mycs.cn/appindex.php?action=college&device=%@",systemVersion];
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:officeVC animated:YES];
}


- (void)pushDoctorList {
    DoctorListsViewController *doctorListVC = [[UIStoryboard storyboardWithName:@"doctor" bundle:nil] instantiateViewControllerWithIdentifier:@"DoctorListsViewController"];
    doctorListVC.title                      = @"名医传世";
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:doctorListVC animated:YES];
    
}

- (void)pushActivityList {
    ActivityHomeController *activityVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ActivityHomeController"];
    activityVC.title                   = @"活动列表";
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:activityVC animated:YES];
}

- (void)pushNewsList {
    NewsInformationViewController *newsListVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"NewsInformationViewController"];
    newsListVC.title                          = @"新闻资讯";
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:newsListVC animated:YES];
}

- (void)pushVideoList {
    HomeMedicineController *videoListVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeMedicineController"];
    videoListVC.title                   = @"课程";
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:videoListVC animated:YES];
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

@interface HomeCollectionReusableView()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *buttonArrs;


@end

@implementation HomeCollectionReusableView


-(void)awakeFromNib
{
    [super awakeFromNib];
    self.imageUrlArrs = [NSMutableArray array];
    self.scrollView.delegate = self;
    
}

-(void)setFocus:(NSArray *)focus
{
    _focus = focus;
    
    [self.imageUrlArrs removeAllObjects];
    
    for (Focus * model in focus)
    {
        [self.imageUrlArrs addObject:model.imageSrc];
    }
    
    if (focus.count == 0)
    {
        NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"hplaceImage" ofType:@"png"];
        [self.imageUrlArrs addObject:imagePath];
    }
    
    [self addLoopScrollView:self.imageUrlArrs];
    
}

#pragma mark - 设置最新表格的轮播图
-(void)addLoopScrollView:(NSMutableArray *)list
{
    [self.LoopScrollView destoryTimer];
    [self.LoopScrollView removeFromSuperview];
    
    self.LoopScrollView = [ZHCycleView cycleViewWithFrame:CGRectMake(0, 0, ScreenW, 0.56 *ScreenW) imageUrlGroups:list placeHolderImage:PlaceHolderImage selectAction:^(NSInteger index) {
        
        if (self.focus.count == 0)
        {
            return;
        }
        [UMAnalyticsHelper eventLogClick:@"event_fst_page_banner"];
        Focus * model = self.focus[index];
        
        [ProfileView  profileWtihParam:model.param];
        
    }];
    
    self.LoopScrollView.currentPageTintColor = HEXRGB(0x47c1a8);
    self.LoopScrollView.pageTintColor        = HEXRGB(0xffffff);
    [self.headView addSubview: self.LoopScrollView];
}


- (IBAction)buttonAction:(UIButton *)sender
{
    if (self.tapButtonViewblock)
    {
        self.tapButtonViewblock(sender.tag);
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.scrollView.contentSize = CGSizeMake(ScreenW/4.5*7, 110);
}

@end



















