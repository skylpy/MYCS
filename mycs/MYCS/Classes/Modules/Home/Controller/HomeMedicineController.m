//
//  HomeMedicineController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "HomeMedicineController.h"
#import "CoursePackModel.h"
#import "UIImageView+WebCache.h"
#import "VCSDetailViewController.h"
#import "ClassDetailViewController.h"
#import "VideoShopListModel.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "UICollectionView+NoDataTips.h"

static NSString *cellReuseId = @"HomeMedicineCell";

@interface HomeMedicineController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewTopConstraint;

@property (nonatomic, assign) int page;

@property (nonatomic ,strong) NSString *searchKeyWord;

@end

@implementation HomeMedicineController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UMAnalyticsHelper beginLogPageName:@"课程"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [UMAnalyticsHelper endLogPageName:@"课程"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.flowLayout setHeaderReferenceSize:CGSizeMake(ScreenW, ScreenW * 0.524)];
    
    CGFloat with = (ScreenW - 22) * 0.5;
    
    self.flowLayout.itemSize            = CGSizeMake(with, with * 0.5625 + 70);
    self.flowLayout.headerReferenceSize = CGSizeMake(ScreenW, 10);
    
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [self.collectionView headerBeginRefreshing];
    
    if (!iS_IOS7)
    {
        [self addConstraints];
    }
    [self buildTextField];
}

-(void)buildTextField
{
    UIButton * leftView = ({
        
        UIButton * btn = [UIButton new];
        
        btn.frame = CGRectMake(0, 0, 30, 20);
        
        [btn setImage:[UIImage imageNamed:@"search"]forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(searchDoctorClick) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    self.searchTextField.delegate = self;
    self.searchTextField.layer.cornerRadius = 4.0;
    self.searchTextField.clipsToBounds = YES;
    
    self.searchTextField.leftView = leftView;
    
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.searchTextField addLeftRightOnKeyboardWithTarget:self leftButtonTitle:@"取消" rightButtonTitle:@"搜索" leftButtonAction:@selector(hideKeyBoard) rightButtonAction:@selector(searchDoctorClick) shouldShowPlaceholder:YES];
}

-(void)hideKeyBoard
{
    [self.searchTextField resignFirstResponder];
}

-(void)searchDoctorClick
{
    [UMAnalyticsHelper eventLogClick:@"event_course_search"];
    self.searchKeyWord = self.searchTextField.text;
    [self loadNewData];
    [self hideKeyBoard];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    self.searchKeyWord = self.searchTextField.text;
    [self loadNewData];
    [self hideKeyBoard];
    
    return YES;
}

- (void)addConstraints {
    self.collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    self.automaticallyAdjustsScrollViewInsets                     = NO;
    
    id collectionView = self.collectionView;
    id topLayoutGuide = self.topLayoutGuide;
    
    NSString *hVFL = @"H:|-(0)-[collectionView]-(0)-|";
    
    NSString *vVFL = @"V:|-(0)-[topLayoutGuide]-(45)-[collectionView]-(0)-|";
    
    
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(topLayoutGuide, collectionView)];
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(topLayoutGuide, collectionView)];
    
    [self.view addConstraints:hConsts];
    [self.view addConstraints:vConsts];
}

#pragma mark – Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    HomeMedicineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseId forIndexPath:indexPath];
    
    CoursePackListModel *itemModel = self.dataSource[indexPath.row];
    
    cell.packModel = itemModel;
    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    CoursePackListModel *itemModel = self.dataSource[indexPath.row];
    
    [self pushVCSDetailControllerWith:itemModel];
}

#pragma mark -搜索框的隐藏与显示
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (translation.y<0)
    {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
            self.searchViewHeightConstraint.constant = 0.1;
            self.collectionViewTopConstraint.constant = 0;
            
            
        } completion:^(BOOL finished) {
            self.searchTextField.alpha = 0;
            self.searchViewTopConstraint.constant = -40;
            
        }];
        
    }else if(translation.y>0)
    {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.searchViewTopConstraint.constant = 5;
            
        } completion:^(BOOL finished) {
            
            self.searchTextField.alpha = 1;
            self.collectionViewTopConstraint.constant = 45;
            self.searchViewHeightConstraint.constant = 35;
            
        }];
    }
    
    [self.searchTextField resignFirstResponder];
}


//根据模型跳转到视频详情
- (void)pushVCSDetailControllerWith:(CoursePackListModel *)itemModel {
    
    [UMAnalyticsHelper eventLogClick:@"event_course_enter"];
    if (![itemModel.type isEqualToString:@"coursePack"])
    {
        //创建视频详情的控制器
        UIStoryboard *vcsSB            = [UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil];
        VCSDetailViewController *vcsVC = [vcsSB instantiateViewControllerWithIdentifier:@"VCSDetailViewController"];
        
        vcsVC.videoId = itemModel.id;
        
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
        [self pushCoursePackDetailWithURL:itemModel.id];
        
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

#pragma mark - Network
- (void)loadNewData {
    self.page = 1;
    
    [CoursePackListModel requestCoursePackListWithPage:self.page andKeyWord:self.searchKeyWord Success:^(NSArray *list) {
        
        [self.dataSource removeAllObjects];
        [self.collectionView removeNoDataTipsView];
        if (list.count > 0) {

            [self.dataSource addObjectsFromArray:list];
            
        }
        else{
            [self.collectionView setNoDataTipsView:15];
        }
        [self.collectionView reloadData];
        
        [self.collectionView headerEndRefreshing];
        
        
    }failure:^(NSError *error) {
        
        [self.collectionView headerEndRefreshing];
        
    }];
}



- (void)loadMoreData {
    self.page++;
    
    [CoursePackListModel requestCoursePackListWithPage:self.page andKeyWord:self.searchKeyWord  Success:^(NSArray *list) {
        
        [self.dataSource addObjectsFromArray:list];
        [self.collectionView reloadData];
        
        [self.collectionView footerEndRefreshing];
        
    }failure:^(NSError *error) {
        [self.collectionView footerEndRefreshing];
        
    }];
}

@end

@interface HomeMedicineCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *watchBtn;

@end


@implementation HomeMedicineCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.cornerRadius  = 2;
    self.layer.masksToBounds = YES;
    
    self.layer.borderColor = HEXRGB(0xe5e5e5).CGColor;
    self.layer.borderWidth = 0.5;
    
    self.titleLabel.numberOfLines = 2;
}

- (void)setItemModel:(ShopListItemModel *)itemModel{
    _itemModel = itemModel;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:itemModel.picUrl] placeholderImage:PlaceHolderImage];
    
    self.titleLabel.text = itemModel.name;
    
    [self.watchBtn setTitle:itemModel.click forState:UIControlStateNormal];
}

-(void)setPackModel:(CoursePackListModel *)packModel
{
    _packModel = packModel;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:packModel.picUrl] placeholderImage:PlaceHolderImage];
    
    self.titleLabel.text = packModel.name;
    
    [self.watchBtn setTitle:packModel.click forState:UIControlStateNormal];
}

@end
