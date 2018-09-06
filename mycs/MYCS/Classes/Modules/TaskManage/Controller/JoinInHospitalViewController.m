//
//  JoinInHospitalViewController.m
//  MYCS
//
//  Created by yiqun on 16/5/27.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "JoinInHospitalViewController.h"
#import "TaskModel.h"
#import "TaskDetailModel.h"

static NSString *const reuseID = @"TaskHostpitalListCell";

@interface JoinInHospitalViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *hostpitalTableView;

@property (retain,nonatomic)NSMutableArray * dataArray;
@end

@implementation JoinInHospitalViewController

-(NSMutableArray *)dataArray{

    if (!_dataArray) {
        
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.hostpitalTableView.tableFooterView = [UIView new];

}
-(void)setTaskModel:(TaskModel *)taskModel{

    _taskModel = taskModel;
    
    self.hostpitalTableView.delegate = self;
    self.hostpitalTableView.dataSource = self;
    self.hostpitalTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self requestDataWith:self.taskModel.Id sortType:self.sortType];
}

#pragma mark - Network
- (void)requestDataWith:(NSString *)taskId sortType:(NSString *)type{

    [TaskJoinHospitalModel hospitalJoinListWith:taskId Sort:type page:0 taskType:type success:^(NSMutableArray *list) {
        
        self.dataArray = list;
        [self.hostpitalTableView reloadData];
        
    } failure:^(NSError *error) {

    }];
    
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskHostpitalListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    TaskJoinHospitalModel *hospitalModel = self.dataArray[indexPath.row];
    
    cell.hospitalModel = hospitalModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end

@interface TaskHostpitalListCell()

@property (weak, nonatomic) IBOutlet UILabel *hostpitalLabel;

@end

@implementation TaskHostpitalListCell

-(void)setHospitalModel:(TaskJoinHospitalModel *)hospitalModel{

    _hospitalModel = hospitalModel;
    
    self.hostpitalLabel.text = hospitalModel.realname;
}

@end
