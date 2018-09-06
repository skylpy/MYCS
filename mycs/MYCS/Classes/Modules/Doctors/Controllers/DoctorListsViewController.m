//
//  DoctorListsViewController.m
//  MYCS
//  医生列表
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "DoctorListsViewController.h"

#import "DoctorListTableViewCell.h"

#import "DoctorModel.h"

#import "DoctorsPageViewController.h"

#import "MJRefresh.h"

#import "IQUIView+IQKeyboardToolbar.h"
#import "UITableView+UITableView_Util.h"

@interface DoctorListsViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate,UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewTopConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchViewHeightConstraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopConstraint;

@property (nonatomic, strong) NSMutableArray *baseDataSource;

@property (nonatomic, assign) int page;

@property (nonatomic ,strong) NSString *searchKeyWord;

@end

@implementation DoctorListsViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [UMAnalyticsHelper beginLogPageName:@"名医"];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [UMAnalyticsHelper endLogPageName:@"名医"];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    self.baseDataSource = [NSMutableArray array];
    
    self.tableView.dataSource = self;
    self.tableView.delegate   = self;

    self.tableView.tableFooterView = [UIView new];

    self.tableView.rowHeight = 94;

    self.tableView.height -= 60;

    self.baseDataSource = [NSMutableArray array];

    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];

    [self.tableView headerBeginRefreshing];
    
    [self buildTextField];
}

-(void)buildTextField
{
    UIButton * leftView = ({
        
        UIButton * btn = [UIButton new];
        
        btn.frame = CGRectMake(0, 0, 30, 20);
        
        [btn setImage:[UIImage imageNamed:@"search"]forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(searchDoctorClick) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    self.searchTextField.delegate = self;
    self.searchTextField.layer.cornerRadius = 4.0;
    self.searchTextField.clipsToBounds = YES;
    
    self.searchTextField.leftView = leftView;
    
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.searchTextField addLeftRightOnKeyboardWithTarget:self leftButtonTitle:@"取消" rightButtonTitle:@"搜索" leftButtonAction:@selector(hideKeyBoard) rightButtonAction:@selector(searchDoctorClick) shouldShowPlaceholder:YES];
}

-(void)hideKeyBoard
{
    [self.searchTextField resignFirstResponder];
}

-(void)searchDoctorClick
{
    self.searchKeyWord = self.searchTextField.text;
    [self loadNewData];
     [self.searchTextField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    self.searchKeyWord = self.searchTextField.text;
    [self loadNewData];
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark -tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _baseDataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = @"DoctorListTableViewCell";

    DoctorListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];

    DoctorListModel *model = self.baseDataSource[indexPath.row];

    [cell setModel:model];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DoctorListModel *model = self.baseDataSource[indexPath.row];

    DoctorsPageViewController *doctorPageVC = [[UIStoryboard storyboardWithName:@"doctor" bundle:nil] instantiateViewControllerWithIdentifier:@"DoctorsPageViewController"];

    doctorPageVC.uid = model.uid;

    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:doctorPageVC animated:YES];

    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

#pragma mark -搜索框的隐藏与显示
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
    if (translation.y<0)
    {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.searchViewHeightConstraint.constant = 0.1;
            self.tableViewTopConstraint.constant = 0;
            self.searchTextField.alpha = 0;
            
        } completion:^(BOOL finished) {
            
            self.searchViewTopConstraint.constant = -40;
        }];
        
    }else if(translation.y>=0)
    {
        [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            self.searchViewTopConstraint.constant = 5;
            
        } completion:^(BOOL finished) {
            
            self.searchTextField.alpha = 1;
            self.searchViewHeightConstraint.constant = 35;
            self.tableViewTopConstraint.constant = 45;
        }];
    }
    
    [self.searchTextField resignFirstResponder];
}

#pragma mark - http
- (void)loadNewData {
    self.page = 1;

    [DoctorModel doctorListsWithpage:self.page pageSize:10 UserID:@"" keyWord:self.searchKeyWord fromCache:YES success:^(NSArray *list) {

        [self.baseDataSource removeAllObjects];
        [self.tableView removeNoDataTipsView];
        if (list.count > 0) {
            [self.baseDataSource addObjectsFromArray:list];
            
        }
        else{
            [self.tableView setNoDataTipsView:30];

        }
        

        [self.tableView headerEndRefreshing];

        [self.tableView reloadData];

    }
        failure:^(NSError *error) {

            [self showError:error];

            [self.tableView headerEndRefreshing];

        }];
}

- (void)loadMoreData {
    self.page++;

    [DoctorModel doctorListsWithpage:self.page pageSize:10 UserID:@"" keyWord:self.searchKeyWord fromCache:YES success:^(NSArray *list) {

        [self.baseDataSource addObjectsFromArray:list];

        [self.tableView reloadData];

        [self.tableView footerEndRefreshing];

    }
        failure:^(NSError *error) {

            [self showError:error];

            [self.tableView footerEndRefreshing];
        }];
}

@end