//
//  commentTypeListViewController.m
//  MYCS
//
//  Created by Yell on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "commentTypeListViewController.h"
#import "EvaluationListViewController.h"
#import "CommentTypeListTableViewCell.h"
#import "EvaluationModel.h"

@interface commentTypeListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (nonatomic,strong) NSArray * countArr;
@property (nonatomic,strong) NSArray * listArr;

@end

@implementation commentTypeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评论";
    self.navigationController.navigationBarHidden = NO;
    [self makeListDataSource];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.tableFooterView = [[UIView alloc]init];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getNotReadComment];

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArr.count;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 10)];
    return view;
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * idStr = @"CommentTypeListTableViewCell";
    CommentTypeListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:idStr forIndexPath:indexPath];
    
    EvaluationListModel * listModel = self.listArr[indexPath.section];
    for (EvaluationCommentCountModel * countModel in self.countArr)
    {
        if ([countModel.target_name isEqualToString:listModel.title])
        {
            cell.messageCount = countModel.count;
            break;
        }
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.titleLabel.text = listModel.title;
    [cell.iconView setImage:[UIImage imageNamed:listModel.iconName]];

    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CommentTypeListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.redView.hidden = YES;
    EvaluationListViewController * Vc =[[UIStoryboard storyboardWithName:@"Message" bundle:nil]instantiateViewControllerWithIdentifier:@"EvaluationListViewController"];
    switch (indexPath.section) {
        case 0:
            Vc.ViewType = EvalutaionTableViewTypeOther;
            Vc.targetType = EvaluationTargetTypeExchange;
            break;
        case 1:
            
            Vc.ViewType = EvalutaionTableViewTypeInsiders;
            
            break;
        case 2:
            Vc.ViewType = EvalutaionTableViewTypeOther;
            Vc.targetType = EvaluationTargetTypeVideo;
            break;
        case 3:
            Vc.ViewType = EvalutaionTableViewTypeOther;
            Vc.targetType =EvaluationTargetTypeCase;
            break;
        default:
            
            break;
    }
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:Vc animated:YES];
}

-(void)makeListDataSource
{
    EvaluationListModel * exchangeModel =  [EvaluationListModel makeEvaluationListModelWithIconName:@"exchange" Title:@"学术交流" TargetType:EvaluationTargetTypeExchange ViewType:EvalutaionTableViewTypeOther];
    EvaluationListModel * insiderModel = [EvaluationListModel makeEvaluationListModelWithIconName:@"evaluate" Title:@"业界评价" TargetType:EvaluationTargetTypeExchange ViewType:EvalutaionTableViewTypeInsiders];
    EvaluationListModel * videoModel = [EvaluationListModel makeEvaluationListModelWithIconName:@"video-space-0" Title:@"视频空间" TargetType:EvaluationTargetTypeVideo ViewType:EvalutaionTableViewTypeOther];
    EvaluationListModel * caseModel = [EvaluationListModel makeEvaluationListModelWithIconName:@"case-center" Title:@"案例中心" TargetType:EvaluationTargetTypeVideo ViewType:EvalutaionTableViewTypeOther];
    self.listArr = [NSArray arrayWithObjects:exchangeModel,insiderModel,videoModel,caseModel, nil];
}


-(void)getNotReadComment
{
    [EvaluationModel getNotReadCommentCountSuccess:^(NSArray *list) {
        self.countArr = list;
        
        [self.listTableView reloadData];
    } Failure:^(NSError *error) {
        
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
