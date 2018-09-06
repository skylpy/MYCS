//
//  JoinInPersonnelViewController.m
//  MYCS
//
//  Created by yiqun on 16/5/27.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "JoinInPersonnelViewController.h"
#import "TaskDetailModel.h"

static NSString *const reuseID = @"TaskUsersListCell";

@interface JoinInPersonnelViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *personTableView;

@end

@implementation JoinInPersonnelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.personTableView.tableFooterView = [UIView new];
    
}

-(void)setDetailModel:(TaskDetailModel *)detailModel{

    _detailModel = detailModel;
    
    self.personTableView.delegate = self;
    self.personTableView.dataSource = self;
    self.personTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    [self.personTableView reloadData];
}


#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.detailModel.user.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskUsersListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    TaskJoinUserModel *userModel = self.detailModel.user.list[indexPath.row];
    
    cell.userModel = userModel;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.CellClickBlock) {
        TaskJoinUserModel *model = self.detailModel.user.list[indexPath.row];
        self.CellClickBlock(model);
    }
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

@end


@interface TaskUsersListCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation TaskUsersListCell

- (void)setUserModel:(TaskJoinUserModel *)userModel {
    _userModel = userModel;
    
    self.nameLabel.text = userModel.realname;
    self.rankLabel.text = userModel.rank;
    if ([userModel.rank isEqualToString:@"暂无"] || [userModel.rank isEqualToString:@""] || userModel.rank == nil)
    {
        self.rankLabel.text = @"—";
    }
    
    
    //    taskStatus  0未通过 1已通过 2未参加 3参加中
    NSString *status;
    UIColor *color;
    if (userModel.taskStatus == 0)
    {
        status = @"未通过";
        color  = HEXRGB(0xf66060);
    }
    else if (userModel.taskStatus == 1)
    {
        status = @"已通过";
        color  = HEXRGB(0x47c1a8);
    }
    else if (userModel.taskStatus == 2)
    {
        status = @"未参加";
        color  = HEXRGB(0xff9d60);
    }
    else if (userModel.taskStatus == 3)
    {
        status = @"参加中";
    }
    
    self.statusLabel.text      = status;
    self.statusLabel.textColor = color;
}

@end
