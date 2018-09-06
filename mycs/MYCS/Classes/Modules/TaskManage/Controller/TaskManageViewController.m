//
//  TaskManageViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskManageViewController.h"
#import "UIView+LineView.h"
#import "TaskTableViewController.h"
#import "CoverView.h"
#import "TaskModel.h"
#import "TaskDetailViewController.h"
#import "TaskCourseReleaseController.h"
#import "TaskSOPReleaseController.h"

#import "TaskGovDetailViewController.h"

@interface TaskManageViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *menuContent;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuBtns;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBarConst;
@property (nonatomic,strong) UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) TaskTableViewController *commonVC;
@property (nonatomic,strong) TaskTableViewController *sopVC;

@property (nonatomic,strong) UIView *itemView;
@property (nonatomic,strong) NSArray *items;
@property (nonatomic,strong) NSArray * orgTaskItems;

@property (nonatomic,strong) CoverView *coverView;

@property (strong, nonatomic) UIBarButtonItem *newsBarItem;

@property (assign,nonatomic) NSInteger indexTag;

@property (retain,nonatomic) NSString * commonStr;
@property (retain,nonatomic) NSString * sopStr;
@end

@implementation TaskManageViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.coverView dismiss];
    [self.itemView removeFromSuperview];
    
    [UMAnalyticsHelper endLogPageName:self.title];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [UMAnalyticsHelper beginLogPageName:self.title];
    if (iS_IOS10)
    {
        [self addConstraints];
    }
}
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view layoutIfNeeded];
    
    self.commonVC = [self.childViewControllers firstObject];
    self.sopVC = [self.childViewControllers lastObject];
    
    self.commonVC.isOrgTask = self.isOrgTask;
    self.sopVC.isOrgTask = self.isOrgTask;
    
    if (self.isOrgTask)
    {
        self.commonVC.type = 3;
        self.sopVC.type = 3;
        self.title = @"机构任务";
        
        self.commonStr = @"全部";
        self.sopStr = @"全部";
        self.newsBarItem  = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStyleDone target:self action:@selector(newAction:)];
        self.navigationItem.rightBarButtonItem = self.newsBarItem;
        
    }else
    {
        self.commonVC.type = 1;
        self.sopVC.type = 1;
        self.title = @"任务管理";
        
        self.newsBarItem  = [[UIBarButtonItem alloc] initWithTitle:@"新建" style:UIBarButtonItemStyleDone target:self action:@selector(newAction:)];
        self.navigationItem.rightBarButtonItem = self.newsBarItem;
    }
    
    self.commonVC.sortType = @"common";
    self.sopVC.sortType = @"sop";
    
    UIButton *button = [self.menuBtns firstObject];
    [self menuAction:button];
    
    [self addLineToMenuContent];
    
    [self setCellClickAction];
    
}

- (void)setCellClickAction {
    
    __weak typeof(self) weakSelf = self;
    self.commonVC.CellClickBlock = ^(TaskModel *model,NSString *sortType){
        
        if ([AppManager sharedManager].user.agroup_id.intValue == 9 || [AppManager sharedManager].user.agroup_id.intValue == 10) {
            
            UIStoryboard *taskManageBoard = [UIStoryboard storyboardWithName:@"TaskManage" bundle:nil];
            TaskGovDetailViewController *detailVC = [taskManageBoard instantiateViewControllerWithIdentifier:@"TaskGovDetailViewController"];
            detailVC.taskModel = model;
            detailVC.sortType = sortType;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        }else{
        
            UIStoryboard *taskManageBoard = [UIStoryboard storyboardWithName:@"TaskManage" bundle:nil];
            TaskDetailViewController *detailVC = [taskManageBoard instantiateViewControllerWithIdentifier:@"TaskDetailViewController"];
            detailVC.taskModel = model;
            detailVC.sortType = sortType;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        }
    };
    self.sopVC.CellClickBlock = ^(TaskModel *model,NSString *sortType){
        
        if ([AppManager sharedManager].user.agroup_id.intValue == 9 || [AppManager sharedManager].user.agroup_id.intValue == 10) {
            
            UIStoryboard *taskManageBoard = [UIStoryboard storyboardWithName:@"TaskManage" bundle:nil];
            TaskGovDetailViewController *detailVC = [taskManageBoard instantiateViewControllerWithIdentifier:@"TaskGovDetailViewController"];
            detailVC.taskModel = model;
            detailVC.sortType = sortType;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
        }else{
        
            UIStoryboard *taskManageBoard = [UIStoryboard storyboardWithName:@"TaskManage" bundle:nil];
            TaskDetailViewController *detailVC = [taskManageBoard instantiateViewControllerWithIdentifier:@"TaskDetailViewController"];
            detailVC.taskModel = model;
            detailVC.sortType = sortType;
            [weakSelf.navigationController pushViewController:detailVC animated:YES];
            
        }
        
    };
}

- (void)addLineToMenuContent {
    
    CALayer *lineLayer = [CALayer new];
    
    [self.menuContent.layer addSublayer:lineLayer];
    
    lineLayer.backgroundColor = HEXRGB(0xeeeeee).CGColor;
    
    lineLayer.frame = CGRectMake(0, self.menuContent.height-1, ScreenW, 1);
}

- (void)newAction:(UIBarButtonItem *)sender {
    
    sender.enabled = NO;
    
    __weak typeof(self) weakSelf = self;
    
    self.coverView = [CoverView showInView:self.view frame:self.view.bounds touchBlock:^(CoverView *view) {
        
        [weakSelf itemViewDismissAnimation:sender complete:nil];
        
    }];
    
    [self itemViewShowAnimation];
}

- (void)itemViewShowAnimation {
    
    [self.navigationController.view insertSubview:self.itemView belowSubview:self.navigationController.navigationBar];
    
    // 动画往下面平移
    [UIView animateWithDuration:0.25 animations:^{
        
        self.itemView.y = 64;
        
    }];
}

- (void)itemViewDismissAnimation:(UIBarButtonItem *)item complete:(void(^)(void))block{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.itemView.y = -self.itemView.height;
    } completion:^(BOOL finished) {
        
        [self.itemView removeFromSuperview];
        
        if (block) block();
        
    }];
    
    item.enabled = YES;
    [self.coverView dismiss];
    
}

- (IBAction)backAction:(id)sender {
    
    [self itemViewDismissAnimation:nil complete:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
}

- (IBAction)menuAction:(UIButton *)button {
    
    [self.scrollView setScrollEnabled:YES];
    self.selectBtn.selected = NO;
    self.selectBtn = button;
    
    NSUInteger tag = button.tag;
    self.indexTag = tag;
    
    if (self.isOrgTask) {
        
        self.newsBarItem.title = tag == 0 ? [NSString stringWithFormat:@"筛选:%@",self.commonStr]:[NSString stringWithFormat:@"筛选:%@",self.sopStr];
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.selectBtn.selected = YES;
        self.scrollBarConst.constant = (self.view.width*0.5)*tag;
        [self.view layoutIfNeeded];
        
        self.scrollView.contentOffset = CGPointMake(self.view.width*tag, 0);
        
    } completion:^(BOOL finished) {
        
        if (button.tag == 0)
        {
            if(self.commonVC.dataSource.count == 0)
            {
                [self.commonVC.tableView headerBeginRefreshing];
                
            }
            
        }
        else if (button.tag == 1)
        {
            if(self.sopVC.dataSource.count == 0)
            {
                [self.sopVC.tableView headerBeginRefreshing];
               
            }
        }
    }];
    
}

- (void)itemViewButtonAction:(UIButton *)button {
    
    //隐藏itemView
    [self itemViewDismissAnimation:self.newsBarItem complete:nil];
    
    if (self.isOrgTask) {
        
        self.newsBarItem.title = [NSString stringWithFormat:@"筛选:%@",button.currentTitle];
        if (self.indexTag == 0) {
            switch (button.tag) {
                case 100:
                    self.commonVC.taskSort = @"";
                    break;
                case 101:
                    self.commonVC.taskSort = @"weiGovTask";
                    break;
                case 102:
                    self.commonVC.taskSort = @"weiBaseTask";
                    break;
                case 103:
                    self.commonVC.taskSort = @"otherTask";
                    break;
                default:
                    break;
            }
            self.commonStr = button.currentTitle;
            [self.commonVC.tableView headerBeginRefreshing];
        }else{
            switch (button.tag) {
                case 100:
                    self.sopVC.taskSort = @"";
                    break;
                case 101:
                    self.sopVC.taskSort = @"weiGovTask";
                    break;
                case 102:
                    self.sopVC.taskSort = @"weiBaseTask";
                    break;
                case 103:
                    self.sopVC.taskSort = @"otherTask";
                    break;
                default:
                    break;
            }
            
            self.sopStr = button.currentTitle;
            [self.sopVC.tableView headerBeginRefreshing];
        }  
    }
    else{
    
        if ([button.currentTitle isEqualToString:@"普通任务"])
        {
            [self performSegueWithIdentifier:@"TaskCourseRelease" sender:nil];
        }
        else if ([button.currentTitle isEqualToString:@"SOP任务"])
        {
            [self performSegueWithIdentifier:@"TaskSOPRelease" sender:nil];
        }
    }
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if ([segue.identifier isEqualToString:@"TaskCourseRelease"])
    {
        //统计点击事件
        [UMAnalyticsHelper eventLogClick:@"event_session_publish_nor"];
        
        TaskCourseReleaseController *CVC = segue.destinationViewController;
        CVC.SureButtonBlock = ^(){
            [self.commonVC.tableView headerBeginRefreshing];
        };
    }
    if ([segue.identifier isEqualToString:@"TaskSOPRelease"])
    {
        //统计点击事件
        [UMAnalyticsHelper eventLogClick:@"event_session_publish_sop"];
        
        TaskSOPReleaseController *SVC = segue.destinationViewController;
        SVC.SureButtonBlock = ^(){
            [self.sopVC.tableView headerBeginRefreshing];
        };
        
    }
}
#pragma mark - Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSUInteger page = scrollView.contentOffset.x/self.view.width;
    UIButton *button = self.menuBtns[page];
    self.indexTag = page;
    self.selectBtn.selected = NO;
    self.selectBtn = button;
    
    [self menuAction:button];
    
}

#pragma mark - getter和setter
- (UIView *)itemView {
    if (!_itemView) {
        _itemView = [UIView new];
        CGFloat viewWidth = 150;
        CGFloat itemHeight = 44;
        NSInteger itemCount = self.isOrgTask ? self.orgTaskItems.count : self.items.count;
        _itemView.frame = CGRectMake(ScreenW-viewWidth, -itemHeight, viewWidth, itemHeight*itemCount);
        _itemView.backgroundColor = [UIColor whiteColor];
        [self addItemInView:_itemView];
    }
    return _itemView;
}

- (void)addItemInView:(UIView *)view {
    
    CGFloat itemHeight = 44;
    
    NSInteger itemCounts = self.isOrgTask ? self.orgTaskItems.count : self.items.count;
    for (int i = 0; i<itemCounts; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *title = self.isOrgTask ? self.orgTaskItems[i] : self.items[i];
        button.tag = 100 +i;
        [button setTitle:title forState:UIControlStateNormal];
        button.frame = CGRectMake(0, itemHeight*i, view.width, itemHeight);
        [view addSubview:button];
        
        [button setTitleColor:HEXRGB(0x333333) forState:UIControlStateNormal];
        [button setTitleColor:HEXRGB(0x47c1a9) forState:UIControlStateSelected];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        [button addTarget:self action:@selector(itemViewButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == itemCounts - 1) return;
        
        UIView *lineView = [UIView new];
        lineView.backgroundColor = HEXRGB(0xd7d7d7);
        [view addSubview:lineView];
        CGFloat margin = 10;
        
        lineView.frame = CGRectMake(margin, itemHeight*(i+1), view.width-margin*2, 0.8);
        
    }
    
}

- (NSArray *)items {
    if (!_items)
    {
        _items = @[@"普通任务",@"SOP任务"];
    }
    return _items;
}

- (NSArray *)orgTaskItems {
    if (!_orgTaskItems)
    {
        _orgTaskItems = @[@"全部",@"卫计委",@"培训基地",@"其他机构"];
    }
    return _orgTaskItems;
}


@end
