//
//  AssessTaskTableView.m
//  MYCS
//
//  Created by Yell on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AssessTaskTableView.h"
#import "AssessTaskListTableViewCell.h"
#import "AssessCourseTaskDetailViewController.h"
#import "MJRefresh.h"

#import "InsidersEvaluationTableViewCell.h"
#import "EvalutaionTableViewCellHeight.h"

@interface AssessTaskTableView ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) NSMutableArray * listDataSorce;

@property (nonatomic,assign) CGFloat page;

@end

@implementation AssessTaskTableView


-(void)awakeFromNib
{
   
   [super awakeFromNib];
   self.dataSource = self;
   self.delegate = self;
   self.listDataSorce = [NSMutableArray array];
   self.tableFooterView = [[UIView alloc]init];
   
   [self addHeaderWithTarget:self action:@selector(loadNewData)];
   
   [self addFooterWithTarget:self action:@selector(loadMoreData)];
   
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return self.listDataSorce.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   NSString * IdStr = @"AssessTaskListTableViewCell";
   UINib * nib = [UINib nibWithNibName:IdStr bundle:nil];

   [tableView registerNib:nib forCellReuseIdentifier:IdStr];
   
   AssessTaskListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IdStr forIndexPath:indexPath];
   
   WaitToDoTask * model = self.listDataSorce[indexPath.row];
   cell.model =model;
   return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   WaitToDoTask * model = self.listDataSorce[indexPath.row];
   
//   NSString * detailId;
//   if (self.type == AssessTypeTaskCourse)
//      detailId = model.courseId;
//   else
//      detailId = model.sopId;
   
   if ([self.taskDelegate respondsToSelector:@selector(AssessTaskTableView:cellDidSelectWithModel:type:)]) {
   [self.taskDelegate AssessTaskTableView:self cellDidSelectWithModel:model type:self.type];
   }
   
}




- (void)loadNewData{
   
   self.page = 1;
   
   NSString * Action;
   if (self.type == AssessTypeTaskCourse)
      Action = @"getCommonTask";
   else if(self.type == AssessTaskTypeSOP)
      Action = @"getSOPTask";

   [WaitToDoTaskTool requestWaitDoTaskWithAction:Action taskStatus:self.taskStatus  page:self.page success:^(NSArray *list) {
      [self.listDataSorce removeAllObjects];
      [self.listDataSorce addObjectsFromArray:list];
      [self reloadData];
      [self headerEndRefreshing];

   } failure:^(NSError *error) {
      [self headerEndRefreshing];

   }];
   
   
   
}

- (void)loadMoreData{
   
   self.page ++;
   
   NSString * Action;
   if (self.type == AssessTypeTaskCourse)
      Action = @"getCommonTask";
   else if(self.type == AssessTaskTypeSOP)
      Action = @"getSOPTask";
   
   [WaitToDoTaskTool requestWaitDoTaskWithAction:Action taskStatus:self.taskStatus  page:self.page success:^(NSArray *list) {
      [self.listDataSorce addObjectsFromArray:list];
      [self reloadData];
      [self footerEndRefreshing];
   } failure:^(NSError *error) {
      [self footerEndRefreshing];
   }];
   
}

-(void)BeginRefreshing
{
   [self headerBeginRefreshing];
}

@end
