//
//  PlayRecordViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "PlayRecordViewController.h"
#import "PlayRecordModel.h"
#import "UIImageView+WebCache.h"
#import "VCSDetailViewController.h"
#import "MJRefresh.h"

static NSString *const reuseId = @"PlayRecordCell";

@interface PlayRecordViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;

@property (nonatomic,strong) NSMutableArray *dataBase;

@property (nonatomic,assign) int page;

@end

@implementation PlayRecordViewController

- (void)loadView {
    
    if (![AppManager hasLogin])
    {
        self.dataBase = [NSMutableArray arrayWithArray:[PlayRecordModel localPlayRecordsWith:1]];
        
        if (self.dataBase.count==0)
        {
            self.view = [UIView new];
            self.view.backgroundColor = [UIColor whiteColor];
            self.view.frame = [UIScreen mainScreen].bounds;
            UILabel *label = [UILabel new];
            [self.view addSubview:label];
            label.text = @"暂无播放记录";
            label.font = [UIFont systemFontOfSize:22];
            [label sizeToFit];
            label.center = self.view.center;
            label.textColor = HEXRGB(0xd1d1d1);
            
            [self addConstsToTipsLabel:label];
        }
        else
        {
            [super loadView];
        }
    }
    else
    {
        [super loadView];
    }
    
}

//给label添加约束
- (void)addConstsToTipsLabel:(UILabel *)label {
    
    label.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:label.superview attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:label attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:label.superview attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    [label.superview addConstraints:@[centerX,centerY]];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //设置Cell的大小
    CGFloat with = (ScreenW-22)*0.5;
    self.flowLayout.itemSize = CGSizeMake(with, 150);
    
    //添加上拉下拉刷新
    [self.collectionView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.collectionView addFooterWithTarget:self action:@selector(loadMoreData)];
    [self.collectionView headerBeginRefreshing];
    
}

#pragma mark - Network
- (void)loadNewData {
    
    self.page = 1;
    
    if (![AppManager hasLogin])
    {//获取本地记录
        self.dataBase = [PlayRecordModel localPlayRecordsWith:self.page];
        [self.collectionView reloadData];
        [self.collectionView headerEndRefreshing];
    }
    else
    {//获取网络记录
        [NetworkPlayRecordModel loadPlayRecordWithPage:self.page success:^(NetworkPlayRecordModel *model) {
            
            self.dataBase = [NSMutableArray arrayWithArray:model.list];
            [self.collectionView headerEndRefreshing];
            [self.collectionView reloadData];
            
        } failure:^(NSError *error) {
            
            [self showError:error];
            
        }];
    }
    
    
}

- (void)loadMoreData {
    
    self.page++;
    
    if (![AppManager hasLogin])
    {//获取本地记录
        NSMutableArray *list = [PlayRecordModel localPlayRecordsWith:self.page];
        
        if (list.count>0)
        {
            [self.dataBase addObjectsFromArray:list];
            [self.collectionView reloadData];
        }
        else
        {
            [self showErrorMessageHUD:@"没有更多播放记录"];
        }
        [self.collectionView footerEndRefreshing];
    }
    else
    {//获取网络记录
        [NetworkPlayRecordModel loadPlayRecordWithPage:self.page success:^(NetworkPlayRecordModel *model) {
            
            [self.dataBase addObjectsFromArray:model.list];
            [self.collectionView footerEndRefreshing];
            [self.collectionView reloadData];
            
        } failure:^(NSError *error) {
            
            [self showError:error];
            
        }];
    }
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataBase.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PlayRecordCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseId forIndexPath:indexPath];
    
    PlayRecordModel *model = self.dataBase[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //创建视频详情的控制器
    UIStoryboard *vcsSB = [UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil];
    VCSDetailViewController *vcsVC = [vcsSB instantiateViewControllerWithIdentifier:@"VCSDetailViewController"];
    
    PlayRecordModel *model = self.dataBase[indexPath.row];

    VCSDetailType type;
    if ([model.type isEqualToString:@"video"])
    {
        type = VCSDetailTypeVideo;
    }
    else if ([model.type isEqualToString:@"course"])
    {
        type = VCSDetailTypeCourse;
    }
    else if ([model.type isEqualToString:@"sop"])
    {
        type = VCSDetailTypeSOP;
    }
    
    vcsVC.videoId = model.video_id;
    vcsVC.type = type;
    
    [self.navigationController pushViewController:vcsVC animated:YES];
}

@end

@interface PlayRecordCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation PlayRecordCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    
    self.layer.borderColor = HEXRGB(0xe5e5e5).CGColor;
    self.layer.borderWidth = 0.5;

}

- (void)setModel:(PlayRecordModel *)model {
    _model = model;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.coverUrl] placeholderImage:PlaceHolderImage];
    
    self.titleLabel.text = model.title;
    
}

@end
