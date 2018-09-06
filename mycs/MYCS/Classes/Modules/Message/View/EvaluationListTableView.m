//
//  EvaluationListTableView.m
//  MYCS
//
//  Created by Yell on 16/1/21.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "EvaluationListTableView.h"
#import "InsidersEvaluationTableViewCell.h"
#import "OtherEvaluationTableViewCell.h"
#import "MJRefresh.h"
#import "EvaluationModel.h"

@interface EvaluationListTableView ()<UITableViewDataSource,UITableViewDelegate,OtherEvaluationTableViewCellDelegate>

@end
@implementation EvaluationListTableView

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.delegate = self;
    self.dataSource = self;
    
    self.tableFooterView = [[UIView alloc]init];
    self.listDataSource = [NSMutableArray array];
    [self addHeaderWithTarget:self action:@selector(loadNewData)];
    [self addFooterWithTarget:self action:@selector(loadMoreData)];
}

#pragma mark -tableView代理方法


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listDataSource.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat  cellHeight;
    if (self.ViewType == EvalutaionTableViewTypeInsiders) {
        
        EvaluationInsidersModel *model = self.listDataSource[indexPath.section];
        
       cellHeight =  [EvalutaionTableViewCellHeight calculateCellHeightWithInsidersModel:model view:tableView andStutasType:self.StatusType];
    } else
    {
        EvaluationOtherModel * model = self.listDataSource[indexPath.section];
        cellHeight = [EvalutaionTableViewCellHeight calculateCellHeightWithOtherModel:model view:tableView andStutasType:self.StatusType andTargeType:self.targetType];
    };
    
    return cellHeight;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 10)];
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.ViewType == EvalutaionTableViewTypeInsiders) {
        NSString * IdStr = @"InsidersEvaluationTableViewCell";
        UINib * nib = [UINib nibWithNibName:IdStr bundle:nil];
        
        [tableView registerNib:nib forCellReuseIdentifier:IdStr];
        
        InsidersEvaluationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdStr forIndexPath:indexPath];
        
        EvaluationInsidersModel *model = self.listDataSource[indexPath.section];
        cell.stutasType = self.StatusType;
        cell.model = model;
        return cell;

    } else {
        NSString * IdStr = @"OtherEvaluationTableViewCell";
        UINib * nib = [UINib nibWithNibName:IdStr bundle:nil];
        
        [tableView registerNib:nib forCellReuseIdentifier:IdStr];
        
        OtherEvaluationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdStr forIndexPath:indexPath];
        cell.delegate = self;
        EvaluationOtherModel * model = self.listDataSource[indexPath.section];
        cell.targeType = self.targetType;
        cell.stutasType = self.StatusType;
        cell.model = model;
        return cell;

    };
}

-(void)RefreshList
{
    [self headerBeginRefreshing];
}


#pragma mark -点击cell回复按钮回调

-(void)selectCell:(OtherEvaluationTableViewCell *)cell WithModel:(EvaluationOtherModel *)model
{
    if ([self.delegateVS respondsToSelector:@selector(selectReplyButton:WithModel:)])
    {
        [self.delegateVS selectReplyButton:self WithModel:model];
    }
}


#pragma mark -获取消息方法

- (void)loadNewData{
    
    self.page = 1;
    if (self.ViewType == EvalutaionTableViewTypeInsiders) {
        [EvaluationModel getInsidersListWithListType:self.StatusType page:self.page Success:^(NSArray *list) {
            [self.listDataSource removeAllObjects];
            [self.listDataSource addObjectsFromArray:list];
            [self reloadData];
            
            [self headerEndRefreshing];
        } Failure:^(NSError *error) {
            
            [self headerEndRefreshing];

        }];
    }else
    {
        [EvaluationModel getOtherListWithListType:self.StatusType targetType:self.targetType page:self.page Success:^(NSArray *list) {
            [self.listDataSource removeAllObjects];
            [self.listDataSource addObjectsFromArray:list];
            [self reloadData];
            
            [self headerEndRefreshing];

        } Failure:^(NSError *error) {
            
            [self headerEndRefreshing];

        }];
    }

}

- (void)loadMoreData{
    self.page ++;
    if (self.ViewType == EvalutaionTableViewTypeInsiders) {
        [EvaluationModel getInsidersListWithListType:self.StatusType page:self.page Success:^(NSArray *list) {

            [self.listDataSource addObjectsFromArray:list];
            
            [self reloadData];
            [self footerEndRefreshing];
            
        } Failure:^(NSError *error) {
            
            [self footerEndRefreshing];

        }];
    }else
    {
        [EvaluationModel getOtherListWithListType:self.StatusType targetType:self.targetType page:self.page Success:^(NSArray *list) {
            
            [self.listDataSource addObjectsFromArray:list];
            
            [self reloadData];
            
            [self footerEndRefreshing];

        } Failure:^(NSError *error) {
            
            [self footerEndRefreshing];

        }];
    }
}




@end
