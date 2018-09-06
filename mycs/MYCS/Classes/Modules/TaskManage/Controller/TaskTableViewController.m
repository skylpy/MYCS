//
//  TaskTableViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskTableViewController.h"
#import "VideoShopListModel.h"
#import "TaskListModel.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Util.h"
#import "NSMutableAttributedString+Attr.h"
#import "IQUIView+IQKeyboardToolbar.h"

#import "TaskSOPReleaseController.h"
#import "TaskCourseReleaseController.h"

@interface TaskTableViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *seachTextHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sopSeachTextHeight;

@property (weak, nonatomic) IBOutlet UITextField *commonTextField;

@property (weak, nonatomic) IBOutlet UITextField *sopTextField;

@property (assign,nonatomic)BOOL isRefresh;
@property (retain,nonatomic)NSString * keyword;

@end

@implementation TaskTableViewController

-(void)updateViewConstraints{

    [super updateViewConstraints];
    
//    self.seachTextHeight.constant = 0;
//    self.sopSeachTextHeight.constant = 0;
    
}

-(void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    if (self.isOrgTask) {
        self.seachTextHeight.constant = 0;
        self.sopSeachTextHeight.constant = 0;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    self.tableView.tableFooterView = [UIView new];
    
    self.tableView.rowHeight = 82;
    
    self.isRefresh = NO;
    self.keyword = @"";
    [self initTextField];
}

-(void)initTextField{

    UIButton * leftView = ({
        
        UIButton * btn = [UIButton new];
        
        btn.frame = CGRectMake(0, 0, 30, 20);
        
        [btn setImage:[UIImage imageNamed:@"search"]forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    [self createTextField:self.commonTextField andView:leftView];
    [self createTextField:self.sopTextField andView:leftView];
}

-(void)createTextField:(UITextField *)textField andView:(UIButton *)leftView{

    textField.delegate = self;
    textField.layer.cornerRadius = 4.0;
    textField.clipsToBounds = YES;
    
    textField.leftView = leftView;
    
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    [textField addLeftRightOnKeyboardWithTarget:self leftButtonTitle:@"取消" rightButtonTitle:@"搜索" leftButtonAction:@selector(hideKeyBoard) rightButtonAction:@selector(searchClick) shouldShowPlaceholder:YES];
}

-(void)searchClick{

    if ([self.sortType isEqualToString:@"sop"]) {
        self.keyword = self.sopTextField.text;
        [self.sopTextField resignFirstResponder];
    }else{
        self.keyword = self.commonTextField.text;
        [self.commonTextField resignFirstResponder];
    }
    [self.tableView headerBeginRefreshing];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self hideKeyBoard];
    [textField resignFirstResponder];
    return YES;
}
-(void)hideKeyBoard
{
    [self.sopTextField resignFirstResponder];
    [self.commonTextField resignFirstResponder];
}
-(void)setTaskSort:(NSString *)taskSort{

    _taskSort = taskSort;
    
}
#pragma mark -搜索框的隐藏与显示
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (translation.y<0)
    {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            
        } completion:^(BOOL finished) {
            self.seachTextHeight.constant = 0;
            self.sopSeachTextHeight.constant = 0;
        }];
        
    }else if(translation.y>0)
    {
        [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
        } completion:^(BOOL finished) {
            
            self.seachTextHeight.constant = 35;
            self.sopSeachTextHeight.constant = 35;
            
        }];
    }
    [self.commonTextField resignFirstResponder];
    [self.sopTextField resignFirstResponder];
}


#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * reuseID = @"TaskTableCell";
    
    TaskTableCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    TaskModel *model = self.dataSource[indexPath.row];
    
    cell.type = self.type;
    
    cell.sortType = self.sortType;
    
    cell.model = model;
    
    cell.delegate = self;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.CellClickBlock) {
        TaskModel *model = self.dataSource[indexPath.row];
        self.CellClickBlock(model,self.sortType);
    }
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

#pragma mark - NetWork
- (void)loadNewData{
    
    int type = self.type;
    
    if (self.type == 1)
    {
        if ([AppManager sharedManager].user.userType == UserType_organization)
        {
            type = 3;
        }
        if ([[AppManager sharedManager].user.agroup_id integerValue] == 9 )
        {
            
            type = 5;
        }
        if ([[AppManager sharedManager].user.agroup_id integerValue] == 10) {
            
            type = 6;
        }
    }
    
    self.page = 1;
    
    [TaskListModel listWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:@"list" type:type sort:self.sortType keyword:self.keyword pageSize:20 page:self.page taskSort:self.taskSort success:^(TaskListModel *taskListModel) {
        
        
        [self.dataSource removeAllObjects];
        [self.dataSource addObjectsFromArray:taskListModel.list];
        [self.tableView reloadData];
        
        if (taskListModel.list.count == 0)
        {
            [self showSuccessWithStatusHUD:@"没有任务"];
        }
        
        [self.tableView headerEndRefreshing];
        
    } failure:^(NSError *error) {
//        [self showError:error];
        [self.tableView headerEndRefreshing];
    }];
    
}

- (void)loadMoreData
{
    int type = self.type;
    
    if (self.type == 1)
    {
        if ([AppManager sharedManager].user.userType == UserType_organization)
        {
            type = 3;
        }
        if ([[AppManager sharedManager].user.agroup_id integerValue] == 9)
        {
            
            type = 5;
        }
        if ([[AppManager sharedManager].user.agroup_id integerValue] == 10) {
            
            type = 6;
        }
    }
    
    self.page ++;
    
    [TaskListModel listWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] action:@"list" type:type sort:self.sortType keyword:self.keyword pageSize:20 page:self.page taskSort: self.taskSort success:^(TaskListModel *taskListModel) {
        
        [self.dataSource addObjectsFromArray:taskListModel.list];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
//        [self showError:error];
        [self.tableView footerEndRefreshing];
    }];
    
}

-(void)setType:(int)type
{
    _type = type;
    
}

- (void)setSortType:(NSString *)sortType {
    _sortType = sortType;
    
//    [self.tableView headerBeginRefreshing];
}

- (NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

@end

@interface TaskTableCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@property (weak, nonatomic) IBOutlet UIButton *sendButton;

@end

@implementation TaskTableCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.sendButton.layer.borderColor = HEXRGB(0xd1d1d1).CGColor;
    self.sendButton.layer.borderWidth = 1;
    
    self.sendButton.layer.cornerRadius = 6;
    
    self.sendButton.clipsToBounds = YES;
}

-(void)setSortType:(NSString *)sortType
{
    _sortType = sortType;
}
- (void)setModel:(TaskModel *)model {
    _model = model;
    
    self.sendButton.hidden = YES;
    
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:PlaceHolderImage];
    
    NSString *timeString = [NSDate dateWithTimeInterval:model.endTime format:@"yyyy-MM-dd"];
    timeString = [NSString stringWithFormat:@"截止日期：%@",timeString];
    
    self.titleLabel.text = model.name;
    
    self.endTimeLabel.text = timeString;
    
    NSString *status = nil;
    UIColor *color = [UIColor darkGrayColor];
    if (model.status == 0) {
        
        status = @"状态：等待发布";
        color = HEXRGB(0xff9d5e);
        
    }else if (model.status == 1){
        status = @"状态：考核中";
        color = HEXRGB(0x47c1a9);
        
    }else if (model.status == 2){
        status = @"状态：已过期";
        color = RGBCOLOR(138, 138, 138);
    }else if (model.status == 3){
        status = @"状态：发布中";
        color = RGBCOLOR(125, 179, 68);
        
    }else if(model.status == 4)
    {
        status =@"状态：任务终止";
        color = RGBCOLOR(138, 138, 138);
    }else if(model.status == -1)
    {
        status =@"状态：已删除";
        color = [UIColor redColor];
    }else
    {
        status =@"状态:无状态";
        color = RGBCOLOR(255, 255, 255);
    }
    
    //model.type 等于5是卫计委下发的任务  model.type 等于6是培训基地下发的任务
    if (model.type.integerValue == 5||model.type.integerValue == 6) {
        
        if (self.type == 3 ||self.type == 1)
        {
            self.sendButton.hidden = NO;
        }
    }
    else{
    
        if ((model.status == 0 || model.status == 1 || model.status == 3) && model.remainCount.intValue > 0)
        {
            
            if (self.type == 3 ||self.type == 1)
            {
                self.sendButton.hidden = NO;
            }
        }
    }
    
    
    self.statusLabel.attributedText = [NSMutableAttributedString string:status value1:color range1:NSMakeRange(3, status.length-3) value2:nil range2:NSMakeRange(0, 0) font:12];
}
- (IBAction)sendButtonAction:(UIButton *)sender
{
    
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"TaskManage" bundle:nil];
    
    if ([self.sortType isEqualToString:@"common"])
    {
        TaskCourseReleaseController * CVC = [sb instantiateViewControllerWithIdentifier:@"TaskCourseReleaseController"];
        
        
        CVC.sortType = self.sortType;
        
        CVC.model = self.model;
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:CVC animated:YES];
        
        CVC.SureButtonBlock = ^(){
            [self.delegate.tableView headerBeginRefreshing];
        };
        
    }else if ([self.sortType isEqualToString:@"sop"])
    {
        TaskSOPReleaseController * SVC = [sb instantiateViewControllerWithIdentifier:@"TaskSOPReleaseController"];
        
        SVC.sortType = self.sortType;
        
        SVC.model = self.model;
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:SVC animated:YES];
        
        SVC.SureButtonBlock = ^(){
            [self.delegate.tableView headerBeginRefreshing];
        };
    }
}

@end







