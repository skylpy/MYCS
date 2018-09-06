//
//  VideoCenterViewController.m
//  MYCS
//  视频中心
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "VideoCenterViewController.h"

#import "VideoShopCollectionViewCell.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#import "DoctorModel.h"

#import "VCSDetailViewController.h"

@interface VideoCenterViewController ()

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation VideoCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    
    //添加上下拉
    
    [self.collectionView addHeaderWithTarget:self action:@selector(loadDataSource)];
    
    [self.collectionView headerBeginRefreshing];
}

-(void)setUid:(NSString *)uid
{
    _uid = uid;
    
    if (self.dataSource.count == 0)
    {
        [self.collectionView headerBeginRefreshing];
    }
    
}

#pragma mark - *** collectionView Delegate ***
- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    VideoShopCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"VideoCenterCell" forIndexPath:indexPath];
    
    if (self.dataSource.count>0)
    {
        DoctorVideoCenterModel *model = self.dataSource[indexPath.row];
        
        [cell setModel:model];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((ScreenW - 21) / 2, 150);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DoctorVideoCenterModel *model = self.dataSource[indexPath.row];
    
    VCSDetailViewController *vcsVC = [[UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil] instantiateViewControllerWithIdentifier:@"VCSDetailViewController"];
    
    if ([model.type isEqualToString:@"video"])
    {
        vcsVC.type = VCSDetailTypeVideo;
        
    } else if ([model.type isEqualToString:@"course"])
    {
        vcsVC.type = VCSDetailTypeCourse;
        
    } else if ([model.type isEqualToString:@"sop"])
    {
        vcsVC.type = VCSDetailTypeSOP;
    }
    
    vcsVC.videoId = model.id;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vcsVC animated:YES];
    
}

#pragma mark - *** Http ***
-(void)loadDataSource
{
    [DoctorModel doctorVideoCenterWithDoctorUid:self.uid agroup_id:self.agroup_id success:^(NSArray *list) {
        
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:list];
        
        [self.collectionView reloadData];
        
        [self.collectionView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.collectionView headerEndRefreshing];
        
        [self showError:error];
        
    }];
    
}


@end
