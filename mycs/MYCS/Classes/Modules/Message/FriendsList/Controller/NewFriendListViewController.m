//
//  NewFriendListViewController.m
//  MYCS
//
//  Created by Yell on 16/1/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "NewFriendListViewController.h"
#import "NewFriendListTableViewCell.h"
#import "friendModel.h"

@interface NewFriendListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@end

@implementation NewFriendListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.tableFooterView = [[UIView alloc]init];
    self.title = @"新的好友";
    if (self.dataSource.count > 0)
    {
        [self.listTableView reloadData];
    }else
    {
        self.dataSource = [NSMutableArray array];
        [self getListDataSource];
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.dataSource.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NewFriendListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"NewFriendListTableViewCell" forIndexPath:indexPath];
    
    FriendModel * model = self.dataSource[indexPath.row];
    cell.model = model;
    
    return cell;
    
}

-(void)getListDataSource
{
    [self showLoadingHUD];
    [FriendModel getRelationListSuccess:^(NSArray *list) {
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:list];
        [self.listTableView reloadData];
        [self showSuccessWithStatusHUD:nil];
        
    } Failure:^(NSError *error) {
        [self showErrorMessageHUD:nil];
        
    }];
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
