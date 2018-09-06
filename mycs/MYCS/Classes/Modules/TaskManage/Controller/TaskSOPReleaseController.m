//
//  TaskSOPReleaseController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/14.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskSOPReleaseController.h"
#import "TaskCourseReleaseController.h"
#import "DatePickView.h"
#import "NSDate+Util.h"
#import "TaskDescViewController.h"
#import "NSString+Size.h"
#import "NSString+Util.h"
#import "TaskSelectVideoController.h"
#import "SopList.h"
#import "CourseList.h"
#import "TaskSelectDepartController.h"
#import "TaskObject.h"
#import "UIAlertView+Block.h"
#import "TaskRelease.h"
#import "sheetView.h"
#import "ChooseDeptsViewController.h"
#import "ChoosePersonsViewController.h"
#import "BDDynamicTreeNode.h"
#import "ServiceModel.h"
#import "StaffModel.h"
#import "sopDetailView.h"
#import "ReceiverModel.h"
#import "TaskSelectObjectController.h"

@interface TaskSOPReleaseController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableViewCell *titleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *sopCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *statTimeCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *descCell;

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *SOPTextField;
@property (weak, nonatomic) IBOutlet UITextField *startTimeTextField;
@property (weak, nonatomic) IBOutlet UITextField *timeTextField;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *objectTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descLabelTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *startTimeTextTrailing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sopTextTrailing;
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

@property (nonatomic, strong) sopDetailView *sopdetailView;
@property (nonatomic, assign) CGFloat sopCellHeight;

@property (nonatomic, strong) sheetView *sheet;
@end

@implementation TaskSOPReleaseController

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
    self.titleTextField.delegate = self;
    self.timeTextField.delegate  = self;

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
    [self.sheet removeFromSuperview];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)buildData:(M_taskModel *)detail;
{
    self.titleCell.userInteractionEnabled    = NO;
    self.sopCell.userInteractionEnabled      = NO;
    self.statTimeCell.userInteractionEnabled = NO;
    self.descCell.userInteractionEnabled = NO;
    
    self.titleTextField.text = detail.taskName;
    self.paramModel.title = detail.taskName;
    self.titleTextField.enabled = NO;
    self.SOPTextField.text      = detail.name;
    [self.sopdetailView removeFromSuperview];

    self.sopdetailView                        = [sopDetailView getSopDetailView];
    self.sopdetailView.userInteractionEnabled = NO;
    self.sopdetailView.width                  = ScreenW;
    self.sopdetailView.sopSourse              = detail.courseList;
    self.sopdetailView.y                      = 50;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
    UITableViewCell *cell  = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell.contentView addSubview:self.sopdetailView];
    if (detail.courseList.count == 0)
    {
        self.sopCellHeight = 0;
    }
    else
    {
        self.sopCellHeight = 20 + detail.courseList.count * 35;
    }

    self.sopdetailView.height = self.sopCellHeight;


    self.timeTextField.text         = [NSString stringWithFormat:@"%d", detail.usedTime];
    self.timeTextField.enabled      = NO;
    self.paramModel.dayCount        = self.timeTextField.text;
    self.paramModel.SOP             = detail.name;
    self.SOPTextField.enabled       = NO;
    self.startTimeTextField.text    = [NSDate dateWithTimeInterval:detail.issueTime format:@"yyyy-MM-dd"];
    self.paramModel.startTime       = self.startTimeTextField.text;
    self.startTimeTextField.enabled = NO;
    self.descLabel.text             = detail.note;
    self.descLabel.enabled          = NO;
    self.paramModel.desc            = detail.note;
    self.paramModel.memId           = self.model.memberTaskId;

    self.titleTextTrailing.constant = 7;
    self.sopTextTrailing.constant = 7;
    self.startTimeTextTrailing.constant = 7;
    self.descLabelTrailing.constant = 7;
    
    [self.tableView reloadData];
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
        self.SOPTextField.text = self.paramModel.SOP;
    }
    if (self.paramModel.startTime)
    {
        self.startTimeTextField.text = self.paramModel.startTime;
    }
    if (self.paramModel.dayCount)
    {
        self.timeTextField.text = self.paramModel.dayCount;
    }
    if (self.paramModel.desc)
    {
        self.descLabel.text = self.paramModel.desc;
    }
    if (self.objectList)
    {
        self.objectContentView.height = self.objViewH;
    }
}


- (IBAction)taskReleaseAction:(UIButton *)sender {
    if (![self validateParam]) return;

    sender.enabled = NO;

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

    [self showLoadingHUD];

    if (self.model != nil)
    { //表示机构任务进来

        [TaskRelease memberReleaseWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:@"sendMemberTask" memberTaskId:self.paramModel.memId sort:self.sortType deptId:self.paramModel.depId staffUid:self.paramModel.employeeId success:^(JSONModel *model) {

            [self dismissLoadingHUD];

            [self showSuccessWithStatusHUD:@"发布成功"];

            sender.enabled = YES;

            self.SureButtonBlock();

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                [self.navigationController popViewControllerAnimated:YES];
            });


        }
            failure:^(NSError *error) {
                [self dismissLoadingHUD];
                [self showError:error];
                sender.enabled = YES;
            }];
    }
    else
    { //表示任务管理进来

        if ([AppManager sharedManager].user.userType == UserType_company || ([AppManager sharedManager].user.userType == UserType_employee && [AppManager sharedManager].user.isAdmin.intValue == 1))
        { //发布sop任务

            NSString * actionStr;
            //agroup_id 是9的时候发布卫计委任务
            if ([AppManager sharedManager].user.agroup_id.intValue == 9 || [AppManager sharedManager].user.agroup_id.intValue == 10) {
                actionStr = @"sendSopTaskGov";
                
                [TaskRelease commissionSopReleaseWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:actionStr taskName:self.paramModel.title sopId:self.paramModel.courseId sopName:self.paramModel.SOP issueTime:self.paramModel.startTime usedTime:self.paramModel.dayCount deptId:self.paramModel.depId staffUid:self.paramModel.employeeId  hospUid:self.paramModel.hospUid note:self.paramModel.desc type:1 success:^(JSONModel *model) {
                    [self dismissLoadingHUD];
                    
                    [self showSuccessWithStatusHUD:@"发布成功"];
                    
                    sender.enabled = YES;
                    
                    self.SureButtonBlock();
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                } failure:^(NSError *error) {
                    [self dismissLoadingHUD];
                    [self showError:error];
                    sender.enabled = YES;
                }];
                
            }else{
                actionStr = @"sendSopTask";
                
                [TaskRelease sopReleaseWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:actionStr taskName:self.paramModel.title sopId:self.paramModel.courseId sopName:self.paramModel.SOP issueTime:self.paramModel.startTime usedTime:self.paramModel.dayCount deptId:self.paramModel.depId staffUid:self.paramModel.employeeId note:self.paramModel.desc type:1 success:^(JSONModel *model) {
                    
                    [self dismissLoadingHUD];
                    
                    [self showSuccessWithStatusHUD:@"发布成功"];
                    
                    sender.enabled = YES;
                    
                    self.SureButtonBlock();
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                    
                    
                }
                failure:^(NSError *error) {
                    [self dismissLoadingHUD];
                    [self showError:error];
                    sender.enabled = YES;
                }];
            }
        }
        else if ([AppManager sharedManager].user.userType == UserType_organization)
        {
            [TaskRelease sopMemberReleaseWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:@"agencySendSop" taskName:self.paramModel.title sopId:self.paramModel.courseId sopName:self.paramModel.SOP issueTime:self.paramModel.startTime usedTime:self.paramModel.dayCount gradeId:self.paramModel.depId staffUid:self.paramModel.employeeId note:self.paramModel.desc success:^(JSONModel *model) {

                [self dismissLoadingHUD];

                [self showSuccessWithStatusHUD:@"发布成功"];

                sender.enabled = YES;

                self.SureButtonBlock();

                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

                    [self.navigationController popViewControllerAnimated:YES];
                });


            }
                failure:^(NSError *error) {
                    [self dismissLoadingHUD];
                    [self showError:error];
                    sender.enabled = YES;
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
    else if (!self.paramModel.SOP)
    {
        [self showErrorMessage:@"请选择SOP!"];
        return NO;
    }
    else if (!self.paramModel.startTime)
    {
        [self showErrorMessage:@"请选择开始时间!"];
        return NO;
    }
    else if (!self.paramModel.dayCount)
    {
        [self showErrorMessage:@"请输入总时长!"];
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
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        return self.sopCellHeight + 50;
    }
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
    //选择SOP视频
    else if (indexPath.section == 1 && indexPath.row == 0)
    {
        if (self.model != nil) return;

        [self performSegueWithIdentifier:@"TaskSelectVideo" sender:nil];
    }
    //任务说明
    else if (indexPath.section == 3)
    {
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
                //选择对象
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
                controller.fromTask = YES;

                controller.selectMem = arr;

                controller.title = @"选择会员";

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
    //选择SOP视频
    else if ([segue.identifier isEqualToString:@"TaskSelectVideo"])
    {
        if (self.model != nil) return;

        TaskSelectVideoController *selectVC = segue.destinationViewController;
        selectVC.type                       = TaskSelectVideoTypeSOP;
        selectVC.completeBlock              = ^(Course *courseModel, Sop *sopModel) {

            self.SOPTextField.text   = sopModel.name;
            self.paramModel.SOP      = sopModel.name;
            self.paramModel.courseId = sopModel.sopId;
            self.paramModel.dayCount = sopModel.usedTime;
            self.timeTextField.text  = sopModel.usedTime;

            [self showSopDetail:sopModel.sopId];

        };
    }
}
- (void)showSopDetail:(NSString *)sopid {
    [self showLoadingHUD];
    [CourseOfSOP dataWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:@"getCourse" sopId:sopid success:^(NSArray *list) {

        [self.sopdetailView removeFromSuperview];

        self.sopdetailView                        = [sopDetailView getSopDetailView];
        self.sopdetailView.userInteractionEnabled = NO;
        self.sopdetailView.width                  = ScreenW;
        self.sopdetailView.sopSourse              = list;
        self.sopdetailView.y                      = 50;

        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
        UITableViewCell *cell  = [self.tableView cellForRowAtIndexPath:indexPath];
        [cell.contentView addSubview:self.sopdetailView];
        if (list.count == 0)
        {
            self.sopCellHeight = 0;
        }
        else
        {
            self.sopCellHeight = 20 + list.count * 35;
        }

        self.sopdetailView.height = self.sopCellHeight;

        [self.tableView reloadData];

        [self dismissLoadingHUD];

    }
        failure:^(NSError *error) {
            [self dismissLoadingHUD];
            [self showError:error];
        }];
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSString *text = [textField.text trimmingWhitespaceAndNewline];
    //任务标题
    if ([textField isEqual:self.titleTextField])
    {
        self.paramModel.title = text;
    }
    //总时长
    else if ([textField isEqual:self.timeTextField])
    {
        self.paramModel.dayCount = text;
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
    int t  = 0;
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
        objButton.tag             = t;

        t++;

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
        objButton.tag             = t;

        t++;

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


@implementation TaskObjectButton

- (void)layoutSubviews {
    [super layoutSubviews];

    self.titleLabel.x = 5;

    self.imageView.x      = (self.width - self.imageView.width) - 5;
    self.titleLabel.width = self.imageView.x - 5;
}

@end
