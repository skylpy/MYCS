//
//  ExamDeatilController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/20.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ExamDeatilController.h"
#import "TaskExamDeatilModel.h"
#import "NSString+Size.h"
#import "TaskChapterView.h"

static NSString *const reuseId = @"ExamDetailCell";
static NSString *const itemReuseId = @"ItemCell";

@interface ExamDeatilController ()

@property (weak, nonatomic) IBOutlet UILabel *ExamUserLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) TaskExamDeatilModel *model;

@end

@implementation ExamDeatilController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(expandData) name:@"expandDetail" object:nil];
    
    [self loadData];
}
-(void)expandData
{
    [self configSubViewWith:self.model];
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - NetWork
- (void)loadData {
    
    [self showLoadingHUD];
    
    [TaskExamDeatilModel employeeTestDetailWith:self.taskId taskType:self.taskType employeeId:self.employeeId success:^(TaskExamDeatilModel *model) {
        
        self.model = model;
        
        [self dismissLoadingHUD];
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        [self showError:error];
        
    }];
    
}

#pragma mark - Getter和Setter
- (void)setModel:(TaskExamDeatilModel *)model {
    _model = model;
    
    self.ExamUserLabel.text = [NSString stringWithFormat:@"参考人员：%@",model.userName];
    
    [self configSubViewWith:model];
    
}

- (void)configSubViewWith:(TaskExamDeatilModel *)model {
    
    for (TaskCourseView * view in self.scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    CGFloat viewY = 0;
    for (int i = 0; i<model.courseList.count; i++)
    {
        TaskCourseList *taskCourse = model.courseList[i];
        
        TaskCourseView *courseView = [TaskCourseView new];
        [self.scrollView addSubview:courseView];
        courseView.index = i;
        
        CGFloat viewHeight = [courseView heightWith:taskCourse];
        
        courseView.frame = CGRectMake(0, viewY, ScreenW, viewHeight);
        viewY += viewHeight;
    }
    
    self.scrollView.contentSize = CGSizeMake(0, viewY);
}

@end




