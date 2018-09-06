
//
//  CollectionPlaceController.m
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "CollectionPlaceController.h"
#import "MJRefresh.h"

#import "DoctorCell.h"
#import "HospitalCell.h"
#import "VideoCell.h"

#import "CollectionModel.h"

#import "OfficePagesViewController.h"
#import "DoctorsPageViewController.h"
#import "VCSDetailViewController.h"
#import "ClassDetailViewController.h"
#import "HealthDetailController.h"
#import "UICollectionView+NoDataTips.h"
#import "UITableView+UITableView_Util.h"

@interface CollectionPlaceController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *menuView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuBtns;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greenViewLeftConstraint;

@property (weak, nonatomic) IBOutlet UICollectionView *VideoCollectionView;

@property (weak, nonatomic) IBOutlet UITableView *DoctorTableView;

@property (weak, nonatomic) IBOutlet UITableView *HospitalTableView;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIButton *selectAllbutton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottom;

@property (nonatomic,strong) UIButton *selectBtn;

@property (nonatomic,strong) NSMutableArray * VideoDataSoure;

@property (nonatomic,strong) NSMutableArray * DoctorDataSoure;

@property (nonatomic,strong) NSMutableArray * HospitalDataSoure;

@property (nonatomic,assign) int selectIndex;

@property (nonatomic,strong) NSMutableArray *selectArray;

@property (nonatomic,assign) int selectCount;

@property (nonatomic,assign)BOOL isEdict;

@property (nonatomic,strong)UIBarButtonItem * edictButton;


@end

@implementation CollectionPlaceController
- (void)addConstraints
{
    self.menuView.translatesAutoresizingMaskIntoConstraints = NO;
    self.automaticallyAdjustsScrollViewInsets                     = NO;
    
    id menuView = self.menuView;
    
    NSString *hVFL = @"H:|-(0)-[menuView]-(0)-|";
    NSString *vVFL = @"V:|-(64)-[menuView(45)]";
    
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(menuView)];
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(menuView)];
    
    
    [self.view addConstraints:hConsts];
    [self.view addConstraints:vConsts];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (iS_IOS10)
    {
        [self addConstraints];
    }
    
    if (self.selectIndex == 0 && self.VideoDataSoure.count != 0)
    {
        
        [self.VideoCollectionView headerBeginRefreshing];
        
    }else if (self.selectIndex == 1)
    {
        
        [self.DoctorTableView headerBeginRefreshing];
        
    }else if (self.selectIndex == 2)
    {
        
        [self.HospitalTableView headerBeginRefreshing];
    }
    
    self.navigationController.navigationBarHidden = NO;
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = NO;
    self.scrollView.scrollEnabled = YES;
    self.scrollView.contentSize = CGSizeMake(ScreenW * 3, self.scrollView.height);
}

#pragma mark -- 初始UI
-(void)buildUI
{
    self.scrollView.delegate = self;
    [self.view layoutIfNeeded];
    
    self.VideoDataSoure = [NSMutableArray array];
    self.DoctorDataSoure = [NSMutableArray array];
    self.HospitalDataSoure = [NSMutableArray array];
    
    self.selectArray = [NSMutableArray array];
    
    self.DoctorTableView.rowHeight = 94;
    self.HospitalTableView.rowHeight = 94;
    
    self.DoctorTableView.tableFooterView = [[UIView alloc] init];
    self.HospitalTableView.tableFooterView = [[UIView alloc] init];
    
    [self.DoctorTableView addHeaderWithCallback:^{
        [self loadDoctorNewData];
    }];
    [self.HospitalTableView addHeaderWithCallback:^{
        [self loadHospitalNewData];
    }];
    [self.VideoCollectionView addHeaderWithCallback:^{
        [self loadVideoNewData];
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"收藏夹";
    
    [self buildUI];
    
    
    self.edictButton = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(edictButtonAction)];
    self.navigationItem.rightBarButtonItem = self.edictButton;
    
    
    UIButton *btn = [self.menuBtns firstObject];
    [self menuBtns:btn];
    
}

#pragma mark -- edict Action
-(void)edictButtonAction{
    
    self.selectCount = 0;
    [self.selectArray removeAllObjects];
    self.isEdict = !self.isEdict;
    
    self.selectAllbutton.selected = NO;
    [self.selectAllbutton setTitle:@"全选" forState:UIControlStateNormal];
    
    if (self.isEdict)
    {
        self.viewBottom.constant = 0;
        [self.edictButton setTitle:@"取消"];
        
    }else
    {
        self.viewBottom.constant = -50;
        [self.edictButton setTitle:@"编辑"];
        self.selectCount = 0;
        
        [self VideoAllUnSelect];
        [self DoctorAllUnSelect];
        [self HospitalAllUnSelect];
    }
    if (self.selectIndex == 0)
    {
        [self.VideoCollectionView reloadData];
        
    }else if (self.selectIndex == 1)
    {
        [self.DoctorTableView reloadData];
        
    }else if (self.selectIndex == 2)
    {
        [self.HospitalTableView reloadData];
    }
    [self showDeleteButtonTitle];
    
}
-(void)VideoAllSelect
{
    for (CollectionVideo * video in self.VideoDataSoure)
    {
        video.isSelect = [NSNumber numberWithInt:1];
    }
}
-(void)VideoAllUnSelect
{
    for (CollectionVideo * video in self.VideoDataSoure)
    {
        video.isSelect = [NSNumber numberWithInt:0];
    }
}
-(void)DoctorAllSelect
{
    for (CollectionDoctor * video in self.DoctorDataSoure)
    {
        video.isSelect = [NSNumber numberWithInt:1];
    }
}
-(void)DoctorAllUnSelect
{
    for (CollectionDoctor * video in self.DoctorDataSoure)
    {
        video.isSelect = [NSNumber numberWithInt:0];
    }
}
-(void)HospitalAllSelect
{
    for (CollectionHospital * video in self.HospitalDataSoure)
    {
        video.isSelect = [NSNumber numberWithInt:1];
    }
}
-(void)HospitalAllUnSelect
{
    for (CollectionHospital * video in self.HospitalDataSoure)
    {
        video.isSelect = [NSNumber numberWithInt:0];
    }
}
#pragma mark -- 选择所有 Action
- (IBAction)selectAllAction:(UIButton *)sender
{
    self.selectAllbutton.selected = !sender.selected;
    if (!self.selectAllbutton.selected)
    {
        [self.selectAllbutton setTitle:@"全选" forState:UIControlStateNormal];
        
        [self VideoAllUnSelect];
        [self DoctorAllUnSelect];
        [self HospitalAllUnSelect];
        
        
        if (self.selectIndex == 0)
        {
            [self.VideoCollectionView reloadData];
        }else if (self.selectIndex == 1)
        {
            [self.DoctorTableView reloadData];
        }
        else if (self.selectIndex)
        {
            [self.HospitalTableView reloadData];
        }
        
        self.selectCount = 0;
        [self.selectArray removeAllObjects];
        
    }else
    {
        [self.selectAllbutton setTitle:@"取消全选" forState:UIControlStateNormal];
        
        if (self.selectIndex == 0)
        {
            [self VideoAllSelect];
            [self DoctorAllUnSelect];
            [self HospitalAllUnSelect];
            
            [self.VideoCollectionView reloadData];
            
            [self.selectArray removeAllObjects];
            
            [self.selectArray addObjectsFromArray:self.VideoDataSoure];
            
            self.selectCount = (int)self.VideoDataSoure.count;
            
        }else if (self.selectIndex == 1)
        {
            [self DoctorAllSelect];
            [self VideoAllUnSelect];
            [self HospitalAllUnSelect];
            
            [self.DoctorTableView reloadData];
            
            [self.selectArray removeAllObjects];
            
            [self.selectArray addObjectsFromArray:self.DoctorDataSoure];
            
            self.selectCount = (int)self.DoctorDataSoure.count;
            
        }else if (self.selectIndex == 2)
        {
            [self HospitalAllSelect];
            [self DoctorAllUnSelect];
            [self VideoAllUnSelect];
            
            [self.HospitalTableView reloadData];
            
            [self.selectArray removeAllObjects];
            
            [self.selectArray addObjectsFromArray:self.HospitalDataSoure];
            
            self.selectCount = (int)self.HospitalDataSoure.count;
        }
    }
    
    [self showDeleteButtonTitle];
}
#pragma mark -- delete Action
- (IBAction)deleteAction:(UIButton *)sender
{
    
    NSMutableArray * IdArray = [NSMutableArray array];
    [IdArray removeAllObjects];
    
    if (self.selectIndex == 0)
    {
        for (CollectionVideo * video in self.selectArray)
        {
            [IdArray addObject:video.id];
        }
        
        [self showLoadingHUD];
        
        NSString *idStr = [IdArray componentsJoinedByString:@","];
        
        [self deleteWithAction:@"video" AndIds:idStr];
        
    }else if (self.selectIndex == 1)
    {
        for (CollectionDoctor * doctor in self.selectArray)
        {
            [IdArray addObject:doctor.id];
        }
        
        [self showLoadingHUD];
        
        NSString *idStr = [IdArray componentsJoinedByString:@","];
        
        [self deleteWithAction:@"doctor" AndIds:idStr];
        
    }else if (self.selectIndex == 2)
    {
        for (CollectionHospital * hospital in self.selectArray)
        {
            [IdArray addObject:hospital.id];
            
        }
        [self showLoadingHUD];
        
        NSString *idStr = [IdArray componentsJoinedByString:@","];
        
        [self deleteWithAction:@"hospital" AndIds:idStr];
    }
}
#pragma mark -- menus Action
- (IBAction)menuBtns:(UIButton *)sender {
    
    self.selectBtn.selected = NO;
    self.selectBtn = sender;
    NSUInteger tag = sender.tag;
    self.selectIndex = (int)tag;
    
    UILabel * la = [self.view viewWithTag:7878];
    [la removeFromSuperview];
    self.isEdict = YES;
    [self edictButtonAction];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.selectBtn.selected = YES;
        self.greenViewLeftConstraint.constant = sender.x;
        self.scrollView.contentOffset = CGPointMake(self.view.width*tag, 0);
        
    } completion:^(BOOL finished) {
        
        if (tag == 0)
        {
            if (self.VideoDataSoure.count > 0)
            {
                return ;
            }
            [self.VideoCollectionView headerBeginRefreshing];
        }
        else if (tag == 1)
        {
            if (self.DoctorDataSoure.count > 0)
            {
                return ;
            }
            [self.DoctorTableView headerBeginRefreshing];
        }
        else if (tag == 2)
        {
            if (self.HospitalDataSoure.count > 0)
            {
                return ;
            }
            [self.HospitalTableView headerBeginRefreshing];
        }
    }];
    
}
#pragma mark - *** ScrollView Delegate ***
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([scrollView isKindOfClass:[self.DoctorTableView class]] || [scrollView isKindOfClass:[self.HospitalTableView class]] ||[scrollView isKindOfClass:[self.VideoCollectionView class]]) {
        return;
    }
    
    NSUInteger page = scrollView.contentOffset.x/ScreenW;
    UIButton *button = self.menuBtns[page];
    
    self.selectBtn.selected = NO;
    self.selectBtn = button;
    [self menuBtns:button];
    
}
#pragma mark -- tableViewDelegate and DataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.DoctorTableView)
    {
        if (self.DoctorDataSoure.count == 0)
        {
            self.isEdict = NO;
            [self.selectArray removeAllObjects];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            self.viewBottom.constant = -50;
            [self.edictButton setTitle:@"编辑"];
            self.selectCount = 0;
            
            [self VideoAllUnSelect];
            [self DoctorAllUnSelect];
            [self HospitalAllUnSelect];
            
        }else
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        
        return self.DoctorDataSoure.count;
    }
    else if (tableView == self.HospitalTableView)
    {
        if (self.HospitalDataSoure.count == 0)
        {
            self.isEdict = NO;
            [self.selectArray removeAllObjects];
            self.navigationItem.rightBarButtonItem.enabled = NO;
            self.viewBottom.constant = -50;
            [self.edictButton setTitle:@"编辑"];
            self.selectCount = 0;
            
            [self VideoAllUnSelect];
            [self DoctorAllUnSelect];
            [self HospitalAllUnSelect];
        }else
        {
            self.navigationItem.rightBarButtonItem.enabled = YES;
        }
        
        return self.HospitalDataSoure.count;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.DoctorTableView)
    {
        static NSString *DoctorCellID = @"DoctorCell";
        UINib * nib = [UINib nibWithNibName:@"DoctorCell"
                                     bundle: [NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:DoctorCellID];
        
        DoctorCell *cell = [self.DoctorTableView dequeueReusableCellWithIdentifier:DoctorCellID];
        
        CollectionDoctor * model = self.DoctorDataSoure[indexPath.row];
        
        if (model.isSelect == nil)
        {
            model.isSelect = [NSNumber numberWithInt:0];
        }
        
        cell.model = model;
        
        if (self.isEdict)
        {
            cell.selectButton.hidden = NO;
            
        }else
        {
            cell.selectButton.hidden = YES;
        }
        return cell;
    }
    else
    {
        static NSString *HospitalCellID = @"HospitalCell";
        UINib * nib = [UINib nibWithNibName:@"HospitalCell"
                                     bundle: [NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:HospitalCellID];
        
        HospitalCell *cell = [self.HospitalTableView dequeueReusableCellWithIdentifier:HospitalCellID];
        
        CollectionHospital * model = self.HospitalDataSoure[indexPath.row];
        
        if (model.isSelect == nil)
        {
            model.isSelect = [NSNumber numberWithInt:0];
        }
        
        cell.model = model;
        
        if (self.isEdict)
        {
            cell.selectButton.hidden = NO;
            
        }else
        {
            cell.selectButton.hidden = YES;
        }
        
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.DoctorTableView)
    {
        if (self.isEdict)
        {
            
            CollectionDoctor * model = self.DoctorDataSoure[indexPath.row];
            
            model.isSelect = model.isSelect.integerValue == 0?[NSNumber numberWithInt:1]:[NSNumber numberWithInt:0];
            
            self.selectCount = model.isSelect.integerValue == 0?self.selectCount - 1:self.selectCount + 1;
            
            if (model.isSelect.intValue == 1)
            {
                [self.selectArray addObject:model];
            }
            else
            {
                [self.selectArray removeObject:model];
            }
            
            
            if (self.selectArray.count == self.DoctorDataSoure.count)
            {
                self.selectAllbutton.selected = YES;
                [self.selectAllbutton setTitle:@"取消全选" forState:UIControlStateNormal];
                
            }else
            {
                self.selectAllbutton.selected = NO;
                [self.selectAllbutton setTitle:@"全选" forState:UIControlStateNormal];
            }
            
            [self showDeleteButtonTitle];
            
            [self.DoctorTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            return;
        }
        
        CollectionDoctor *model = self.DoctorDataSoure[indexPath.row];
        
        DoctorsPageViewController *doctorPageVC = [[UIStoryboard storyboardWithName:@"doctor" bundle:nil] instantiateViewControllerWithIdentifier:@"DoctorsPageViewController"];
        
        doctorPageVC.uid = model.uid;
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:doctorPageVC animated:YES];
    }
    else
    {
        if (self.isEdict)
        {
            
            CollectionHospital * model = self.HospitalDataSoure[indexPath.row];
            
            model.isSelect = model.isSelect.integerValue == 0?[NSNumber numberWithInt:1]:[NSNumber numberWithInt:0];
            
            self.selectCount = model.isSelect.integerValue == 0?self.selectCount - 1:self.selectCount + 1;
            
            if (model.isSelect.intValue == 1)
            {
                [self.selectArray addObject:model];
            }
            else
            {
                [self.selectArray removeObject:model];
            }
            
            if (self.selectArray.count == self.HospitalDataSoure.count)
            {
                self.selectAllbutton.selected = YES;
                [self.selectAllbutton setTitle:@"取消全选" forState:UIControlStateNormal];
                
            }else
            {
                self.selectAllbutton.selected = NO;
                [self.selectAllbutton setTitle:@"全选" forState:UIControlStateNormal];
            }
            
            [self showDeleteButtonTitle];
            
            [self.HospitalTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
            return;
        }
        
        CollectionHospital * model = self.HospitalDataSoure[indexPath.row];
        
        OfficePagesViewController * pVC = [[UIStoryboard storyboardWithName:@"Office" bundle:nil] instantiateViewControllerWithIdentifier:@"OfficePagesViewController"];
        
        //agroup_id参照表   //未通过企业营业执照审核的企业用户= 2;//机构用户 = 4; //通过企业营业执照审核的企业用户= 5; //医院账号 = 183; //科室账号 = 185; //实验室账号 = 187
        if (model.agroup_id.intValue == 2 || model.agroup_id.intValue == 5)
        {
            pVC.type = OfficeTypeEnterprise;
            pVC.isHospitalOrOffice = NO;
        }
        else if (model.agroup_id.intValue == 183)
        {
            pVC.type = OfficeTypeHospital;
            pVC.isHospitalOrOffice = YES;
        }
        else if(model.agroup_id.intValue == 185)
        {
            pVC.type = OfficeTypeOffice;
            pVC.isHospitalOrOffice = YES;
        }
        else if (model.agroup_id.intValue == 187)
        {
            pVC.type = OfficeTypeLaboratory;
            pVC.isHospitalOrOffice = NO;
        }
        
        pVC.uid = model.uid;
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:pVC animated:YES];
        
    }
    
}

#pragma mark - collectionView Delegate And DataSOure
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.VideoDataSoure.count == 0)
    {
        self.isEdict = NO;
        [self.selectArray removeAllObjects];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        self.viewBottom.constant = -50;
        [self.edictButton setTitle:@"编辑"];
        self.selectCount = 0;
        
        [self VideoAllUnSelect];
        [self DoctorAllUnSelect];
        [self HospitalAllUnSelect];
    }else
    {
        self.navigationItem.rightBarButtonItem.enabled = YES;
    }
    
    return self.VideoDataSoure.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * VideoCellID = @"VideoCell";
    UINib * nib = [UINib nibWithNibName:@"VideoCell"
                                 bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:VideoCellID];
    
    VideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:VideoCellID forIndexPath:indexPath];
    
    CollectionVideo * model = self.VideoDataSoure[indexPath.item];
    
    if (model.isSelect == nil)
    {
        model.isSelect = [NSNumber numberWithInt:0];
    }
    
    cell.model = model;
    
    if (self.isEdict)
    {
        cell.selectButton.hidden = NO;
        
    }else
    {
        cell.selectButton.hidden = YES;
    }
    return cell;
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CollectionVideo * model = self.VideoDataSoure[indexPath.row];
    
    if (self.isEdict)
    {
        
        model.isSelect = model.isSelect.integerValue == 0?[NSNumber numberWithInt:1]:[NSNumber numberWithInt:0];
        
        self.selectCount = model.isSelect.integerValue == 0?self.selectCount - 1:self.selectCount + 1;
        
        [self showDeleteButtonTitle];
        
        if (model.isSelect.intValue == 1)
        {
            [self.selectArray addObject:model];
        }
        else
        {
            [self.selectArray removeObject:model];
        }
        
        if (self.selectArray.count == self.VideoDataSoure.count)
        {
            self.selectAllbutton.selected = YES;
            [self.selectAllbutton setTitle:@"取消全选" forState:UIControlStateNormal];
        }else
        {
            self.selectAllbutton.selected = NO;
            [self.selectAllbutton setTitle:@"全选" forState:UIControlStateNormal];
        }
        
        [self.VideoCollectionView reloadItemsAtIndexPaths:@[indexPath]];
        
        return;
    }
    
    if ([model.type isEqualToString:@"CoursePack"])
    {
        [self pushCoursePackDetailWithURL:model.coursePackUrl];
    }
    else if ([model.type isEqualToString:@"Interview"])
    {
        HealthDetailController * HealthDetailVC = [[UIStoryboard storyboardWithName:@"DoctorsHealth" bundle:nil] instantiateViewControllerWithIdentifier:@"HealthDetailController"];
        
        HealthDetailVC.buttonType = 0;
        HealthDetailVC.detailId = model.videoId;
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:HealthDetailVC animated:YES];
    }
    else
    {
        VCSDetailViewController *vcsVC = [[UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil] instantiateViewControllerWithIdentifier:@"VCSDetailViewController"];
        
        vcsVC.videoId = model.videoId;
        
        if ([model.type isEqualToString:@"video"])
        {
            vcsVC.type = VCSDetailTypeVideo;
        }
        else if ([model.type isEqualToString:@"course"])
        {
            vcsVC.type = VCSDetailTypeCourse;
        }
        else if ([model.type isEqualToString:@"sop"])
        {
            vcsVC.type = VCSDetailTypeSOP;
        }
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vcsVC animated:YES];
    }
}
-(void)pushCoursePackDetailWithURL:(NSString *)url
{
    NSArray *infoArr = [url componentsSeparatedByString:@"id="];
    
    ClassDetailViewController * classVC = [[ClassDetailViewController alloc] init];
    
    classVC.coursePackId = infoArr[1];
    
    classVC.shareURL = url;
    
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

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 7, 10, 7);
}
#pragma mark -- UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((ScreenW - 21) / 2, 150);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - *** 收藏视频数据源 ***
- (void)loadVideoNewData{
    
    [CollectionModel getCollectionVideoDataWithUserID:[AppManager sharedManager].user.uid success:^(NSArray *list) {
        
        
        [self.VideoDataSoure removeAllObjects];
        [self.VideoCollectionView removeNoDataTipsView];
        if (list.count > 0) {
            
            [self.VideoDataSoure addObjectsFromArray:list];
            
        }
        else{
            [self.VideoCollectionView setNoDataTipsView:15];
        }

        [self.VideoCollectionView reloadData];
        
        [self.VideoCollectionView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        
        [self.VideoDataSoure removeAllObjects];
        
        [self.VideoCollectionView setNoDataTipsView:15];
        [self.VideoCollectionView reloadData];
        
        [self.VideoCollectionView headerEndRefreshing];
        
    }];
    
}

#pragma mark - *** 收藏医生数据源 ***
- (void)loadDoctorNewData{
    
    
    [CollectionModel getCollectionDoctorDataWithUserID:[AppManager sharedManager].user.uid success:^(NSArray *list) {
        
        [self.DoctorDataSoure removeAllObjects];
        [self.DoctorTableView removeNoDataTipsView];
        if (list.count > 0) {
        
            [self.DoctorDataSoure addObjectsFromArray:list];
            
        }
        else{
            [self.DoctorTableView setNoDataTipsView:15];
            
        }

        [self.DoctorTableView reloadData];
        
        [self.DoctorTableView headerEndRefreshing];
        
        
    } failure:^(NSError *error) {
        
        [self.DoctorDataSoure removeAllObjects];
        
        [self.DoctorTableView setNoDataTipsView:15];
        [self.DoctorTableView reloadData];
        
        [self.DoctorTableView headerEndRefreshing];
    }];
}

#pragma mark - *** 收藏医院数据源 ***
- (void)loadHospitalNewData{
    
    [CollectionModel getCollectionHospitalDataWithUserID:[AppManager sharedManager].user.uid success:^(NSArray *list) {
        
        [self.HospitalDataSoure removeAllObjects];
        [self.HospitalTableView removeNoDataTipsView];
        if (list.count > 0) {
            [self.HospitalDataSoure addObjectsFromArray:list];
            
        }
        else{
            [self.HospitalTableView setNoDataTipsView:15];
            
        }
    
        [self.HospitalTableView reloadData];
        
        [self.HospitalTableView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.HospitalDataSoure removeAllObjects];
        
        [self.HospitalTableView setNoDataTipsView:15];
        [self.HospitalTableView reloadData];
        
        [self.HospitalTableView headerEndRefreshing];
    }];
}
#pragma mark -- 删除按钮的title变化
-(void)showDeleteButtonTitle{
    
    if (self.selectCount > 0)
    {
        self.deleteButton.selected = YES;
        self.deleteButton.enabled = YES;
        
        [self.deleteButton setTitleColor:HEXRGB(0xF66060) forState:UIControlStateSelected];
        [self.deleteButton setTitle:[NSString stringWithFormat:@"删除(%d)",self.selectCount] forState:UIControlStateSelected];
        
    }
    else{
        
        self.deleteButton.selected = NO;
        self.deleteButton.enabled = NO;
        
        [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        
    }
    
}
#pragma mark -- 删除 Action
-(void)deleteWithAction:(NSString *)action AndIds:(NSString *)idsStr{
    
    [CollectionModel DeleteCollectionDataWithIDS:idsStr Type:action success:^(NSString *successStr) {
        
        if ([action isEqualToString:@"video"])
        {
            [self loadVideoNewData];
            
        }else if ([action isEqualToString:@"doctor"])
        {
            [self loadDoctorNewData];
            
        }else if ([action isEqualToString:@"hospital"])
        {
            [self loadHospitalNewData];
        }
        
        self.selectAllbutton.selected = NO;
        [self.selectAllbutton setTitle:@"全选" forState:UIControlStateNormal];
        
        self.selectCount = 0;
        [self.selectArray removeAllObjects];
        [self showDeleteButtonTitle];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self dismissLoadingHUD];
            
            
        });
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        
        [self showError:error];
    }];
    
}
@end








