//
//  TaskGovDetailViewController.m
//  MYCS
//
//  Created by yiqun on 16/5/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskGovDetailViewController.h"
#import "TaskModel.h"
#import "TaskDetailModel.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Util.h"
#import "NSMutableAttributedString+Attr.h"
#import "TaskNoticeUserController.h"
#import "ExamDeatilController.h"
#import "JoinInPersonnelViewController.h"
#import "JoinInHospitalViewController.h"

@interface TaskGovDetailViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollViews;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *btnMenu;

@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *passCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewWith;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewX;

@property (nonatomic, strong) TaskDetailModel *detailModel;

@property(retain,nonatomic)UIButton * selectBtn;

@property (retain,nonatomic)JoinInPersonnelViewController * joinInPersonnel;
@property (retain,nonatomic)JoinInHospitalViewController * joinInHospital;
@end

@implementation TaskGovDetailViewController

-(void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.viewWith.constant = CGRectGetWidth([UIScreen mainScreen].bounds)*2;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.joinInPersonnel = [self.childViewControllers firstObject];
    self.joinInHospital = [self.childViewControllers lastObject];
    self.joinInHospital.taskModel = self.taskModel;
    self.joinInHospital.sortType = self.sortType;
    
    self.title = self.taskModel.name;
    self.scrollViews.delegate = self;
    
    [self requestDataWith:self.taskModel.Id sortType:self.sortType];
    
    [self setCellClickAction];

}

- (void)setCellClickAction {

    __weak typeof(self) weakSelf = self;
    [self.joinInPersonnel setCellClickBlock:^(TaskJoinUserModel *model) {
        
        UIStoryboard *taskManageBoard = [UIStoryboard storyboardWithName:@"TaskManage" bundle:nil];
        ExamDeatilController *examDetailVC = [taskManageBoard instantiateViewControllerWithIdentifier:@"ExamDeatilController"];
        examDetailVC.employeeId = model.user_id;
        examDetailVC.taskId     = weakSelf.taskModel.Id;
        if ([weakSelf.sortType isEqualToString:@"common"])
        {
            examDetailVC.taskType = TaskTypeCommom;
        }
        else if ([weakSelf.sortType isEqualToString:@"sop"])
        {
            examDetailVC.taskType = TaskTypeSOP;
        }
        [weakSelf.navigationController pushViewController:examDetailVC animated:YES];
    }];
    
    [self.joinInHospital setCellClickBlock:^(TaskJoinHospitalModel *model) {
        
        UIStoryboard *taskManageBoard = [UIStoryboard storyboardWithName:@"TaskManage" bundle:nil];
        ExamDeatilController *examDetailVC = [taskManageBoard instantiateViewControllerWithIdentifier:@"ExamDeatilController"];
        examDetailVC.employeeId = model.uid;
        examDetailVC.taskId     = weakSelf.taskModel.Id;
        if ([weakSelf.sortType isEqualToString:@"common"])
        {
            examDetailVC.taskType = TaskTypeCommom;
        }
        else if ([weakSelf.sortType isEqualToString:@"sop"])
        {
            examDetailVC.taskType = TaskTypeSOP;
        }
        [weakSelf.navigationController pushViewController:examDetailVC animated:YES];
    }];
    
}
#pragma mark - Network
- (void)requestDataWith:(NSString *)taskId sortType:(NSString *)type {
    
    [self showLoadingHUD];
    
    [TaskDetailModel taskDetailWith:taskId memberTaskId:self.taskModel.memberTaskId sort:type success:^(TaskDetailModel *detailModel) {
        
        self.detailModel = detailModel;
    
        [self setContentWith:detailModel.detail];
        UIButton *btn = [self.btnMenu firstObject];
        [self bottonAction:btn];
        
    }
    failure:^(NSError *error) {
        [self dismissLoadingHUD];
    }];
}
#pragma mark - *** 代理 ***
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self.scrollViews) return;
    
    NSUInteger page = scrollView.contentOffset.x/[UIScreen mainScreen].bounds.size.width;
    
    UIButton *button = self.btnMenu[page];
    
    self.selectBtn.selected = NO;
    self.selectBtn = button;
    
    [self bottonAction:button];
    
}

- (IBAction)bottonAction:(UIButton *)sender {
    
    [self.scrollViews setScrollEnabled:YES];
    self.selectBtn.selected = NO;
    self.selectBtn = sender;
    NSUInteger tag = sender.tag;
    [UIView animateWithDuration:0.25 animations:^{
        self.selectBtn.selected = YES;
        
        self.lineViewX.constant = sender.frame.origin.x;
        
        [self.view layoutIfNeeded];
        
        self.scrollViews.contentOffset = CGPointMake(ScreenW*tag, 0);
        
    } completion:^(BOOL finished) {
        
        if (sender.tag == 0)
        {
            JoinInPersonnelViewController * infor = self.childViewControllers[0];
            infor.detailModel = self.detailModel;
        }
        if (sender.tag == 1) {
            
            JoinInHospitalViewController * hospital = self.childViewControllers[1];
            hospital.taskModel = self.taskModel;
            hospital.sortType = self.sortType;
            
        }
        
        [self dismissLoadingHUD];
    }];
}


#pragma mark - getter和setter
- (void)setDetailModel:(TaskDetailModel *)detailModel {
    _detailModel = detailModel;
    
    [self setContentWith:detailModel.detail];
    
}
//任务信息
- (void)setContentWith:(Detail *)detail {
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:detail.videoPic] placeholderImage:PlaceHolderImage];
    
    self.nameLabel.text = detail.taskName;
    
    NSString *endTime      = [NSDate dateWithTimeInterval:detail.endTime format:@"yyyy/MM/dd"];
    self.endTimeLabel.text = [NSString stringWithFormat:@"截止日期：%@", endTime];
    
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
    
    NSString *passStr = [NSString stringWithFormat:@"达标人数：%lu", (long)detail.passNum];
    
    NSRange range2                     = [passStr rangeOfString:@"达标人数："];
    self.passCountLabel.attributedText = [NSMutableAttributedString string:passStr value1:color range1:NSMakeRange(range2.length, passStr.length - range2.length) value2:nil range2:NSMakeRange(0, 0) font:12];
}
- (void)setupRightButtonItem {
    //只有状态未发布中、已发布才显示发送提醒
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"发送提醒" style:UIBarButtonItemStylePlain target:self action:@selector(noticeAction:)];
    //设置右边的按钮
    self.navigationItem.rightBarButtonItem = item;
}

#pragma mark - Action
- (IBAction)leftItemAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//发送提醒按钮
- (IBAction)noticeAction:(id)sender {
    UIStoryboard *taskManageBoard = [UIStoryboard storyboardWithName:@"TaskManage" bundle:nil];
    TaskNoticeUserController *destVC = [taskManageBoard instantiateViewControllerWithIdentifier:@"TaskNoticeUserController"];
    destVC.taskId                    = self.taskModel.Id;
    destVC.detailModel               = self.detailModel;
    destVC.sort                      = self.sortType;
    [self.navigationController pushViewController:destVC animated:YES];
}

@end
