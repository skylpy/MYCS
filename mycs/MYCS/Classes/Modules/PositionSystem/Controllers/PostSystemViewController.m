//
//  PostSystemViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "PostSystemViewController.h"

#import "MJRefresh.h"
#import "PostSystemCell.h"

#import "PostSystem.h"

#import "PostSystemVideoController.h"
#import "SelectSourceController.h"
#import "TaskSelectObjectController.h"
#import "TaskObject.h"
#import "ReceiverModel.h"
#import "SelectDeptController.h"

@interface PostSystemViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray * dataSoure;

@property (nonatomic,strong) NSString * deptIdStr;

@property(nonatomic,assign)int page;

@property (retain,nonatomic)NSMutableArray * selectedDep;

@end

@implementation PostSystemViewController

- (NSMutableArray *)selectedDep {
    if (_selectedDep == nil)
    {
        _selectedDep = [NSMutableArray array];
    }
    return _selectedDep;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self reloadData];
    self.navigationController.navigationBarHidden = NO;
    
    [UMAnalyticsHelper beginLogPageName:@"岗位体系"];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [UMAnalyticsHelper endLogPageName:@"岗位体系"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"岗位体系";
    
    self.dataSoure = [NSMutableArray array];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStyleDone target:self action:@selector(selectAction)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    [self.tableView addHeaderWithCallback:^{
        [self reloadData];
    }];
    [self.tableView addFooterWithCallback:^{
        [self reloadMoreData];
    }];
    
    [self.tableView headerBeginRefreshing];
}

#pragma mark -- 筛选 Action
-(void)selectAction
{
    
    
    SelectDeptController * SVC = [[UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectDeptController"];
    SVC.isFirstCome = YES;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:SVC animated:YES];
    
    __weak typeof(self) weakSelf = self;
    SVC.sureBtnBlock = ^(NSString *selectIdStr) {
        
        weakSelf.deptIdStr = selectIdStr;
        
        [self.tableView headerBeginRefreshing];
        
    };
    

}
- (NSString *)selectIdStr:(NSArray *)list {
    
    NSString *idStr = [list componentsJoinedByString:@","];
    
    return idStr;
}


#pragma mark -- Http
-(void)reloadData
{
    self.page = 1;
    [PostSystem getPostSystemDataWithUserID:[AppManager sharedManager].user.uid DeptID:self.deptIdStr page:self.page pageSize:10 success:^(NSArray *list){
        
        [self.dataSoure removeAllObjects];
        [self.dataSoure addObjectsFromArray:list];
        
        [self.tableView reloadData];
        
        [self.tableView headerEndRefreshing];
        
        
    } failure:^(NSError *error) {
        
        [self.tableView headerEndRefreshing];
        
        [self showError:error];
        
        
    }];
}
-(void)reloadMoreData
{
    self.page ++;
    
    [PostSystem getPostSystemDataWithUserID:[AppManager sharedManager].user.uid DeptID:self.deptIdStr page:self.page pageSize:10 success:^(NSArray *list){
        
        [self.dataSoure addObjectsFromArray:list];
        
        [self.tableView reloadData];
        
        [self.tableView footerEndRefreshing];
        
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        self.page -= 1;
        
        [self.tableView footerEndRefreshing];
        
    }];

    
}

#pragma mark -- tableView Delegate and DataSourse
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSoure.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * identify = @"PostSystemCell";
    PostSystemCell * cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (cell == nil)
    {
        cell = [[PostSystemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    PostSystem * model =self.dataSoure[indexPath.row];
    
    cell.model = model;
   
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostSystemVideoController * pVC = [[UIStoryboard storyboardWithName:@"PostSystem" bundle:nil] instantiateViewControllerWithIdentifier:@"PostSystemVideoController"];
    
    PostSystem * model = self.dataSoure[indexPath.row];
    pVC.deptIdStr = model.deptId;
    pVC.title = [NSString stringWithFormat:@"%@岗位",model.deptName];
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:pVC animated:YES];
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
