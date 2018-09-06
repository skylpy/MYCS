//
//  DoctorListController.m
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "DoctorListController.h"

#import "DoctorModel.h"

#import "MJRefresh.h"
#import "DoctorListCell.h"
#import "UIImageView+WebCache.h"

#import "DoctorsPageViewController.h"

@interface DoctorListController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSMutableArray * baseDataSource;

@property (nonatomic,assign) int page;


@end

@implementation DoctorListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseDataSource = [NSMutableArray array];
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    self.tableView.rowHeight = 94;
    
}

#pragma mark -- HTTP
- (void)loadNewData{
    
    self.page = 1;
    
    [DoctorModel doctorListsWithcheckID:_checkID page:self.page pageSize:10 success:^(NSArray *list) {
        
        [self.baseDataSource removeAllObjects];
        self.baseDataSource = [NSMutableArray arrayWithArray:list];
        
        [self.tableView headerEndRefreshing];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self.tableView headerEndRefreshing];
    }];
    
}

- (void)loadMoreData{
    
    self.page ++;
    
    [DoctorModel doctorListsWithcheckID:_checkID page:_page pageSize:10 success:^(NSArray *list) {
        
        [self.baseDataSource addObjectsFromArray:list];
        
        [self.tableView reloadData];
        
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        self.page --;
        
        [self.tableView footerEndRefreshing];
        
    }];
    
}
#pragma mark -- tableView Delegate And DataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _baseDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"DoctorListCell";
    
    DoctorListCell *cell  = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    DoctorListModel *model = self.baseDataSource[indexPath.row];
    
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
    cell.nameL.text = model.realname;
    [cell.nameL sizeToFit];
    cell.nameLWidth.constant = cell.nameL.width;
    cell.positionLabel.text = model.jobTitleName;
    cell.goodAtL.text =[NSString stringWithFormat:@"擅长:%@",model.goodat] ;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DoctorListModel *model = self.baseDataSource[indexPath.row];
    
    DoctorsPageViewController *doctorPageVC = [[UIStoryboard storyboardWithName:@"doctor" bundle:nil] instantiateViewControllerWithIdentifier:@"DoctorsPageViewController"];
    
    doctorPageVC.uid = model.uid;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:doctorPageVC animated:YES];
    
}
#pragma mark -- setting and getting
- (void)setCheckID:(NSString *)checkID
{
    _checkID = checkID;
    
    if (self.baseDataSource.count == 0)
    {
        [self.tableView headerBeginRefreshing];
        
    }
    
}


@end
