//
//  SpaceModuleController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SpaceModuleController.h"
#import "VideoSpaceModel.h"
#import "MJRefresh.h"
#import "VideoSpaceModel.h"
#import "UIImageView+WebCache.h"
#import "NSMutableAttributedString+Attr.h"
#import "ConstKeys.h"
#import "UICollectionView+NoDataTips.h"
#import "IQUIView+IQKeyboardToolbar.h"

static NSString *cellReuseId = @"SpaceModuleCell";

@interface SpaceModuleController () <UICollectionViewDelegate, UICollectionViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstViewHight;
@property (weak, nonatomic) IBOutlet UITextField *firstSeach;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondViewHight;
@property (weak, nonatomic) IBOutlet UITextField *secondSeach;

@property (nonatomic, assign) NSInteger page;

@property (nonatomic, copy) NSString *urlPath;

@property (nonatomic,copy) NSString * keyword;

@end

@implementation SpaceModuleController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.keyword = @"";
    self.dataSource = [NSMutableArray array];

    CGFloat with             = (ScreenW - 22) * 0.5;
    self.flowLayout.itemSize = CGSizeMake(with, with * 0.5625 + 70);

    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [self initTextField];
}

-(void)initTextField{
    
    UIButton * leftView = ({
        
        UIButton * btn = [UIButton new];
        
        btn.frame = CGRectMake(0, 0, 30, 20);
        
        [btn setImage:[UIImage imageNamed:@"search"]forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    [self createTextField:self.firstSeach andView:leftView];
    [self createTextField:self.secondSeach andView:leftView];
}

-(void)createTextField:(UITextField *)textField andView:(UIButton *)leftView{
    
    textField.delegate = self;
    textField.layer.cornerRadius = 4.0;
    textField.clipsToBounds = YES;
    
    textField.leftView = leftView;
    
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    [textField addLeftRightOnKeyboardWithTarget:self leftButtonTitle:@"取消" rightButtonTitle:@"搜索" leftButtonAction:@selector(hideKeyBoard) rightButtonAction:@selector(searchClick) shouldShowPlaceholder:YES];
}
-(void)searchClick{
    
    if (self.index == 0) {
        
        self.keyword = self.firstSeach.text;
        [self.firstSeach resignFirstResponder];
    }else{
    
        self.keyword = self.secondSeach.text;
        [self.secondSeach resignFirstResponder];
    }
    
    
    [self.collectionView headerBeginRefreshing];
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self hideKeyBoard];
    [textField resignFirstResponder];
    return YES;
}
-(void)hideKeyBoard
{
    [self.firstSeach resignFirstResponder];
    [self.secondSeach resignFirstResponder];
}
#pragma mark -搜索框的隐藏与显示
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (translation.y<0)
    {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
        } completion:^(BOOL finished) {
            self.firstViewHight.constant = 0;
            self.secondViewHight.constant = 0;
        }];
        
    }else if(translation.y>0)
    {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
        } completion:^(BOOL finished) {
            
            self.firstViewHight.constant = 35;
            self.secondViewHight.constant = 35;
            
        }];
    }
    [self.firstSeach resignFirstResponder];
    [self.secondSeach resignFirstResponder];
}
#pragma mark – Delegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SpaceModuleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuseId forIndexPath:indexPath];

    VideoSpaceModel *model = self.dataSource[indexPath.row];
    cell.actionType        = self.actionStr;
    cell.model             = model;

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.cellClickAction)
    {
        VideoSpaceModel *model = self.dataSource[indexPath.row];
        self.cellClickAction(model, self.moduleType);
    }
}

#pragma mark - Network
- (void)loadNewData {
    self.page = 1;

    [self.collectionView removeNoDataTipsView];

    [VideoSpaceModel videoListWith:self.urlPath Id:self.idStr vipId:self.vipStr keyword:self.keyword action:self.actionStr page:self.page Success:^(NSArray *list) {


        [self.dataSource removeAllObjects];
        
        if (list.count != 0) {
            self.dataSource = [NSMutableArray arrayWithArray:list];
            
        }
        else{
            
            [self.collectionView setNoDataTipsView:0];
        }
        
        [self.collectionView reloadData];
        [self.collectionView headerEndRefreshing];

    }
        failure:^(NSError *error) {
            [self.collectionView headerEndRefreshing];
        }];
}

- (void)loadMoreData {
    self.page++;

    [VideoSpaceModel videoListWith:self.urlPath Id:self.idStr vipId:self.vipStr keyword:self.keyword action:self.actionStr page:self.page Success:^(NSArray *list) {

        [self.dataSource addObjectsFromArray:list];

        [self.collectionView reloadData];

        [self.collectionView footerEndRefreshing];

    }
        failure:^(NSError *error) {
            [self.collectionView footerEndRefreshing];
        }];
}

#pragma mark - public
- (void)refreshData {
    [self.collectionView headerBeginRefreshing];
}

#pragma mark - getter和setter
- (void)setModuleType:(SpaceModuleType)moduleType {
    _moduleType = moduleType;

    if (self.moduleType == SpaceModuleTypeVideo)
    {
        self.urlPath = VIDEO_PATH;
    }
    else if (self.moduleType == SpaceModuleTypeCourse)
    {
        self.urlPath = COURSE_PATH;
    }
    else
    {
        self.urlPath = SOP_PATH;
    }

    [self refreshData];
}

@end

@interface SpaceModuleCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *uploaderLabel;

@end

@implementation SpaceModuleCell

- (void)awakeFromNib {
    //    self.layer.cornerRadius = 4;
    //    self.layer.masksToBounds = YES;
    
    [super awakeFromNib];
    self.layer.borderColor = HEXRGB(0xe5e5e5).CGColor;
    self.layer.borderWidth = 0.5;
}

- (void)setModel:(VideoSpaceModel *)model {
    _model = model;

    NSString *str = model.image == nil ? model.picUrl : model.image;

    [self.iconView sd_setImageWithURL:[NSURL URLWithString:str == nil ? model.picurl : str] placeholderImage:PlaceHolderImage];

    self.titleLabel.text = model.name;

    NSString *placeStr  = [self.actionType isEqualToString:@"basic"] ? @"分类:" : @"上传者:";
    NSString *detailStr = [self.actionType isEqualToString:@"basic"] ? model.cateName : model.uploader;
    NSString *status    = [NSString stringWithFormat:@"%@%@", placeStr, detailStr];

    UIColor *color = HEXRGB(0x666666);

    self.uploaderLabel.attributedText = [NSMutableAttributedString string:status value1:color range1:NSMakeRange(placeStr.length, status.length - placeStr.length) value2:nil range2:NSMakeRange(0, 0) font:13];
}


@end
