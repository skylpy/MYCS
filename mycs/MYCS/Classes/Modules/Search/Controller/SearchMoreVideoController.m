
//
//  SearchMoreVideoController.m
//  MYCS
//
//  Created by wzyswork on 16/1/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SearchMoreVideoController.h"

#import "SearchModel.h"

#import "SearchVideoListCell.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"
#import "ChoosePriceTypeView.h"
#import "IQUIView+IQKeyboardToolbar.h"

#import "VCSDetailViewController.h"

@interface SearchMoreVideoController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,assign) int page;

//priceType 0为全部 1为付费 2为免费
@property (nonatomic,assign) int priceType;

@end

@implementation SearchMoreVideoController


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchTextField resignFirstResponder];
    
}

-(void)searchClick
{
    [self.searchTextField resignFirstResponder];
    
    if (self.searchTextField.text.length == 0) {
        return;
    }
    [self.collectionView headerBeginRefreshing];
}

-(void)hidekeyBoard
{
    [self.searchTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.priceType = 0;
    
    self.dataSource = [NSMutableArray array];
    
    self.searchTextField.text = self.keyword;
    
    self.searchTextField.layer.cornerRadius = 4.0;
    self.searchTextField.clipsToBounds = YES;
    self.searchTextField.width = ScreenW - 110;
    
    UIButton * leftView = ({
        
        UIButton * btn = [UIButton new];
        
        btn.frame = CGRectMake(0, 0, 25, 15);
        
        if (iS_IOS8LATER)
        {
            btn.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5);
        }
        
        [btn setImage:[UIImage imageNamed:@"search"]forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    self.searchTextField.leftView = leftView;
    
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.searchTextField addLeftRightOnKeyboardWithTarget:self leftButtonTitle:@"取消" rightButtonTitle:@"搜索" leftButtonAction:@selector(hidekeyBoard) rightButtonAction:@selector(searchClick) shouldShowPlaceholder:YES];
    
    self.searchTextField.delegate = self;
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    //自动加载
    [self.collectionView headerBeginRefreshing];
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - price 筛选 Action
- (IBAction)wrightbtnClick:(id)sender
{
    [self.searchTextField resignFirstResponder];
    
    [ChoosePriceTypeView showInView:self andIndex:self.priceType andBlock:^(ChoosePriceTypeView * sheet, NSInteger index) {
        
        self.priceType = (int)index;
        
        [self.collectionView headerBeginRefreshing];
        
    }];
}

#pragma mark - collection Delegate and DataSourse
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"SearchVideoListCell";
    
    UINib *nib = [UINib nibWithNibName:@"SearchVideoListCell"
                                bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:identifier];
    
    SearchVideoListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    if (self.type == 1)
    {
        searchAllVideoDataModel *model = self.dataSource[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:PlaceHolderImage];
        [cell.playNumBtn setTitle:model.click forState:UIControlStateNormal];
        [cell.praiseNumBtn setTitle:model.up forState:UIControlStateNormal];
        cell.typeL.text =@"视频";
        cell.titleL.text = model.title;
        
    }else if (self.type == 2)
    {
        searchAllcourseDataModel *model = self.dataSource[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.picurl] placeholderImage:PlaceHolderImage];
        [cell.playNumBtn setTitle:model.click forState:UIControlStateNormal];
        [cell.praiseNumBtn setTitle:model.up forState:UIControlStateNormal];
        cell.typeL.text =@"教程";
        cell.titleL.text = model.name;
        
    }else if (self.type == 3)
    {
        searchAllsopDataModel *model = self.dataSource[indexPath.row];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:PlaceHolderImage];
        [cell.playNumBtn setTitle:model.click forState:UIControlStateNormal];
        [cell.praiseNumBtn setTitle:model.up forState:UIControlStateNormal];
        cell.typeL.text =@"SOP";
        cell.titleL.text = model.name;
    }
    
#pragma mark -- 使用iOS7之后的方法去警告
    //CGSize size = [cell.praiseNumBtn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGSize size = [cell.playNumBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    cell.praiseNumBtnWidth.constant = size.width + 35;
    
    //CGSize size1 = [cell.playNumBtn.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:12]];
    CGSize size1 = [cell.playNumBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
    cell.playNumBtnWidth.constant = size1.width + 35;
    
    return cell;
}

#pragma mark - UICollectionViewLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((ScreenW - 21) / 2, 155);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(10, 7, 10, 7);
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * videoId = [NSString string];
    
    VCSDetailViewController *vcsVC = [[UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil] instantiateViewControllerWithIdentifier:@"VCSDetailViewController"];
    
    if (self.type == 1)
    {
        searchAllVideoDataModel *model = self.dataSource[indexPath.row];
        videoId = model.id;
        vcsVC.type = VCSDetailTypeVideo;
        
    }else if (self.type == 2)
    {
        searchAllcourseDataModel *model = self.dataSource[indexPath.row];
        videoId = model.courseId;
        vcsVC.type = VCSDetailTypeCourse;
        
    }else if (self.type == 3)
    {
        searchAllsopDataModel *model = self.dataSource[indexPath.row];
        videoId = model.id;
        vcsVC.type = VCSDetailTypeSOP;
    }
    
    vcsVC.videoId = videoId;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vcsVC animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -Http
- (void)loadNewData{
    
    self.page = 1;
    
    NSString *trimmedString = [self.searchTextField.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.keyword = trimmedString;
    
    [SearchModel SearhVideoWithKeyWord:self.keyword type:self.type page:[NSString stringWithFormat:@"%i",self.page] priceType:[NSString stringWithFormat:@"%i",self.priceType] Success:^(NSMutableArray *ListArr) {
        
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:ListArr];
        
        [self.collectionView reloadData];
        
        [self.collectionView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        [self.collectionView headerEndRefreshing];
    }];
    
}

- (void)loadMoreData{
    self.page ++;
    
    NSString *trimmedString = [self.searchTextField.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.keyword = trimmedString;
    
    [SearchModel SearhVideoWithKeyWord:self.keyword type:self.type page:[NSString stringWithFormat:@"%i",self.page] priceType:[NSString stringWithFormat:@"%i",self.priceType] Success:^(NSMutableArray *ListArr) {
        
        [self.dataSource addObjectsFromArray:ListArr];
        
        [self.collectionView reloadData];
        
        [self.collectionView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        [self.collectionView footerEndRefreshing];
    }];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.collectionView headerBeginRefreshing];
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    ChoosePriceTypeView * old = [self.view viewWithTag:9999];
    [old removeFromSuperview];
}


@end
