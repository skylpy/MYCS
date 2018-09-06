//
//  TaskNoticeUserController.m
//  MYCS
//  发送提醒选择人员
//  Created by AdminZhiHua on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskNoticeUserController.h"
#import "TaskDetailModel.h"
#import "MJRefresh.h"
#import "NSDate+Util.h"
#import "MailBoxEditorViewController.h"
#import "ReceiverModel.h"

static NSString *reuseID = @"TaskSelectUserCell";

@interface TaskNoticeUserController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuBtns;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBarConst;
@property (nonatomic,strong) UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,assign) NSInteger page;

@property (nonatomic,copy) NSString *requestType;

@property (nonatomic,strong) NSMutableArray *dataSources;
@property (weak, nonatomic) IBOutlet UIButton *selectAllButton;

@end

@implementation TaskNoticeUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSources = [NSMutableArray array];
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    //    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    [self.view layoutIfNeeded];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIButton *button = self.menuBtns[0];
    [self menuAction:button];
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - Network
- (void)loadNewData {
    
    self.page = 1;
    
    [TaskJoinUserModel userJoinListWith:self.taskId Sort :self.sort page:self.page requestType:self.requestType success:^(NSMutableArray *list) {
        
        [self.dataSources removeAllObjects];
        [self.dataSources addObjectsFromArray:list];
        [self.tableView reloadData];
        [self.tableView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView headerEndRefreshing];
    }];
    
}
#pragma mark 加载更多
- (void)loadMoreData {
    
    self.page++;
    
    [TaskJoinUserModel userJoinListWith:self.taskId Sort :self.sort page:self.page requestType:self.requestType success:^(NSArray *list) {
        
        [self.dataSources addObjectsFromArray:list];
        [self.tableView reloadData];
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        [self.tableView footerEndRefreshing];
    }];
    
}

#pragma mark - Action
- (IBAction)menuAction:(UIButton *)button {
    
    self.selectBtn.selected = NO;
    self.selectBtn = button;
    
    NSUInteger tag = button.tag;
    
    if (tag == 0)
    {
        self.requestType = nil;
    }
    else if (tag == 1)
    {
        self.requestType = @"0";
    }
    else if (tag == 2)
    {
        self.requestType = @"1";
    }
    
    self.selectAllButton.selected = NO;
    
    //主动让下拉刷新头部控件进入刷新状态
    [self.tableView headerBeginRefreshing];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.selectBtn.selected = YES;
        self.scrollBarConst.constant = (self.view.width*0.3333)*tag;
        [self.view layoutIfNeeded];
        
    } completion:^(BOOL finished) {
        
    }];
    
}
#pragma mark -- 发送按钮
- (IBAction)enterAction:(UIBarButtonItem *)item {
    
    NSString *idString = [self selectItemString];
    NSString *nameString = [self selectNameString];
    if (idString.length==0)
    {
        [self showErrorMessage:@"请选择人员"];
        return;
    }
    
    [self setAllSelected:NO];

    
    NSArray *arr;
    
    ReceiverModel *receiver = [[ReceiverModel alloc] init];
    [receiver userName:nameString userID:idString];
    arr = [NSArray arrayWithObject:receiver];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mailbox" bundle:nil];
    MailBoxEditorViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MailBoxEditorViewController"];
    
    controller.answerList = [NSMutableArray arrayWithArray:arr];
    controller.sendType = 4;
    
    controller.endTime = [NSDate dateWithTimeInterval:self.detailModel.detail.endTime format:@"yyyy-MM-dd"];
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
    
    
}

- (NSString *)selectItemString {
    
    NSMutableArray *arr = [NSMutableArray array];
    for (TaskJoinUserModel *model in self.dataSources)
    {
        if (model.isSelected) {
            [arr addObject:model.user_id];
        }
    }
    //    将array数组转换为string字符串   --分隔符
    NSString *idString = [arr componentsJoinedByString:@","];
    
    return idString;
}
-(NSString *)selectNameString
{
    NSMutableArray *arr = [NSMutableArray array];
    for (TaskJoinUserModel *model in self.dataSources)
    {
        if (model.isSelected) {
            [arr addObject:model.realname];
        }
    }
    //    将array数组转换为string字符串   --分隔符
    NSString *nameString = [arr componentsJoinedByString:@","];
    
    return nameString;
}
//选择人员
- (IBAction)selectAllAction:(UIButton *)button {
    
    button.selected = !button.selected;
    
    [self setAllSelected:button.selected];
}

- (void)setAllSelected:(BOOL)select {
    
    for (TaskJoinUserModel *userModel in self.dataSources)
    {
        userModel.select = select;
    }
    
    [self.tableView reloadData];
    
}


#pragma mark - Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TaskSelectUserCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    TaskJoinUserModel *model = self.dataSources[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

#pragma mark - getter和setter

@end

@interface TaskSelectUserCell ()

@property (weak, nonatomic) IBOutlet UIButton *chooseButton;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

@end

@implementation TaskSelectUserCell


- (IBAction)chooseButtonAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    self.model.select = sender.selected;
}

- (void)setModel:(TaskJoinUserModel *)model {
    _model = model;
    
    self.nameLabel.text = model.realname;
    
    //    taskStatus  0未通过 1已通过 2未参加 3参加中
    NSString *status;
    UIColor *color;
    if (model.taskStatus == 0)
    {
        status = @"未通过";
        color = HEXRGB(0xf66060);
    }
    else if (model.taskStatus == 1)
    {
        status = @"已通过";
        color = HEXRGB(0x47c1a8);
    }
    else if (model.taskStatus == 2)
    {
        status = @"未参加";
        color = HEXRGB(0xff9d60);
    }
    else if (model.taskStatus == 3)
    {
        status = @"参加中";
    }
    
    self.statusLabel.text = status;
    self.statusLabel.textColor = color;
    
    self.chooseButton.selected = model.isSelected;
}

@end
