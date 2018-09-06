//
//  TaskCourseReleaseController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskCourseReleaseController.h"
#import "NSString+Util.h"
#import "DatePickView.h"
#import "TaskRelease.h"
#import "NSDate+Util.h"
#import "TaskDescViewController.h"
#import "NSString+Size.h"
#import "TaskSelectVideoController.h"
#import "CourseList.h"
#import "SopList.h"
#import "TaskSelectDepartController.h"
#import "TaskObject.h"
#import "TaskSOPReleaseController.h"
#import "UIAlertView+Block.h"
#import "sheetView.h"
#import "ChooseDeptsViewController.h"
#import "ChoosePersonsViewController.h"
#import "BDDynamicTreeNode.h"
#import "ServiceModel.h"
#import "StaffModel.h"
#import "ReceiverModel.h"
#import "TaskSelectObjectController.h"

@interface TaskCourseReleaseController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *descCell;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *courseTextField;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *passRateTextField;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *objectTextField;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabelTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *endTimeTextTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startTimeTextTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *courseTextTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleTextTrailing;

@property (nonatomic, strong) TaskReleaseParamModel *paramModel;

@property (nonatomic, strong) M_taskModel *detailModel;

@property (nonatomic, assign) CGFloat descCellHeight;

//任务对象数组
@property (nonatomic, strong) NSMutableArray *objectList;
//任务对象view
@property (weak, nonatomic) IBOutlet UIView *objectContentView;
//任务对象view的高
@property (nonatomic, assign) CGFloat objViewH;

@property (nonatomic, strong) NSArray *sheetTitleArray;
@property (nonatomic, strong) NSMutableArray *selectedDep; //部门数组
@property (strong, nonatomic) NSMutableArray *selectStaff; //会员或员工数组
@property (strong, nonatomic) NSMutableArray *sendMem;     //选中的会员数组
@property (strong, nonatomic) NSMutableArray *sendStaff;   //选中的员工数组

@property (nonatomic, strong) sheetView *sheet;

@end

@implementation TaskCourseReleaseController

- (NSMutableArray *)selectStaff {
    if (_selectStaff == nil)
    {
        _selectStaff = [NSMutableArray array];
    }
    return _selectStaff;
}

- (NSMutableArray *)selectedDep {
    if (_selectedDep == nil)
    {
        _selectedDep = [NSMutableArray array];
    }
    return _selectedDep;
}

- (NSMutableArray *)sendMem {
    if (_sendMem == nil)
    {
        _sendMem = [NSMutableArray array];
    }
    return _sendMem;
}

- (NSMutableArray *)sendStaff {
    if (_sendStaff == nil)
    {
        _sendStaff = [NSMutableArray array];
    }
    return _sendStaff;
}

- (NSMutableArray *)objectList {
    if (_objectList == nil)
    {
        _objectList = [NSMutableArray array];
    }
    return _objectList;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.sheet removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.descLabel.numberOfLines = 0;

    self.paramModel = [TaskReleaseParamModel new];

    if ([AppManager sharedManager].user.userType == UserType_organization)
    {
        self.sheetTitleArray = @[ @"按会员对象选择", @"按服务对象选择" ];
    }
    else if ([AppManager sharedManager].user.userType == UserType_company)
    {
        self.sheetTitleArray = @[ @"选择收件部门", @"选择收件人员" ];
    }

    if (self.model != nil)
    {
        [self requestDataWith:self.model.memberTaskId sortType:self.sortType];
    }
}
- (IBAction)backAction:(id)sender {
    self.passRateTextField.text = @"50";
    [self.view endEditing:YES];
    [self.sheet removeFromSuperview];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buildData:(M_taskModel *)detail;
{
    self.titleTextField.text        = detail.taskName;
    self.paramModel.title           = detail.taskName;
    self.titleTextField.enabled     = NO;
    self.courseTextField.text       = detail.name;
    self.paramModel.course          = detail.name;
    self.courseTextField.enabled    = NO;
    self.startTimeTextField.text    = [NSDate dateWithTimeInterval:detail.issueTime format:@"yyyy-MM-dd"];
    self.paramModel.startTime       = self.startTimeTextField.text;
    self.startTimeTextField.enabled = NO;
    self.endTimeTextField.text = [NSDate dateWithTimeInterval:detail.endTime format:@"yyyy-MM-dd"];
    self.paramModel.endTime = self.endTimeTextField.text;
    self.endTimeTextField.enabled = NO;
    self.passRateTextField.text = [NSString stringWithFormat:@"%d",detail.pass_rate];
    self.paramModel.passRate = self.passRateTextField.text;
    self.passRateTextField.enabled = NO;
    self.descLabel.text = detail.note;
    self.descLabel.enabled = NO;
    self.paramModel.desc = detail.note;
    self.paramModel.memId = self.model.memberTaskId;
    self.descCell.userInteractionEnabled = NO;
    
    self.titleTextTrailing.constant = 7;
    self.courseTextTrailing.constant = 7;
    self.startTimeTextTrailing.constant = 7;
    self.endTimeTextTrailing.constant = 7;
    self.descLabelTrailing.constant = 7;
    
}

- (void)setSortType:(NSString *)sortType {
    _sortType = sortType;
}

- (void)setModel:(TaskModel *)model {
    if (model == nil)
    {
        return;
    }
    _model = model;
}
#pragma mark - Network
- (void)requestDataWith:(NSString *)taskId sortType:(NSString *)type {
    [self showLoadingHUD];

    [M_taskModel memberTaskListWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:@"memberTask" memberTaskId:taskId sort:self.sortType success:^(M_taskModel *model) {

        self.detailModel = model;

        [self buildData:model];
        [self dismissLoadingHUD];

    }
        failure:^(NSError *error) {
            [self dismissLoadingHUD];
        }];
}

- (void)buildUI {
    if (self.paramModel.title)
    {
        self.titleTextField.text = self.paramModel.title;
    }
    if (self.paramModel.course)
    {
        self.courseTextField.text = self.paramModel.course;
    }
    if (self.paramModel.startTime)
    {
        self.startTimeTextField.text = self.paramModel.startTime;
    }
    if (self.paramModel.endTime)
    {
        self.endTimeTextField.text = self.paramModel.endTime;
    }
    if (self.paramModel.passRate)
    {
        self.passRateTextField.text = self.paramModel.passRate;
    }
    if (self.paramModel.desc)
    {
        self.descLabel.text = self.paramModel.desc;
    }
}
- (IBAction)taskReleaseAction:(UIButton *)button {
    if (![self validateParam]) return;

    [self showLoadingHUD];
    button.enabled = NO;

    if (self.selectStaff.count != 0 || self.selectedDep.count != 0)
    {
        self.paramModel.depId      = @"";
        self.paramModel.employeeId = @"";
        NSMutableArray *depArray   = [NSMutableArray array];
        NSMutableArray *userArray  = [NSMutableArray array];

        if (self.selectedDep.count > 0)
        {
            for (ReceiverModel *model in self.selectedDep)
            {
                [depArray addObject:model.userID];
            }

            self.paramModel.depId = [depArray componentsJoinedByString:@","];
        }

        if (self.selectStaff.count > 0)
        {
            for (ReceiverModel *model in self.selectStaff)
            {
                [userArray addObject:model.userID];
            }

            self.paramModel.employeeId = [userArray componentsJoinedByString:@","];
        }
    }

    if (self.model != nil)
    { //表示机构任务进来

        [TaskRelease memberReleaseWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:@"sendMemberTask" memberTaskId:self.paramModel.memId sort:self.sortType deptId:self.paramModel.depId staffUid:self.paramModel.employeeId success:^(JSONModel *model) {

            [self dismissLoadingHUD];

            [self showSuccessWithStatusHUD:@"发布成功"];

            button.enabled = YES;

            self.SureButtonBlock();

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [self.navigationController popViewControllerAnimated:YES];
            });

        }
            failure:^(NSError *error) {

                [self showError:error];
                button.enabled = YES;
                [self dismissLoadingHUD];
            }];
    }
    else
    { //表示任务管理进来

        if ([AppManager sharedManager].user.userType == UserType_company || ([AppManager sharedManager].user.userType == UserType_employee && [AppManager sharedManager].user.isAdmin.intValue == 1))
        { //发布普通任务

            NSString * actionStr;
            //agroup_id 是9的时候发布卫计委任务
            if ([AppManager sharedManager].user.agroup_id.intValue == 9 || [AppManager sharedManager].user.agroup_id.intValue == 10) {
                 actionStr = @"sendTaskGov";
                
                [TaskRelease commissionReleaseWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:actionStr taskName:self.paramModel.title courseId:self.paramModel.courseId courseName:self.paramModel.course issueTime:self.paramModel.startTime endTime:self.paramModel.endTime  hospUid:self.paramModel.hospUid passRate:self.paramModel.passRate.intValue deptId:self.paramModel.depId staffUid:self.paramModel.employeeId note:self.paramModel.desc type:1 success:^(JSONModel *model) {
                    
                    [self dismissLoadingHUD];
                    
                    [self showSuccessWithStatusHUD:@"发布成功"];
                    
                    button.enabled = YES;
                    
                    self.SureButtonBlock();
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                } failure:^(NSError *error) {
                    [self dismissLoadingHUD];
                    [self showError:error];
                    button.enabled = YES;
                }];
                
            }else{
                 actionStr = @"sendTask";
                
                [TaskRelease commonReleaseWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:actionStr taskName:self.paramModel.title courseId:self.paramModel.courseId courseName:self.paramModel.course issueTime:self.paramModel.startTime endTime:self.paramModel.endTime passRate:self.paramModel.passRate.intValue deptId:self.paramModel.depId staffUid:self.paramModel.employeeId note:self.paramModel.desc type:1 success:^(JSONModel *model) {
                    
                    [self dismissLoadingHUD];
                    
                    [self showSuccessWithStatusHUD:@"发布成功"];
                    
                    button.enabled = YES;
                    
                    self.SureButtonBlock();
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                }
                                             failure:^(NSError *error) {
                                                 [self dismissLoadingHUD];
                                                 [self showError:error];
                                                 button.enabled = YES;
                                             }];
            }
            
            
        }
        else if ([AppManager sharedManager].user.userType == UserType_organization)
        {
            [TaskRelease commonMemberReleaseWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:@"sendTask" taskName:self.paramModel.title courseId:self.paramModel.courseId courseName:self.paramModel.course issueTime:self.paramModel.startTime endTime:self.paramModel.endTime passRate:self.paramModel.passRate.intValue gradeId:self.paramModel.depId staffUid:self.paramModel.employeeId note:self.paramModel.desc type:3 success:^(JSONModel *model) {

                [self dismissLoadingHUD];

                [self showSuccessWithStatusHUD:@"发布成功"];

                button.enabled = YES;

                self.SureButtonBlock();

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    [self.navigationController popViewControllerAnimated:YES];
                });

            }
                failure:^(NSError *error) {
                    [self dismissLoadingHUD];
                    [self showError:error];
                    button.enabled = YES;
                }];
        }
    }
}

- (BOOL)validateParam {
    if (!self.paramModel.title)
    {
        [self showErrorMessage:@"请输入任务名称!"];
        return NO;
    }
    else if (!self.paramModel.course)
    {
        [self showErrorMessage:@"请选择教程!"];
        return NO;
    }
    else if (!self.paramModel.startTime)
    {
        [self showErrorMessage:@"请选择开始时间!"];
        return NO;
    }
    else if (!self.paramModel.endTime)
    {
        [self showErrorMessage:@"请选择结束时间!"];
        return NO;
    }
    else if (![self compareOneDay:self.paramModel.startTime withAnotherDay:self.paramModel.endTime])
    {
        [self showErrorMessage:@"发布任务时间与任务时间有冲突!"];
        return NO;
    }
    else if (!self.paramModel.passRate)
    {
        [self showErrorMessage:@"请输入通过指标!"];
        return NO;
    }
    else if (!self.paramModel.desc)
    {
        [self showErrorMessage:@"请输入任务说明!"];
        return NO;
    }
    else if (!self.objectList || self.objectList.count == 0)
    {
        [self showErrorMessage:@"请选择任务对象!"];

        return NO;
    }
    
    NSString *text = [self.paramModel.passRate trimmingWhitespaceAndNewline];
    
    int rate = [text intValue];
    
    if (rate<10||rate>100)
    {
        [self showErrorMessage:@"通过指标在10%~100%之间"];
        
        return NO;
    }
    
    return YES;
}

-(BOOL)compareOneDay:(NSString *)oneDayStr withAnotherDay:(NSString *)anotherDayStr
{
    NSDate *dateA = [NSDate dateWithString:oneDayStr format:@"yyyy-MM-dd"];
    NSDate *dateB = [NSDate dateWithString:anotherDayStr format:@"yyyy-MM-dd"];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) {
        return NO;
    }
    else if (result == NSOrderedAscending){
        return YES;
    }
    return YES;
    
}
#pragma mark - Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 3 && indexPath.row == 0)
    {
        return self.descCellHeight > 50 ? self.descCellHeight : 50;
    }
    if (indexPath.section == 4 && indexPath.row == 0)
    {
        return self.objViewH > 50 ? self.objViewH : 50;
    }

    return 50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ///  开始时间
    if (indexPath.section == 1 && indexPath.row == 1)
    {
        if (self.model != nil) return;

        [self.view endEditing:YES];

        [DatePickView showWith:UIDatePickerModeDate selectComplete:^(NSDate *selectDate) {
            self.paramModel.startTime    = [NSDate dateToString:selectDate format:@"yyyy-MM-dd"];
            self.startTimeTextField.text = self.paramModel.startTime;
        }];
    }
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        if (self.model != nil) return;

        [self performSegueWithIdentifier:@"TaskSelectVideo" sender:nil];
    }
    ///  结束时间
    else if (indexPath.section == 1 && indexPath.row == 2)
    {
        if (self.model != nil) return;

        [self.view endEditing:YES];

        [DatePickView showWith:UIDatePickerModeDate selectComplete:^(NSDate *selectDate) {
            self.paramModel.endTime    = [NSDate dateToString:selectDate format:@"yyyy-MM-dd"];
            self.endTimeTextField.text = self.paramModel.endTime;
        }];
    }
    else if (indexPath.section == 3)
    {
        if (self.model != nil) return;

        [self performSegueWithIdentifier:@"TaskDesc" sender:nil];
    }
    else if (indexPath.section == 4)
    {
        if ([AppManager sharedManager].user.userType == UserType_organization)
        {
            [self.sheet removeFromSuperview];

            self.sheet = [sheetView getSheetView];

            [self.sheet.firstBtn setTitle:self.sheetTitleArray[0] forState:UIControlStateNormal];
            [self.sheet.secondBtn setTitle:self.sheetTitleArray[1] forState:UIControlStateNormal];

            [self.sheet showView:self.navigationController andY:64 SheetBlock:^(sheetView *sheet, NSInteger buttonIndex) {

                [self selectReceiversWithIndex:buttonIndex];

            }];
        }
        else if ([AppManager sharedManager].user.userType == UserType_company || ([AppManager sharedManager].user.userType == UserType_employee && [AppManager sharedManager].user.isAdmin.intValue == 1))
        {
            if (self.model != nil)
            { //表示机构任务进来

                [self.sheet removeFromSuperview];

                self.sheet = [sheetView getSheetView];

                [self.sheet.firstBtn setTitle:self.sheetTitleArray[0] forState:UIControlStateNormal];
                [self.sheet.secondBtn setTitle:self.sheetTitleArray[1] forState:UIControlStateNormal];

                [self.sheet showView:self.navigationController andY:64 SheetBlock:^(sheetView *sheet, NSInteger buttonIndex) {

                    [self selectReceiversWithIndex:buttonIndex];

                }];
            }
            else
            {
//                TaskSelectDepartController
                
                TaskSelectObjectController *selectVC = [[UIStoryboard storyboardWithName:@"TaskManage" bundle:nil] instantiateViewControllerWithIdentifier:@"TaskSelectObjectController"];
                selectVC.isFirstCome = YES;
                [[AppDelegate sharedAppDelegate].rootNavi pushViewController:selectVC animated:YES];

                __weak typeof(self) VC  = self;
                selectVC.enterItemBlock = ^(NSArray *selectList) {

                    [VC.selectedDep removeAllObjects];

                    if (selectList.count == 0)
                    {
                        return;
                    }
                    NSMutableArray *arr = [NSMutableArray array];
                    NSMutableArray *arrBin = [NSMutableArray array];
                    for (TaskObject *model in selectList)
                    {
                        [arr addObject:[NSString stringWithFormat:@"%ld", (long)model.deptId]];
                        if (model.bindUid != 0) {
                            [arrBin addObject:[NSString stringWithFormat:@"%ld",(long)model.bindUid]];
                        }
                        
                        
                        ReceiverModel *obj = [[ReceiverModel alloc] init];
                        obj.userName       = model.deptName;
                        obj.userID         = [NSString stringWithFormat:@"%ld", (long)model.deptId];

                        [VC.selectedDep addObject:obj];
                    }
                    self.objViewH = [self buildObjectContentView];

                    [self.tableView reloadData];

                    self.paramModel.depId = [arr componentsJoinedByString:@","];
                    self.paramModel.hospUid = [arrBin componentsJoinedByString:@","];
                    
                };
            }
        }
    }
}

- (void)selectReceiversWithIndex:(NSInteger)index {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mailbox" bundle:nil];

    if ([AppManager sharedManager].user.userType == UserType_organization)
    {
        switch (index)
        {
            case 0:
            {
                ChoosePersonsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChoosePersonsViewController"];

                controller.isMember = YES;

                NSMutableArray *arr = [NSMutableArray array];

                for (Mem *men in self.sendMem)
                {
                    for (ReceiverModel *model in self.selectStaff)
                    {
                        if ([men.uid isEqualToString:model.userID])
                        {
                            [arr addObject:men];
                        }
                    }
                }
                controller.fromTask  = YES;
                controller.selectMem = arr;
                controller.title     = @"选择会员";

                [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];

                __weak typeof(self) VC  = self;
                controller.sureBtnBlock = ^(NSArray *results, int type) {

                    [VC.sendMem removeAllObjects];
                    [VC.selectStaff removeAllObjects];

                    for (Mem *mem in results)
                    {
                        ReceiverModel *receiver = [[ReceiverModel alloc] init];

                        receiver.userName = mem.name;
                        receiver.userID   = mem.id;

                        [VC.sendMem addObject:mem];
                        [VC.selectStaff addObject:receiver];
                    }

                    self.objViewH = [self buildObjectContentView];

                    [self.tableView reloadData];

                };
            }
            break;
            case 1:
            {
                ChooseDeptsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChooseDeptsViewController"];

                controller.isMember  = YES;
                controller.selectDep = self.selectedDep;
                controller.title     = @"选择服务";

                [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];

                __weak typeof(self) VC  = self;
                controller.sureBtnBlock = ^(NSArray *results, int type) {

                    [VC.selectedDep removeAllObjects];

                    [self.selectedDep removeAllObjects];

                    for (BDDynamicTreeNode *node in results)
                    {
                        ReceiverModel *receiver = [[ReceiverModel alloc] init];
                        receiver.userName       = node.name;
                        receiver.userID         = node.nodeId;

                        [VC.selectedDep addObject:receiver];
                    }

                    self.objViewH = [self buildObjectContentView];

                    [self.tableView reloadData];
                };
            }
            break;
            default:
                break;
        }
    }
    else
    {
        switch (index)
        {
            case 0:
            {
                ChooseDeptsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChooseDeptsViewController"];

                controller.selectDep = self.selectedDep;
                controller.title     = @"选择部门";

                [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];

                __weak typeof(self) VC  = self;
                controller.sureBtnBlock = ^(NSArray *results, int type) {

                    [VC.selectedDep removeAllObjects];

                    [VC.selectedDep removeAllObjects];

                    for (BDDynamicTreeNode *node in results)
                    {
                        ReceiverModel *receiver = [[ReceiverModel alloc] init];
                        receiver.userName       = node.name;
                        receiver.userID         = node.nodeId;
                        [VC.selectedDep addObject:receiver];
                    }

                    self.objViewH = [self buildObjectContentView];

                    [self.tableView reloadData];
                };
            }
            break;
            case 1:
            {
                ChoosePersonsViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ChoosePersonsViewController"];

                NSMutableArray *arr = [NSMutableArray array];

                for (StaffModel *staff in self.sendStaff)
                {
                    for (ReceiverModel *model in self.selectStaff)
                    {
                        if ([staff.uid isEqualToString:model.userID])
                        {
                            [arr addObject:staff];
                        }
                    }
                }

                controller.selectStaff = arr;
                controller.title       = @"选择员工";

                [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];

                __weak typeof(self) VC  = self;
                controller.sureBtnBlock = ^(NSArray *results, int type) {

                    [VC.selectStaff removeAllObjects];
                    [VC.sendStaff removeAllObjects];

                    for (StaffModel *staffModel in results)
                    {
                        ReceiverModel *receiver = [[ReceiverModel alloc] init];

                        receiver.userName = staffModel.realname;
                        receiver.userID   = staffModel.uid;

                        [VC.sendStaff addObject:staffModel];
                        [VC.selectStaff addObject:receiver];
                    }

                    self.objViewH = [self buildObjectContentView];

                    [self.tableView reloadData];

                };
            }
            break;
            default:
                break;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    //任务说明
    if ([segue.identifier isEqualToString:@"TaskDesc"])
    {
        TaskDescViewController *destVC = segue.destinationViewController;
        if (self.paramModel.desc)
        {
            destVC.descString = self.paramModel.desc;
        }
        destVC.editCompleteBlock = ^(NSString *desc) {

            self.paramModel.desc     = desc;
            self.descLabel.textColor = HEXRGB(0x666666);

            self.descCellHeight = [desc heightWithFont:[UIFont systemFontOfSize:13] constrainedToWidth:self.descLabel.width] + 20;

            [self.tableView reloadData];

            [self buildUI];

        };
    }
    //选择视频模板
    else if ([segue.identifier isEqualToString:@"TaskSelectVideo"])
    {
        if (self.model != nil) return;

        TaskSelectVideoController *selectVC = segue.destinationViewController;
        selectVC.type                       = TaskSelectVideoTypeCommon;
        selectVC.completeBlock              = ^(Course *courseModel, Sop *sopModel) {

            self.courseTextField.text = courseModel.name;
            self.paramModel.course    = courseModel.name;
            self.paramModel.courseId  = courseModel.courseId;
        };
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([textField isEqual:self.passRateTextField])
    {
        NSString *text = [textField.text trimmingWhitespaceAndNewline];

        int rate = [text intValue];

        if (rate < 10 || rate > 100)
        {
            textField.text = nil;
            [self showErrorMessage:@"通过指标在10%~100%之间"];
            [textField becomeFirstResponder];
            
            return YES;
        }
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = [textField.text trimmingWhitespaceAndNewline];
    //任务标题
    if ([textField isEqual:self.titleTextField])
    {
        self.paramModel.title = text;
    }
    //任务通过率
    else if ([textField isEqual:self.passRateTextField])
    {
        self.paramModel.passRate = text;
    }
}

- (CGFloat)buildObjectContentView {
    [self.objectContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    CGFloat margin  = 5;
    CGFloat buttonW = (self.objectContentView.width - 3 * margin) / 2;
    CGFloat buttonH = 30;

    CGFloat maxY = 0;

    [self.objectList removeAllObjects];

    [self.objectList addObjectsFromArray:self.selectedDep];
    [self.objectList addObjectsFromArray:self.selectStaff];

    if (self.selectedDep.count != 0)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 13, 300, 20)];
        label.font     = [UIFont systemFontOfSize:14];
        if ([AppManager sharedManager].user.userType == UserType_organization)
        {
            label.text = [NSString stringWithFormat:@"共选择%d类服务", (int)self.selectedDep.count];
        }
        else if ([AppManager sharedManager].user.userType == UserType_company || ([AppManager sharedManager].user.userType == UserType_employee && [AppManager sharedManager].user.isAdmin.intValue == 1))
        {
            label.text = [NSString stringWithFormat:@"共选择%d个部门", (int)self.selectedDep.count];
        }

        [self.objectContentView addSubview:label];
    }


    int jj = 0;

    for (int i = 0; i < self.selectedDep.count; i++)
    {
        ReceiverModel *taskObject   = self.selectedDep[i];
        TaskObjectButton *objButton = [TaskObjectButton buttonWithType:UIButtonTypeCustom];
        [self.objectContentView addSubview:objButton];

        int col = jj % 2; //列
        int row = jj / 2; //行

        if (self.selectedDep.count != 0)
        {
            row++;
        }


        CGFloat buttonX = margin + (buttonW + margin) * col;
        CGFloat buttonY = margin + (buttonH + margin) * row;

        objButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);

        //button的最大Y
        maxY = CGRectGetMaxY(objButton.frame);

        //属性设置
        [objButton setTitle:taskObject.userName forState:UIControlStateNormal];
        [objButton setImage:[UIImage imageNamed:@"back_del"] forState:UIControlStateNormal];
        [objButton setTitleColor:HEXRGB(0x999999) forState:UIControlStateNormal];
        objButton.titleLabel.font = [UIFont systemFontOfSize:13];
        objButton.tag             = i;

        [objButton addTarget:self action:@selector(objectButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        objButton.layer.borderColor   = HEXRGB(0x999999).CGColor;
        objButton.layer.borderWidth   = 0.5;
        objButton.layer.cornerRadius  = 4;
        objButton.layer.masksToBounds = YES;

        jj++;
    }

    if (self.selectStaff.count != 0)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, maxY + 8, 300, 20)];
        label.font     = [UIFont systemFontOfSize:14];
        if ([AppManager sharedManager].user.userType == UserType_organization)
        {
            label.text = [NSString stringWithFormat:@"共选择%d个会员", (int)self.selectStaff.count];
        }
        else if ([AppManager sharedManager].user.userType == UserType_company)
        {
            label.text = [NSString stringWithFormat:@"共选择%d个员工", (int)self.selectStaff.count];
        }

        [self.objectContentView addSubview:label];

        jj++;
    }

    if (self.selectedDep.count > 0)
    {
        if (self.selectedDep.count % 2 != 0)
        {
            jj++;
        }
        jj++;
    }
    else
    {
        jj = 0;
    }

    for (int i = 0; i < self.selectStaff.count; i++)
    {
        ReceiverModel *taskObject   = self.selectStaff[i];
        TaskObjectButton *objButton = [TaskObjectButton buttonWithType:UIButtonTypeCustom];
        [self.objectContentView addSubview:objButton];

        int col = jj % 2; //列
        int row = jj / 2; //行

        if (self.selectStaff.count != 0)
        {
            row++;
        }


        CGFloat buttonX = margin + (buttonW + margin) * col;
        CGFloat buttonY = margin + (buttonH + margin) * row;

        objButton.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);

        //button的最大Y
        maxY = CGRectGetMaxY(objButton.frame);

        //属性设置
        [objButton setTitle:taskObject.userName forState:UIControlStateNormal];
        [objButton setImage:[UIImage imageNamed:@"back_del"] forState:UIControlStateNormal];
        [objButton setTitleColor:HEXRGB(0x999999) forState:UIControlStateNormal];
        objButton.titleLabel.font = [UIFont systemFontOfSize:13];
        objButton.tag             = i;

        [objButton addTarget:self action:@selector(objectButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        objButton.layer.borderColor   = HEXRGB(0x999999).CGColor;
        objButton.layer.borderWidth   = 0.5;
        objButton.layer.cornerRadius  = 4;
        objButton.layer.masksToBounds = YES;

        jj++;
    }


    return maxY + margin;
}
#pragma mark - Action
- (void)objectButtonAction:(TaskObjectButton *)button {
    ReceiverModel *obj = self.objectList[button.tag];

    NSString *tips = [NSString stringWithFormat:@"是否删除对象\" %@ \"", obj.userName];

    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"系统提示" message:tips cancelButtonTitle:@"取消" otherButtonTitle:@"确定"];

    [alerView showUsingBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {

        //确定
        if (buttonIndex == 1)
        {
            [self.objectList removeObject:obj];
            [self.selectedDep removeObject:obj];
            [self.selectStaff removeObject:obj];
            self.objViewH = [self buildObjectContentView];
            [self.tableView reloadData];
        }

    }];
}


@end

@implementation TaskReleaseParamModel


@end
