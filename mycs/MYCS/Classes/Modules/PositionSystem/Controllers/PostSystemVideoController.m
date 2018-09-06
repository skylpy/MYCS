//
//  PostSystemVideoController.m
//  MYCS
//
//  Created by wzyswork on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "PostSystemVideoController.h"

#import "PostSystem.h"

#import "MJRefresh.h"
#import "PostSystemVideoCell.h"

#import "VCSDetailViewController.h"

@interface PostSystemVideoController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@property (weak, nonatomic) IBOutlet UIButton *deleteButton;

@property (weak, nonatomic) IBOutlet UIButton *selectAllbutton;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottom;

@property (nonatomic,strong) NSMutableArray * dataSoure;

@property (nonatomic,strong) NSMutableArray * selectArr;

@property (nonatomic,assign)int page;

@property (nonatomic,assign) int selectCount;

@property (nonatomic,assign)BOOL isEdict;

@end

@implementation PostSystemVideoController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
    self.viewBottom.constant = -50;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectCount = 0;
    self.isEdict = NO;
    
    self.selectAllbutton.selected = NO;
    [self.selectAllbutton setTitle:@"全选" forState:UIControlStateNormal];
    
    self.dataSoure = [NSMutableArray array];
    self.selectArr = [NSMutableArray array];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView addHeaderWithCallback:^{
        [self reloadData];
    }];
    [self.collectionView addFooterWithCallback:^{
        [self reloadMoreData];
    }];
    
    [self.collectionView headerBeginRefreshing];
}

#pragma mark -- HTTP
-(void)reloadData{
    
    self.page = 1;
    
    [PostSystem getPostSystemVideoDataWithUserID:[AppManager sharedManager].user.uid DeptId:self.deptIdStr page:self.page pageSize:10 success:^(NSArray *List) {
        
        [self.dataSoure removeAllObjects];
        [self.dataSoure addObjectsFromArray:List];
        
       if (self.dataSoure.count == 0)
       {
           self.isEdict = NO;
           [self.selectArr removeAllObjects];
           self.viewBottom.constant = -50;
           [self.rightButton setTitle:@"编辑"];
       }
        
        [self.collectionView reloadData];
        
        [self.collectionView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.collectionView headerEndRefreshing];
        
        [self showError:error];
    }];
}
-(void)reloadMoreData{
    
    self.page += 1;
    
    [PostSystem getPostSystemVideoDataWithUserID:[AppManager sharedManager].user.uid DeptId:self.deptIdStr page:self.page pageSize:10 success:^(NSArray *List) {
        
        [self.dataSoure addObjectsFromArray:List];
        
        [self.collectionView reloadData];
        
        [self.collectionView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self.collectionView footerEndRefreshing];
        
        self.page -= 1;
        
        [self showError:error];
    }];
}

#pragma mark -- setting and getting
-(void)setDeptIdStr:(NSString *)deptIdStr
{
    _deptIdStr = deptIdStr;
}
#pragma mark --  back action
- (IBAction)backAction:(UIBarButtonItem *)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- rightTopBtn Action
- (IBAction)cancelAction:(UIBarButtonItem *)sender
{
    self.selectAllbutton.selected = NO;
    [self.selectAllbutton setTitle:@"全选" forState:UIControlStateNormal];
    
    if(self.dataSoure.count == 0)return;
    
    self.isEdict = !self.isEdict;
    
    if (self.isEdict)
    {
        self.viewBottom.constant = 0;
        [self.rightButton setTitle:@"取消"];
        
    }else
    {
        self.viewBottom.constant = -50;
       [self.rightButton setTitle:@"编辑"];
        
    }
    
    for (PostSystemVideo * model in self.dataSoure)
    {
            model.isSelect = [NSNumber numberWithInt:0];
    }
    
    self.selectCount = 0;
    [self.selectArr removeAllObjects];
    
    [self showDeleteButtonTitle];
    
    [self.collectionView reloadData];
    
}
#pragma mark --  全选按钮 Action
- (IBAction)selectAllAction:(UIButton *)sender
{
    self.selectAllbutton.selected = !sender.selected;
    
    if (self.selectAllbutton.selected)
    {
        [self.selectAllbutton setTitle:@"取消全选" forState:UIControlStateNormal];
        
        for (PostSystemVideo * model in self.dataSoure)
        {
            model.isSelect = [NSNumber numberWithInt:1];
        }
        [self.selectArr removeAllObjects];
        self.selectCount = (int)self.dataSoure.count;
        [self.selectArr addObjectsFromArray:self.dataSoure];

    }else
    {
        [self.selectAllbutton setTitle:@"全选" forState:UIControlStateNormal];
        
        for (PostSystemVideo * model in self.dataSoure)
        {
            model.isSelect = [NSNumber numberWithInt:0];
        }
        [self.selectArr removeAllObjects];
        self.selectCount = 0;
    }
    
    
    [self showDeleteButtonTitle];
    
    [self.collectionView reloadData];
}
#pragma mark --  delete Action
- (IBAction)deleteAction:(UIButton *)sender
{
    [self showLoadingHUD];
    
    NSMutableArray * IdArray = [NSMutableArray array];
    [IdArray removeAllObjects];

    for (PostSystemVideo * video in self.selectArr)
    {
        [IdArray addObject:video.id];
    }
    
    NSString *idStr = [IdArray componentsJoinedByString:@","];
    
    [self deleteWithIds:idStr];
}
#pragma mark -- 删除
-(void)deleteWithIds:(NSString *)idStr
{
    self.selectAllbutton.selected = NO;
    [self.selectAllbutton setTitle:@"全选" forState:UIControlStateNormal];
    
    [PostSystem DeletePostSystemDataWithIDS:idStr success:^(NSString * success) {
        
        [self reloadData];
        
        self.selectCount = 0;
        [self.selectArr removeLastObject];
        [self showDeleteButtonTitle];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self dismissLoadingHUD];
            
            [self showSuccessWithStatusHUD:success];
            
            
        });
        
    } failure:^(NSError * error) {
        
        [self dismissLoadingHUD];
        
        [self showError:error];
    }];
    

}

#pragma mark -- UICollectionView Delegate and datasourse
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSoure.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"PostSystemVideoCell";
    PostSystemVideoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"PostSystemVideoCell" owner:self options:nil] lastObject];
    }
    
    PostSystemVideo * model = self.dataSoure[indexPath.row];
    
    if (model.isSelect == nil)
    {
        model.isSelect = [NSNumber numberWithInt:0];
    }
    
    cell.model = model;
    
    if (self.isEdict)
    {
        cell.selectBtn.hidden = NO;
    }else
    {
        cell.selectBtn.hidden = YES;
    }
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    self.selectAllbutton.selected = NO;
    [self.selectAllbutton setTitle:@"全选" forState:UIControlStateNormal];
    
     PostSystemVideo * model = self.dataSoure[indexPath.row];
    
    if (self.isEdict)
    {
        
        model.isSelect = model.isSelect.integerValue == 0?[NSNumber numberWithInt:1]:[NSNumber numberWithInt:0];
        
        self.selectCount = model.isSelect.integerValue == 0?self.selectCount - 1:self.selectCount + 1;
        
        if (model.isSelect.intValue == 1)
        {
            [self.selectArr addObject:model];
        }
        else
        {
            [self.selectArr removeObject:model];
        }
        
        if (self.selectArr.count == self.dataSoure.count)
        {
            self.selectAllbutton.selected = YES;
            [self.selectAllbutton setTitle:@"取消全选" forState:UIControlStateNormal];
            
        }else
        {
            self.selectAllbutton.selected = NO;
            [self.selectAllbutton setTitle:@"全选" forState:UIControlStateNormal];
        }
        
        [self showDeleteButtonTitle];
        
        [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
        
        return;
    }
    
    VCSDetailViewController *vcsVC = [[UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil] instantiateViewControllerWithIdentifier:@"VCSDetailViewController"];
    
    vcsVC.mySelft = YES;
    
    if ([model.type isEqualToString:@"video"])
    {
        vcsVC.type = VCSDetailTypeVideo;
    }
    else if ([model.type isEqualToString:@"course"])
    {
        vcsVC.videoId = model.courseId;
        
        vcsVC.type = VCSDetailTypeCourse;
    }
    else if ([model.type isEqualToString:@"sop"])
    {
        vcsVC.videoId = model.sopId;
        
        vcsVC.type = VCSDetailTypeSOP;
    }
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vcsVC animated:YES];

}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 7, 10, 7);
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake((ScreenW - 21) / 2, 150);
}

#pragma mark --  删除按钮title 值变化
-(void)showDeleteButtonTitle{
    
    if (self.selectCount > 0)
    {
        self.deleteButton.selected = YES;
        self.deleteButton.enabled = YES;
        
        [self.deleteButton setTitleColor:HEXRGB(0xF66060) forState:UIControlStateSelected];
        [self.deleteButton setTitle:[NSString stringWithFormat:@"删除(%d)",self.selectCount] forState:UIControlStateSelected];
        
    }else
    {
        
        self.deleteButton.selected = NO;
        self.deleteButton.enabled = NO;
        
        [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
       
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
