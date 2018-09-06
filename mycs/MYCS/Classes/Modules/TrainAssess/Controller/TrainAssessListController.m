//
//  TrainAssessListController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/26.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TrainAssessListController.h"
#import "TrainAssessTableController.h"
#import "TaskFilteView.h"
#import "TrainSopDetailController.h"
#import "TrainCourseDetailController.h"
#import "WaitToDoTaskTool.h"
#import "TrainDetailCourseController.h"
#import "TrainDetailSopController.h"

@interface TrainAssessListController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *menuContent;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuBtns;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBarConst;
@property (nonatomic, strong) UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) TrainAssessTableController *courseVC;
@property (nonatomic, strong) TrainAssessTableController *sopVC;

@property (nonatomic, strong) TaskFilteView *taskFilteView;

@end

@implementation TrainAssessListController

- (void)addConstraints
{
    self.menuContent.translatesAutoresizingMaskIntoConstraints = NO;
    self.automaticallyAdjustsScrollViewInsets                     = NO;
    
    id menuContent = self.menuContent;
    
    NSString *hVFL = @"H:|-(0)-[menuContent]-(0)-|";
    NSString *vVFL = @"V:|-(64)-[menuContent(45)]";
    
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(menuContent)];
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(menuContent)];
    
    
    [self.view addConstraints:hConsts];
    [self.view addConstraints:vConsts];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.taskFilteView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.courseVC = [self.childViewControllers firstObject];
    self.sopVC    = [self.childViewControllers lastObject];

    self.selectBtn = [self.menuBtns firstObject];
    self.selectBtn.selected = NO;
    [self menuAction:self.selectBtn];
    
    [self.view layoutIfNeeded];

    [self setTaskListCellAction];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (iS_IOS10)
    {
        [self addConstraints];
    }
    
    if (self.selectBtn.tag == 0)
    {
        self.courseVC.type = AssessTypeTaskCourse;
    }else
    {
        self.sopVC.type = AssessTaskTypeSOP;

    }
}

#pragma mark - Action
- (IBAction)menuAction:(UIButton *)button
{
    [self.scrollView setScrollEnabled:YES];
    self.selectBtn.selected = NO;
    self.selectBtn          = button;
    self.selectBtn.selected      = YES;
    
    NSUInteger tag = button.tag;

    [UIView animateWithDuration:0.25 animations:^{

        self.scrollBarConst.constant = (self.view.width * 0.5) * tag;
        [self.view layoutIfNeeded];

        self.scrollView.contentOffset = CGPointMake(self.view.width * tag, 0);

    }completion:nil];
    
    if (tag == 0)
    {
        if (self.courseVC.dataBase.count == 0)
        {
            self.courseVC.type = AssessTypeTaskCourse;
        }
        
    }else if (tag == 1)
    {
        if (self.sopVC.dataBase.count == 0)
        {
            self.sopVC.type    = AssessTaskTypeSOP;
        }
    }
}

- (IBAction)BackAction:(UIBarButtonItem *)sender {
    [self.taskFilteView removeFromSuperview];

    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)rightBarButtonAction:(UIBarButtonItem *)sender {
    sender.enabled = NO;

    __block NSString *taskStatus;

    self.taskFilteView = [TaskFilteView showInView:self.navigationController.view belowView:self.navigationController.navigationBar action:^(NSUInteger idx) {

        if (idx == 0) //全部
        {
            taskStatus = @"";
        }
        else if (idx == 1) //未参加
        {
            taskStatus = @"2";
        }
        else if (idx == 2) //未达标
        {
            taskStatus = @"0";
        }
        else if (idx == 3) //已达标
        {
            taskStatus = @"1";
        }

        if (taskStatus)
        {
            __weak typeof(self) weakSelf = self;
            [weakSelf filtDataWith:taskStatus];
        }

        sender.enabled = YES;

    }];
    [self.navigationController.view addSubview:self.taskFilteView];
    [self.navigationController.view bringSubviewToFront:self.taskFilteView];
    [self addTaskFilteViewConstraints];
}
- (void)addTaskFilteViewConstraints
{
    self.taskFilteView.translatesAutoresizingMaskIntoConstraints = NO;
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    
    id taskFilteView = self.taskFilteView;
    id topLayoutGuide = self.navigationController.topLayoutGuide;
    
    NSString *hVFL = @"H:|-(0)-[taskFilteView]-(0)-|";
    
    NSString *vVFL = @"V:|-(-20)-[topLayoutGuide]-(0)-[taskFilteView]-(0)-|";
    
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(topLayoutGuide, taskFilteView)];
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(topLayoutGuide, taskFilteView)];
    
    [self.navigationController.view addConstraints:hConsts];
    [self.navigationController.view addConstraints:vConsts];
}

- (void)filtDataWith:(NSString *)status {
    NSUInteger idx = self.scrollView.contentOffset.x / self.view.width;

    TrainAssessTableController *trainAssessVC = self.childViewControllers[idx];

    trainAssessVC.taskStatus = status;
}


- (void)setTaskListCellAction {
    __weak typeof(self) weakSelf = self;

    self.courseVC.cellAction = ^(WaitToDoTask *model) {

        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"TrainAssess" bundle:nil];

        TrainDetailCourseController *courseVC = [storyBoard instantiateViewControllerWithIdentifier:@"DetailCourse"];
//        TrainCourseDetailController *courseVC = [storyBoard instantiateViewControllerWithIdentifier:@"CourseTaskDetail"];

        courseVC.courseId = model.courseId;
        courseVC.taskId   = model.taskId;

        [weakSelf.navigationController pushViewController:courseVC animated:YES];
    };

    self.sopVC.cellAction = ^(WaitToDoTask *model) {

        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"TrainAssess" bundle:nil];

        TrainDetailSopController *sopVC = [storyBoard instantiateViewControllerWithIdentifier:@"DetailSop"];
//        TrainSopDetailController *sopVC = [storyBoard instantiateViewControllerWithIdentifier:@"SOPTaskDetail"];
        sopVC.taskId                    = model.taskId;
        sopVC.SOPId                     = model.sopId;
        [weakSelf.navigationController pushViewController:sopVC animated:YES];
    };
}

#pragma mark - Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSUInteger page  = scrollView.contentOffset.x / self.view.width;
    UIButton *button = self.menuBtns[page];

    self.selectBtn.selected = NO;
    self.selectBtn          = button;

    [self menuAction:button];
}


@end
