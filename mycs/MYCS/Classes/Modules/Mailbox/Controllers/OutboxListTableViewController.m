//
//  OutboxListTableViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "OutboxListTableViewController.h"

#import <objc/runtime.h>
#import "MJRefresh.h"
#import "NSDate+Util.h"

#import "OutMailBoxCell.h"

#import "MessageModel.h"
#import "MessageModel.h"

#include "MailBoxDetailViewController.h"

@interface OutboxListTableViewController ()


@property (assign, nonatomic) int page;

@property (strong, nonatomic) NSMutableArray *baseDataSource;

@end

@implementation OutboxListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.baseDataSource = [NSMutableArray array];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //添加上下拉
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadNewData) name:@"RefleshTheMailBoxOutData" object:nil];
    
    //自动加载
    [self.tableView headerBeginRefreshing];
    
    [self.tableView headerBeginRefreshing];
}

#pragma mark -- setting and getting
-(void)setKeyword:(NSString *)keyword{
    
    _keyword = keyword;
    
    [self loadNewData];
    
}


#pragma mark - http request
- (void)loadNewData{
    
    self.page = 1;
    
    [MessageModel requestOutboxListWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] pageNo:[NSString stringWithFormat:@"%d", self.page] pageSize:@"10" keyword:self.keyword Success:^(NSArray *list) {
        
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
    
    [MessageModel requestOutboxListWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] pageNo:[NSString stringWithFormat:@"%d", self.page] pageSize:@"10" keyword:self.keyword Success:^(NSArray *list) {
        
        [self.baseDataSource addObjectsFromArray:list];
        
        [self.tableView reloadData];
        
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        
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
    NSString *identifier = @"OutMailBoxCell";
    OutMailBoxCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil)
    {
        cell = [[OutMailBoxCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    if (indexPath.row < self.baseDataSource.count)
    {
        OutboxListItemModel *temp = [self.baseDataSource objectAtIndex:indexPath.row];
        
        if (temp.toUser)
        {
            
            cell.personL.text = temp.toUser;
            
        }else{
            
            cell.personL.text = @"系统消息";
            
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

-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"删除";
    
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [self deleteMessage:indexPath];
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    OutboxDetailModel *temp = [self.baseDataSource objectAtIndex:indexPath.row];

    MailBoxDetailViewController * detailVC = [[UIStoryboard storyboardWithName:@"Mailbox" bundle:nil] instantiateViewControllerWithIdentifier:@"MailBoxDetailViewController"];
    
    detailVC.type = 1;
    detailVC.outMessageID = temp.msgId;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:detailVC animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 93;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section

{
    return 0;
}

#pragma mark -delete
-(void)deleteMessage:(NSIndexPath *)indexPath
{
    OutboxListItemModel *model = self.baseDataSource[indexPath.row];
    
    [MessageModel deleteMessageWithUserID:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] linkIDs:model.msgId from:@"send" success:^{
        
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
    // Dispose of any resources that can be recreated.
}


@end
