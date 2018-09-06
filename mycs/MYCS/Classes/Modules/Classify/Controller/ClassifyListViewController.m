//
//  ClassifyListViewController.m
//  MYCS
//
//  Created by Yell on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ClassifyListViewController.h"
#import "VideoSpaceModel.h"
#import "UIViewController+Message.h"
#import "SelectClassButton.h"
#import "MJRefresh.h"
#import "SelectClassController.h"
#import "ClassifyListCollectionViewCell.h"

#import "NewClassifySearchViewController.h"

static NSString *cellReuseId = @"ClassifyListCollectionViewCell";

@interface ClassifyListViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,strong) NSMutableArray * selectList;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@end

@implementation ClassifyListViewController

-(NSMutableArray *)dataSource{

    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}
-(NSMutableArray *)selectList{

    if (!_selectList) {
        _selectList = [NSMutableArray array];
    }
    return _selectList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    self.automaticallyAdjustsScrollViewInsets = NO;
    //self.selectList = [NSMutableArray array];
    [self buildUI];
}

- (void)buildUI {
    
    CGFloat itemW = (ScreenW-10*2-15*2)/3;
    
    self.flowLayout.itemSize = CGSizeMake(itemW, 40);
    
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewData)];
    
    [self.collectionView headerBeginRefreshing];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassModel *model = self.dataSource[indexPath.row];
    
    ClassifyListCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseId forIndexPath:indexPath];
    cell.titleLabel.text = model.text;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ClassModel *model = self.dataSource[indexPath.row];
    NewClassifySearchViewController * Vc = [[UIStoryboard storyboardWithName:@"Classify" bundle:nil]instantiateViewControllerWithIdentifier:@"NewClassifySearchViewController"];
    Vc.cid = model.id;
    Vc.titleString = model.text;
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:Vc animated:YES];
    
}

#pragma mark - Network
- (void)loadNewData {
    
    [ClassModel classListCategoryWithSuccess:^(NSArray *list) {
        
        self.dataSource = (NSMutableArray *)list;
        
        [self.collectionView reloadData];
        [self.collectionView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        [self dismissLoadingHUD];
        [self.collectionView headerEndRefreshing];
        
    }];
}


@end

