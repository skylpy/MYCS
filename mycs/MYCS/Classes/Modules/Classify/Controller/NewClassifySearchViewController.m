//
//  NewClassifySearchViewController.m
//  MYCS
//
//  Created by yiqun on 16/3/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//
/**
 *  新的分类搜索结果界面
 *
 *  @param <UICollectionViewDataSource
 *  @param UICollectionViewDelegate
 *  @param weak
 *  @param nonatomic
 *
 *  @return
 */
#import "NewClassifySearchViewController.h"
#import "VideoShopListModel.h"
#import "HomeMedicineController.h"
#import "VCSDetailViewController.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "UICollectionView+NoDataTips.h"

@interface NewClassifySearchViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *searchView;


@property (weak, nonatomic) IBOutlet NewClassifySearchCollectionView *NewVideoCollectionView;

@property (strong, nonatomic) NSMutableArray *listDataSource;

@property (assign, nonatomic) int page;
@property (assign, nonatomic) ClassifyVideoSearchType type;
@end

@implementation NewClassifySearchViewController

- (NSMutableArray *)listDataSource {
    if (!_listDataSource)
    {
        _listDataSource = [NSMutableArray array];
    }
    return _listDataSource;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title                         = self.titleString;
    self.type                          = ClassifyVideoSearchTypeVideo;
    self.searchTextField.delegate      = self;
    self.searchView.layer.cornerRadius = 6;
    self.searchView.clipsToBounds      = YES;

    [self.searchTextField addLeftRightOnKeyboardWithTarget:self leftButtonTitle:@"取消" rightButtonTitle:@"搜索" leftButtonAction:@selector(hidekeyBoard) rightButtonAction:@selector(searchClick) shouldShowPlaceholder:YES];

    [self.searchTextField resignFirstResponder];
    [self createView];
    [self loadNewData];
}
/**
 *  键盘搜索按钮的点击事件
 */
- (void)searchClick {
    [self.searchTextField resignFirstResponder];

    if (self.searchTextField.text.length == 0)
    {
        return;
    }
    [self searchBtnAction:nil];
}
/**
 *  隐藏键盘
 */
- (void)hidekeyBoard {
    [self.searchTextField resignFirstResponder];
}


- (void)createView {
    self.NewVideoCollectionView.delegate   = self;
    self.NewVideoCollectionView.dataSource = self;
    self.page                              = 1;

    [self.NewVideoCollectionView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.NewVideoCollectionView addFooterWithTarget:self action:@selector(loadMoreData)];
}
#pragma mark - http request
- (void)loadNewData {
    [self showLoadingHUD];

    self.page = 1;
    
    [VideoShopListModel searchVideoListWithcid:self.cid type:self.type keyword:self.searchStr status:@"ALL" page:self.page success:^(NSArray *list, NSInteger total) {
        [self.listDataSource removeAllObjects];
        [self.NewVideoCollectionView removeNoDataTipsView];
        
        if (list.count > 0) {
            [self.listDataSource addObjectsFromArray:list];
            
        }
        else{
            [self.NewVideoCollectionView setNoDataTipsView:15];
        }
        
        [self.NewVideoCollectionView reloadData];

        [self.NewVideoCollectionView headerEndRefreshing];
        [self dismissLoadingHUD];
    }
        failure:^(NSError *error) {
            [self.NewVideoCollectionView headerEndRefreshing];
            [self dismissLoadingHUD];

            [self showError:error];
        }];
}
/**
 *  上拖加载更多
 */
- (void)loadMoreData {
    self.page++;
    [VideoShopListModel searchVideoListWithcid:self.cid type:self.type keyword:self.searchStr status:@"ALL" page:self.page success:^(NSArray *list, NSInteger total) {
        [self.listDataSource addObjectsFromArray:list];
        [self.NewVideoCollectionView reloadData];
        [self.NewVideoCollectionView footerEndRefreshing];

    }
        failure:^(NSError *error) {
            [self.NewVideoCollectionView footerEndRefreshing];

        }];
}

#pragma mark - UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *idStr        = @"HomeMedicineCell";
    HomeMedicineCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idStr forIndexPath:indexPath];

    ShopListItemModel *model = self.listDataSource[indexPath.row];
    cell.itemModel           = model;
    return cell;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.listDataSource.count;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ShopListItemModel *model = self.listDataSource[indexPath.row];

    VCSDetailViewController *vc = [[UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil] instantiateViewControllerWithIdentifier:@"VCSDetailViewController"];

    vc.type    = (VCSDetailType)self.type; //(VCSDetailType)type;
    vc.videoId = model.modelID;
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWith = (self.NewVideoCollectionView.width - 15) / 2;
    return CGSizeMake(itemWith, itemWith * 0.5625 + 70);
}

/**
 *  搜索按钮
 *
 *  @param sender
 */
- (IBAction)searchBtnAction:(id)sender {
    self.searchStr = self.searchTextField.text;
    [self.searchTextField resignFirstResponder];
    [self loadListsData];
}

- (void)loadListsData {
    //self.NewVideoCollectionView.searchStr = self.searchStr;
    [self.NewVideoCollectionView headerBeginRefreshing];
}
/**
 *  键盘的响应事件
 *
 *  @param textField
 *
 *  @return 
 */
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self searchBtnAction:nil];

    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

/*!
 @author Sky, 16-04-18 14:04:17
 
 @brief NewClassifySearchCollectionView
 
 @since
 */
@implementation NewClassifySearchCollectionView


@end
