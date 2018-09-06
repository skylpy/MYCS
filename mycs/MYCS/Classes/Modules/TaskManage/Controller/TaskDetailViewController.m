//
//  TaskDetailViewController.m
//  MYCS
//  任务详细信息
//  Created by AdminZhiHua on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "TaskModel.h"
#import "TaskDetailModel.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Util.h"
#import "NSMutableAttributedString+Attr.h"
#import "TaskNoticeUserController.h"
#import "ExamDeatilController.h"
#import "NSMutableAttributedString+Attr.h"


static NSString *const reuseID = @"TaskUserListCell";

@interface TaskDetailViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *passCountLabel;

@property (nonatomic, strong) TaskDetailModel *detailModel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;

//发送提醒
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sendNotiButtomItem;


@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = self.taskModel.name;

    self.tableView.tableFooterView = [UIView new];

    [self requestDataWith:self.taskModel.Id sortType:self.sortType];
}

- (void)setupRightButtonItem {
    //只有状态未发布中、已发布才显示发送提醒
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发送提醒" style:UIBarButtonItemStylePlain target:self action:@selector(noticeAction:)];
    //设置右边的按钮
    self.navigationItem.rightBarButtonItem = item;
}

//任务信息
- (void)setContentWith:(Detail *)detail {
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:detail.videoPic] placeholderImage:PlaceHolderImage];

    self.nameLabel.text = detail.taskName;

    NSString *endTime      = [NSDate dateWithTimeInterval:detail.endTime format:@"yyyy/MM/dd"];
    self.passCountLabel.text = [NSString stringWithFormat:@"截止日期：%@", endTime];

    //    status        0未发布  1已发布  2已过期  3系统发布中  -1已删除  4任务终止
    NSString *status;
    UIColor *color;

    if (detail.status == 0)
    {
        status = @"状       态：未发布";
    }
    else if (detail.status == 1)
    {
        status = @"状       态：已发布";
        [self setupRightButtonItem];
    }
    else if (detail.status == 2)
    {
        status = @"状       态：已过期";
    }
    else if (detail.status == 3)
    {
        status = @"状       态：发布中";
        [self setupRightButtonItem];
    }
    else if (detail.status == 4)
    {
        status = @"状       态：任务终止";
    }
    else if (detail.status == -1)
    {
        status = @"状       态：已删除";
    }
    color = HEXRGB(0x47c1a8);

    NSRange range                   = [status rangeOfString:@"状       态："];
    self.statusLabel.attributedText = [NSMutableAttributedString string:status value1:color range1:NSMakeRange(range.length, status.length - range.length) value2:nil range2:NSMakeRange(0, 0) font:12];

    NSString *passStr = [NSString stringWithFormat:@"已通过 %lu 人", (long)detail.passNum];
    
    self.passLabel.attributedText = [NSMutableAttributedString relaTransitionString:passStr andStr:[NSString stringWithFormat:@"%lu",(long)detail.passNum]];
//
//    NSRange range2                     = [passStr rangeOfString:@"达标人数："];
//    self.passCountLabel.attributedText = [NSMutableAttributedString string:passStr value1:color range1:NSMakeRange(range2.length, passStr.length - range2.length) value2:nil range2:NSMakeRange(0, 0) font:12];
}

#pragma mark - Action
- (IBAction)leftItemAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//发送提醒按钮
- (IBAction)noticeAction:(id)sender {
    [self performSegueWithIdentifier:@"TaskNotice" sender:nil];
}
//tableview cell的点击
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"TaskNotice"])
    {
        TaskNoticeUserController *destVC = segue.destinationViewController;
        destVC.taskId                    = self.taskModel.Id;
        destVC.detailModel               = self.detailModel;
        destVC.sort                      = self.sortType;
    }
    else if ([segue.identifier isEqualToString:@"ExamDeatil"])
    {
        TaskUserListCell *cell             = (TaskUserListCell *)sender;
        ExamDeatilController *examDetailVC = segue.destinationViewController;

        examDetailVC.employeeId = cell.userModel.user_id;
        examDetailVC.taskId     = self.taskModel.Id;
        if ([self.sortType isEqualToString:@"common"])
        {
            examDetailVC.taskType = TaskTypeCommom;
        }
        else if ([self.sortType isEqualToString:@"sop"])
        {
            examDetailVC.taskType = TaskTypeSOP;
        }
    }
}

#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.detailModel.user.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TaskUserListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];

    TaskJoinUserModel *userModel = self.detailModel.user.list[indexPath.row];

    cell.userModel = userModel;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Network
- (void)requestDataWith:(NSString *)taskId sortType:(NSString *)type {
    [self showLoadingHUD];
    [TaskDetailModel taskDetailWith:taskId memberTaskId:self.taskModel.memberTaskId sort:type success:^(TaskDetailModel *detailModel) {

        self.detailModel = detailModel;
        [self dismissLoadingHUD];

    }
        failure:^(NSError *error) {
            [self dismissLoadingHUD];
        }];
}

#pragma mark - getter和setter
- (void)setDetailModel:(TaskDetailModel *)detailModel {
    _detailModel = detailModel;

    [self setContentWith:detailModel.detail];

    [self.tableView reloadData];
}

@end

@interface TaskUserListCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation TaskUserListCell

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
