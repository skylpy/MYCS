//
//  InboxListTableViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "InboxListTableViewController.h"

#import "MJRefresh.h"
#import "NSDate+Util.h"

#import "InMailBoxCell.h"
#import "MessageModel.h"

#include "MailBoxDetailViewController.h"

@interface InboxListTableViewController ()

@property (assign, nonatomic) int page;

@property (strong, nonatomic) NSMutableArray *baseDataSource;

@end

@implementation InboxListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseDataSource = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [self.tableView headerBeginRefreshing];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"RefleshTheMailBoxInData" object:nil];
    
}
#pragma mark -- setting and getting
-(void)setKeyword:(NSString *)keyword{
 
    _keyword = keyword;
    
    [self loadNewData];

}
#pragma mark - http request
- (void)loadNewData{
    
    self.page = 1;
    
    [MessageModel requestInboxListWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] pageNo:[NSString stringWithFormat:@"%d", self.page] pageSize:@"10" keyword:self.keyword Success:^(NSArray *list) {
        
        [self.baseDataSource removeAllObjects];
        
        if (list.count != 0) {
            UILabel * la = [self.view viewWithTag:7878];
            [la removeFromSuperview];
            
            [self.baseDataSource addObjectsFromArray:list];
            
        }
        else{
            
            [self noDataTips:self andSearchView:nil andJudge:NO ];
        }
        
        
        
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        
        
    } failure:^(NSError *error) {
        
        [self.tableView headerEndRefreshing];
        
    }];
    
    
}

- (void)loadMoreData{
    self.page ++;
    
    [MessageModel requestInboxListWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] pageNo:[NSString stringWithFormat:@"%d", self.page] pageSize:@"10" keyword:self.keyword Success:^(NSArray *list) {
        
        [self.baseDataSource addObjectsFromArray:list];
        
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        
        
    } failure:^(NSError *error) {
        self.page --;
        [self.tableView footerEndRefreshing];
        
    }];
    
}
#pragma mark -dataSource
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _baseDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = @"InMailBoxCell";
    InMailBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[InMailBoxCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row < self.baseDataSource.count)
    {
        
        InboxListItemModel *temp = [self.baseDataSource objectAtIndex:indexPath.row];
        
        if (temp.from_username)
        {
            
            cell.personL.text = temp.from_username;
            
        }else
        {
            
            cell.personL.text = @"系统消息";
            
        }
        
        if (temp.isRead == NO)
        {
            cell.iconImageView.hidden = NO;
            
        }else
        {
            cell.iconImageView.hidden = YES;
        }
        
        cell.titleL.text = temp.title;
        cell.timeL.text = [NSDate dateWithTimeInterval:[temp.addTime floatValue] format:@"yyyy-MM-dd HH:mm"];
        cell.contentL.numberOfLines = 2;
        cell.contentL.text = temp.content;
        
        
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteMessage:indexPath];
        
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
 
  return @"删除";
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    InMailBoxCell * cell = (InMailBoxCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    InboxListItemModel *temp = [self.baseDataSource objectAtIndex:indexPath.row];
    
    cell.iconImageView.hidden = YES;
    temp.isRead = YES;
    
    MailBoxDetailViewController * detailVC = [[UIStoryboard storyboardWithName:@"Mailbox" bundle:nil] instantiateViewControllerWithIdentifier:@"MailBoxDetailViewController"];
    
    detailVC.type = 0;
    detailVC.inMessageID = temp.modelID;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:detailVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 100;
}
#pragma mark - delete Action
-(void)deleteMessage:(NSIndexPath *)indexPath
{
    InboxListItemModel *model = self.baseDataSource[indexPath.row];
    
    
    [MessageModel deleteMessageWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] linkIDs:model.modelID from:nil success:^{
        
        [self.tableView reloadData];
        
        [self deleteSuccess:indexPath];
        
    } failure:^(NSError *error) {
        
        [self showErrorMessage:@"删除失败"];
    }];
}

-(void)deleteSuccess:(NSIndexPath *)indexPath
{
    
    [self.baseDataSource removeObjectAtIndex:indexPath.row];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    if (self.baseDataSource.count<5)
    {
        [self.tableView footerBeginRefreshing];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
