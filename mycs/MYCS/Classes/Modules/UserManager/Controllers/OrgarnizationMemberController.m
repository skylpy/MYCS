//
//  OrgarnizationMemberController.m
//  MYCS
//
//  Created by wzyswork on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "OrgarnizationMemberController.h"

#import "ZHMemberInfo.h"
#import "MemberManagerHttp.h"

#import "OrganizationMemberCell.h"
#import "MJRefresh.h"

#import "MemberDetailsController.h"

@interface OrgarnizationMemberController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *OrgarnizationMemberList;

@property (nonatomic,assign) int page;

@end

@implementation OrgarnizationMemberController


- (NSMutableArray *)OrgarnizationMemberList
{
    if (!_OrgarnizationMemberList)
    {
        _OrgarnizationMemberList = [NSMutableArray array];
    }
    return _OrgarnizationMemberList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 64;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
     [self.tableView headerBeginRefreshing];
}

#pragma mark - HTTP
- (void)loadNewData
{
    
    self.page = 1;
    
    User *user = [AppManager sharedManager].user;
    
    [MemberManagerHttp getMemberDetail:user.uid userType:[NSString stringWithFormat:@"%d",user.userType] action:@"getCompanyMember" page:self.page pageSize:10 success:^(NSArray *memberDetailList) {
        
        [self.OrgarnizationMemberList removeAllObjects];
        
        [self.OrgarnizationMemberList addObjectsFromArray:memberDetailList];
        
        [self.tableView reloadData];
        
        [self.tableView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        [self.tableView headerEndRefreshing];
    }];
    
}


- (void)loadMoreData
{
    
    self.page++;
    
    User *user = [AppManager sharedManager].user;
    
    [MemberManagerHttp getMemberDetail:user.uid userType:[NSString stringWithFormat:@"%d",user.userType] action:@"getCompanyMember" page:self.page pageSize:10 success:^(NSArray *memberDetailList) {
        
        
        [self.OrgarnizationMemberList addObjectsFromArray:memberDetailList];
        
        [self.tableView reloadData];
        
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        self.page--;
        [self showError:error];
        [self.tableView footerEndRefreshing];
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view dataSource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.OrgarnizationMemberList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *reuseID = @"OrganizationMemberCell";
    
    OrganizationMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell)
    {
        cell = [[OrganizationMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZHMemberInfo *memberInfo = self.OrgarnizationMemberList[indexPath.row];
    
    cell.memberInfo = memberInfo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZHMemberInfo *memberInfo = self.OrgarnizationMemberList[indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserManager" bundle:nil];
    
    MemberDetailsController *memberDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"MemberDetailsController"];
    
    memberDetailVC.title = memberInfo.name;
    
    memberDetailVC.memberUID = memberInfo.uid;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:memberDetailVC animated:YES];
    
}

@end
