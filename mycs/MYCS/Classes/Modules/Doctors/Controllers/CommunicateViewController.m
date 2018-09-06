//
//  CommunicateViewController.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "CommunicateViewController.h"

#import "AcademicExchangeModel.h"
#import "PraiseModel.h"

#import "MyCommunicateViewCell.h"
#import "MJRefresh.h"
#import "IQKeyboardManager.h"

@interface CommunicateViewController ()<CommunicateViewCellDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *footView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *footViewConstraintBottom;

@property (weak, nonatomic) IBOutlet UITextField *inputF;

@property (nonatomic,strong) AcademicExchangeModel *academicModel;

@property (nonatomic,strong) Reply *reply;

@property (nonatomic,assign) CGFloat height;

@property (nonatomic,assign) int page;

@property (nonatomic,assign) BOOL isReload;

@end

@implementation CommunicateViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = NO;
    manager.enable = NO;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.isReload) {
        
        self.isReload = YES;
        
        [self.tableView reloadData];
    }
    
    if ([AppManager hasLogin])
    {
        [self addKeyboardNotification];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enableAutoToolbar = YES;
    manager.enable = YES;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isReload = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.commentList = [NSMutableArray array];
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    self.tableView.height += 44;
    self.footViewConstraintBottom.constant = -ScreenH;
    
    self.inputF.delegate = self;
    
}
#pragma mark - *** 键盘监听 ***
- (void)addKeyboardNotification
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowInComView:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideInComView:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - *** Http ***
- (void)loadNewData{
    
    self.page = 1;
    
    NSString *userID = [AppManager sharedManager].user.uid.length>0?[AppManager sharedManager].user.uid:@"";
    
    [AcademicExchangeModel AcademicExchangeListWithTargetId:self.uid userID:userID page:_page pageSize:10 targetType:0 success:^(NSArray *list) {
        
        [self.commentList removeAllObjects];
        [self.commentList addObjectsFromArray:list];
        
        [self.tableView reloadData];
        
        [self.tableView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        [self.tableView headerEndRefreshing];
    }];
    
}

- (void)loadMoreData{
    
    self.page++;
    
    NSString *userID = [AppManager sharedManager].user.uid.length>0?[AppManager sharedManager].user.uid:@"";
    
    [AcademicExchangeModel AcademicExchangeListWithTargetId:self.uid userID:userID page:_page pageSize:10 targetType:0 success:^(NSArray *list) {
        
        [self.tableView footerEndRefreshing];
        
        if (list.count==0) return;
        
        [self.commentList addObjectsFromArray:list];
        
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        [self.tableView footerEndRefreshing];
    }];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.commentList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *reuseID = @"CommunicateCell";
    
    MyCommunicateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    for (UIView *subView in cell.subviews)
    {
        if (subView.tag != 0)
        {
            [subView removeFromSuperview];
        }
    }
    
    AcademicExchangeModel *model = self.commentList[indexPath.section];
    
    if (model.showAllApply == nil)
    {
        model.showAllApply = @"0";
    }
    
    cell.academicModel = model;
    
    cell.delegate = self;
    
    self.height = cell.cellHeight;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (iS_IOS7)
    {
        static NSString *reuseID = @"CommunicateCell";
        
        MyCommunicateViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
        
        AcademicExchangeModel *model = self.commentList[indexPath.section];
        
        if (model.showAllApply == nil)
        {
            model.showAllApply = @"0";
        }
        
        cell.academicModel = model;
        
        self.height = cell.cellHeight;
        
    }
    return self.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
}

#pragma mark - *** setting and getting ***
- (void)setUid:(NSString *)uid
{
    _uid = uid;
    
    [self.tableView headerBeginRefreshing];
}


#pragma mark - *** MyCommunicateViewCell Delegate -- 刷新数据 ***
- (void)refreshMyCommunicateViewCellTable:(MyCommunicateViewCell *)cell
{
    
    [self.tableView reloadData];
    
}

#pragma mark - *** MyCommunicateViewCell Delegate -- 评论 ***
- (void)responseMyCommunicateViewCellReplyAction:(AcademicExchangeModel *)model
{
    self.isReload = NO;
    
    if (![AppManager checkLogin]) return;
    
    self.isReload = YES;
    
    self.academicModel = model;
    
    [self.inputF becomeFirstResponder];
    
    self.inputF.placeholder = @"评论内容";
}

#pragma mark - *** MyCommunicateViewCell Delegate -- 回复 ***
- (void)controlMyCommunicateViewCellActionWith:(AcademicExchangeModel *)model index:(int)index{
    
    self.isReload = NO;
    
    if (![AppManager checkLogin]) return;
    
    self.isReload = YES;
    
    self.academicModel = model;
    
    self.reply = model.replyList[index];
    
    [self.inputF becomeFirstResponder];
    
    self.inputF.placeholder = [NSString stringWithFormat:@"回复:%@",_reply.from_uname];
}

#pragma mark - *** 键盘将要显示 ***
- (void)keyboardWillShowInComView:(NSNotification *)notif
{
    
    CGRect rect = [[notif.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat keyboardH = rect.size.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [UIApplication sharedApplication].keyWindow.y = -keyboardH;
        
    } completion:^(BOOL finished) {
        
        self.footViewConstraintBottom.constant = 0;
        
    }];
    
}
#pragma mark - *** 键盘影藏***
- (void)keyboardWillHideInComView:(NSNotification *)notif
{
    
    self.inputF.text = @"";
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [UIApplication sharedApplication].keyWindow.y = 0;
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.15 animations:^{
            
            self.footViewConstraintBottom.constant = -ScreenH;
        }];
    }];
    
}

#pragma mark - *** UITextField Delegate  ***
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.inputF resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.inputF.text = @"";
}
#pragma mark - *** 提交评论 Action***
- (IBAction)commentAction:(id)sender
{
    
    self.commitBtn.enabled = NO;
    
    if (self.inputF.text.length == 0)
    {
        
        [self.view endEditing:YES];
        
        self.commitBtn.enabled = YES;
        
        return;
    }
    
    NSString *content = [self.inputF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [self showLoadingHUD];
    
    __weak typeof(self) this = self;
    
    [self.inputF resignFirstResponder];
    
    NSString * toEid = _academicModel.id;
    
    NSString *reply_id = !_reply?_academicModel.id:_reply.id;
    NSString *toUID = !_reply?@"0":_reply.from_uid;
    
    [self.view endEditing:YES];
    
    [AcademicExchangeModel commentWithUserID:[AppManager sharedManager].user.uid conetent:content toEid:toEid toUid:toUID reply_id:reply_id targetType:0 targetID:self.uid success:^{
        
        [this loadNewData];
        
        [self dismissLoadingHUD];
        [self showSuccessWithStatusHUD:@"评论成功!"];
        
        this.reply = nil;
        this.academicModel = nil;
        self.inputF.text = @"";
        self.commitBtn.enabled = YES;
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        
        [self showError:error];
        
        self.commitBtn.enabled = YES;
    }];
    
}

#pragma mark - *** MyCommunicateViewCelldelegate--点赞 ***
- (void)praiseMyCommunicateViewCellBtnDidClick:(MyCommunicateViewCell *)cell andDoctorComment:(AcademicExchangeModel *)model{
    
    self.isReload = NO;
    
    if ([AppManager checkLogin])
    {
        self.isReload = YES;
        
        cell.academicModel.isPraise = !cell.academicModel.isPraise;
        cell.praiseBtn.selected  =cell.academicModel.isPraise;
        cell.academicModel.praiseNum =[NSString stringWithFormat:@"%d", cell.academicModel.isPraise == YES?cell.academicModel.praiseNum.intValue + 1:cell.academicModel.praiseNum.intValue - 1];
        [cell.praiseBtn setTitle:cell.academicModel.praiseNum forState:UIControlStateNormal];
        
        [PraiseModel praiseWithUseID:[AppManager sharedManager].user.uid target_type:1 target_id:model.id success:^{
            
            
        } failure:^(NSError *error) {
            
            //            [self showError:error];
            
        }];
    }
    
}


@end








