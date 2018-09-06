//
//  AssessHomeViewController.m
//  MYCS
//
//  Created by Yell on 16/1/12.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AssessHomeViewController.h"
#import "AssessCourseTaskDetailViewController.h"
#import "AssessSOPTaskDetailViewController.h"
#import "AssessTaskTableView.h"
#import "AssessHomeSiftView.h"

@interface AssessHomeViewController ()<UIScrollViewDelegate,AssessHomeSiftViewDelegate,AssessTaskTableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *BaseView;
@property (weak, nonatomic) IBOutlet UIButton *courseBtn;
@property (weak, nonatomic) IBOutlet UIButton *SOPBtn;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorLeftConstraint;
@property (weak, nonatomic) IBOutlet UIScrollView *baseScrollView;
@property (strong,nonatomic) AssessHomeSiftView * siftView;
@property (weak, nonatomic) IBOutlet AssessTaskTableView *courseTaskTableView;
@property (weak, nonatomic) IBOutlet AssessTaskTableView *SOPTaskTableView;
@property (assign,nonatomic) AssessHomeSiftType listType;
@property (weak,nonatomic) UIButton * selectedBtn;

@end

@implementation AssessHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.baseScrollView.delegate = self;
    self.selectedBtn = self.courseBtn;
    
    self.courseTaskTableView.type = AssessTypeTaskCourse;
    self.courseTaskTableView.taskDelegate = self;
    
    self.SOPTaskTableView.type = AssessTaskTypeSOP;
    self.SOPTaskTableView.taskDelegate = self;
    
    [self.courseTaskTableView BeginRefreshing];
    [self.SOPTaskTableView BeginRefreshing];
    
    UIBarButtonItem * btn = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"home"] style:UIBarButtonItemStylePlain target:self action:@selector(addToSiftView)];
    self.navigationItem.rightBarButtonItem = btn;

}


-(void)addToSiftView
{
    if (self.siftView != nil)
    {
        [self.siftView removeFromSuperview];
        return;
    }
    
    self.siftView = [[AssessHomeSiftView alloc]initWithType:self.listType];
    self.siftView.delegate = self;
    self.siftView.frame = self.BaseView.bounds ;
    [self.BaseView addSubview:self.siftView];
    
}



- (IBAction)chooseCourseAction:(UIButton *)sender {
    if (!sender.isSelected) {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.baseScrollView setContentOffset:CGPointMake(self.courseTaskTableView.x, self.courseTaskTableView.y) animated:YES];
            self.colorLeftConstraint.constant = self.courseBtn.x;
            self.colorView.x = self.courseBtn.x;
        }];
        
    }
}

- (IBAction)chooseSOPAction:(UIButton *)sender {
    if (!sender.isSelected) {
        self.selectedBtn.selected = NO;
        sender.selected = YES;
        self.selectedBtn = sender;
        [UIView animateWithDuration:0.3 animations:^{
            
            [self.baseScrollView setContentOffset:CGPointMake(self.SOPTaskTableView.x, self.SOPTaskTableView.y) animated:YES];
            self.colorLeftConstraint.constant = self.SOPBtn.x;
            self.colorView.x = self.SOPBtn.x;
        }];
        
    }
}





-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    if (scrollView.contentOffset.x == self.courseTaskTableView.x) {
        if (self.selectedBtn == self.courseBtn)
            return;
        else
        {
            self.courseBtn.selected = YES;
            self.selectedBtn.selected = NO;
            self.selectedBtn = self.courseBtn;
        }

        [UIView animateWithDuration:0.3 animations:^{
            self.colorLeftConstraint.constant = self.courseBtn.x;
            self.colorView.x = self.courseBtn.x;
        }];
    }else if (scrollView.contentOffset.x == self.SOPTaskTableView.x)
    {
        
        if (self.selectedBtn == self.SOPBtn)
            return;
        else
        {
            self.SOPBtn.selected = YES;
            self.selectedBtn.selected = NO;
            self.selectedBtn = self.SOPBtn;
        }
        
        [UIView animateWithDuration:0.3 animations:^{
            self.colorLeftConstraint.constant = self.SOPBtn.x;
            self.colorView.x = self.SOPBtn.x;
        }];
        
    }
}

-(void)AssessHomeSiftView:(AssessHomeSiftView *)view WithType:(AssessHomeSiftType)type
{
    self.listType = type;
    [view removeFromSuperview];

}

-(void)AssessTaskTableView:(AssessTaskTableView *)view cellDidSelectWithModel:(WaitToDoTask *)model type:(AssessTaskType)type
{
    if (type == AssessTypeTaskCourse)
    {
        
         AssessCourseTaskDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Assess" bundle:nil]instantiateViewControllerWithIdentifier:@"AssessCourseTaskDetailViewController"];
        vc.model = model;
    
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
    }
    else if (type == AssessTaskTypeSOP)
    {
        
        AssessSOPTaskDetailViewController *vc = [[UIStoryboard storyboardWithName:@"Assess" bundle:nil]instantiateViewControllerWithIdentifier:@"AssessSOPTaskDetailViewController"];
        vc.model = model;

        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
    }
    
}


-(void)setListType:(AssessHomeSiftType)listType
{
    NSString * listTypeStr;
    switch (listType) {
        case AssessHomeSiftTypeAll:
            listTypeStr = nil;
            break;
        case AssessHomeSiftTypeNoPass:
            listTypeStr = @"0";
            break;
        case AssessHomeSiftTypePass:
            listTypeStr = @"1";
            break;
        case AssessHomeSiftTypeEnd:
            listTypeStr = @"2";
            break;
        default:
            break;
    }
    
    self.courseTaskTableView.taskStatus = listTypeStr;
    self.SOPTaskTableView.taskStatus = listTypeStr;
    [self.courseTaskTableView BeginRefreshing];
    [self.SOPTaskTableView BeginRefreshing];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
