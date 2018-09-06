//
//  PersonalMemberController.m
//  MYCS
//
//  Created by wzyswork on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "PersonalMemberController.h"

#import "ZHMemberInfo.h"
#import "MemberManagerHttp.h"

#import "PersonMemberCell.h"
#import "MJRefresh.h"

#import "MemberDetailsController.h"

@interface PersonalMemberController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) NSMutableArray *PersonalMemberList;

@property (nonatomic,assign) int page;

@end

@implementation PersonalMemberController

- (NSMutableArray *)PersonalMemberList
{
    if (!_PersonalMemberList)
    {
        _PersonalMemberList = [NSMutableArray array];
    }
    return _PersonalMemberList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 64;
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [self.tableView headerBeginRefreshing];
}

#pragma mark -- HTTP
- (void)loadNewData
{
    
    self.page = 1;
    
       User *user = [AppManager sharedManager].user;
        
        [MemberManagerHttp getMemberDetail:user.uid userType:[NSString stringWithFormat:@"%d",user.userType] action:@"getPersonalMember" page:self.page pageSize:10 success:^(NSArray *memberDetailList) {

            [self.PersonalMemberList removeAllObjects];
            
            [self.PersonalMemberList addObjectsFromArray:memberDetailList];
            
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
    
    [MemberManagerHttp getMemberDetail:user.uid userType:[NSString stringWithFormat:@"%d",user.userType] action:@"getPersonalMember" page:self.page pageSize:10 success:^(NSArray *memberDetailList) {

        
        [self.PersonalMemberList addObjectsFromArray:memberDetailList];
        
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

#pragma mark -- Table view dataSource and Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.PersonalMemberList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *reuseID = @"PersonMemberCell";
    
    PersonMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell) {
        cell = [[PersonMemberCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    ZHMemberInfo *memberInfo = self.PersonalMemberList[indexPath.row];
    
    cell.memberInfo = memberInfo;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ZHMemberInfo *memberInfo = self.PersonalMemberList[indexPath.row];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserManager" bundle:nil];
    
    MemberDetailsController *memberDetailVC = [storyboard instantiateViewControllerWithIdentifier:@"MemberDetailsController"];
    
    memberDetailVC.title = memberInfo.name;
    
    memberDetailVC.memberUID = memberInfo.uid;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:memberDetailVC animated:YES];
    
}


@end
