//
//  CommentViewController.m
//  MYCS
//  医生详情评价
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "CommentViewController.h"

#import "MJRefresh.h"
#import "CommentCell.h"

#import "DoctorModel.h"
#import "DoctorCommentModel.h"
#import "PraiseModel.h"

#import "CommitCommentViewController.h"

@interface CommentViewController ()<CommitCommentControllerDelegate,CommentCellDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UIView *footView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) CGFloat height;

@property (nonatomic,assign) int page;

@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.commitBtn.layer.cornerRadius = 6;
    self.commitBtn.layer.masksToBounds = YES;
    
    self.commentList = [NSMutableArray array];
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];

}

#pragma mark - *** Http ***
- (void)loadNewData{
    
    self.page = 1;
    
    NSString *userID = [AppManager sharedManager].user.uid.length>0?[AppManager sharedManager].user.uid:@"";
    
    [DoctorCommentModel commentListsWithUserId:userID checkID:self.uid page:_page pageSize:10 success:^(DoctorCommentModel *commentListModel) {
        
        [_commentList removeAllObjects];
        [_commentList addObjectsFromArray:commentListModel.list];
        
        [self.tableView reloadData];
        
        [self.tableView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        [self.tableView headerEndRefreshing];
    }];
    
}

- (void)loadMoreData{
    
    self.page++;
    
    NSString *userID = [AppManager sharedManager].user.uid.length>0?[AppManager sharedManager].user.uid:@"";
    
    [DoctorCommentModel commentListsWithUserId:userID checkID:self.uid page:_page pageSize:10 success:^(DoctorCommentModel *commentListModel) {
        
        [_commentList addObjectsFromArray:commentListModel.list];
        
        [self.tableView reloadData];
        
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        [self.tableView footerEndRefreshing];

    }];
    
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.commentList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *reuseID = @"CommentCell";

    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    DoctorComment *comment = self.commentList[indexPath.row];
    
    cell.Dcomment = comment;
    cell.delegate = self;
    
    self.height = cell.height;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iS_IOS7)
    {
        static NSString *reuseID = @"CommentCell";
        
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        
        DoctorComment *comment = self.commentList[indexPath.row];
        
        cell.Dcomment = comment;
        
        self.height = cell.height;
    }
    return self.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 25;
}

#pragma mark - *** 评价成功刷新数据 ***
- (void)commitSuccess
{
    [self.tableView headerBeginRefreshing];
}

#pragma mark - *** 键盘影藏 ***
- (void)setUid:(NSString *)uid
{
    _uid = uid;
    
    [self.tableView headerBeginRefreshing];
}

#pragma mark - *** 跳到评价视图 Action ***
- (IBAction)commitAction:(id)sender
{
    
    if (![AppManager checkLogin]) return;
    
    CommitCommentViewController *commitCommentVC = [[UIStoryboard storyboardWithName:@"doctor" bundle:nil] instantiateViewControllerWithIdentifier:@"CommitCommentViewController"];
    
    commitCommentVC.uid = self.uid;
    commitCommentVC.delegate = self;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:commitCommentVC animated:YES];

}

#pragma mark - *** CommentCell Delegate - 刷新数据 ***
- (void)refreshTable:(CommentCell *)cell
{
    [self loadNewData];
}

#pragma mark - *** CommentCell Delegate - 点赞 ***
- (void)praiseBtnDidClick:(CommentCell *)cell andDoctorComment:(DoctorComment *)comment
{
    
    if ([AppManager checkLogin])
    {
        
        cell.Dcomment.isPraise = !cell.Dcomment.isPraise;
        cell.praiseBtn.selected  =cell.Dcomment.isPraise;
        cell.Dcomment.praiseNum =[NSString stringWithFormat:@"%d", cell.Dcomment.isPraise == YES?cell.Dcomment.praiseNum.intValue + 1:cell.Dcomment.praiseNum.intValue - 1];
        [cell.praiseBtn setTitle:cell.Dcomment.praiseNum forState:UIControlStateNormal];
    
        [PraiseModel praiseWithUseID:[AppManager sharedManager].user.uid target_type:0 target_id:comment.id success:^{
            
        } failure:^(NSError *error) {
            
//            [self showError:error];
        }];
    }
}


-(void)reloadData
{
    [self.tableView reloadData];
}
@end
