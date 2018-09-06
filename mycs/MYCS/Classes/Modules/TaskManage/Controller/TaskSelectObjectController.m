//
//  TaskSelectObjectController.m
//  MYCS
//
//  Created by yiqun on 16/8/30.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskSelectObjectController.h"
#import "TaskObject.h"

#import "SelectTableCell.h"
#import "TaskSelectView.h"
#import "TaskSOPReleaseController.h"
#import "BackButton.h"


static NSString *const reuseId = @"SelectTableCell";
@interface TaskSelectObjectController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;

@property (weak, nonatomic) IBOutlet UITableView *selectTable;

@property (weak, nonatomic) IBOutlet UIScrollView *selectScroll;

@property (strong,nonatomic)NSArray * titleArray;

@end

@implementation TaskSelectObjectController


-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self.selectTable reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    
    [self.selectTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectTable.tableFooterView = [UIView new];
    self.selectTable.delegate = self;
    self.selectTable.dataSource = self;
    self.selectTable.backgroundColor = bgsColor;
    self.selectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib * nib = [UINib nibWithNibName:reuseId bundle:[NSBundle mainBundle]];
    [self.selectTable registerNib:nib forCellReuseIdentifier:reuseId];
    self.bottomView.hidden = YES;

    if (self.deptName) {
        
        NSMutableArray * nsmArr = [NSMutableArray array];
        for (int i = 0; i < self.titleArray.count; i ++) {
            [nsmArr addObject:self.titleArray[i]];
        }
        [nsmArr addObject:self.deptName];
        self.titleArray = nsmArr;
    }else{
        self.titleArray = @[@"全部"];
    }
    if (self.isFirstCome) {
        
        [self getData];
        self.bottomView.hidden = NO;
    }
    [self createTitle];
    [self setNavigation];
    if (iS_IOS10)
    {
        [self addConstraints];
    }
}
- (void)addConstraints
{
    self.selectScroll.translatesAutoresizingMaskIntoConstraints = NO;
    self.automaticallyAdjustsScrollViewInsets                     = NO;
    
    id selectScroll = self.selectScroll;
    
    NSString *hVFL = @"H:|-(0)-[selectScroll]-(0)-|";
    NSString *vVFL = @"V:|-(64)-[selectScroll(65)]";
    
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectScroll)];
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(selectScroll)];
    
    
    [self.view addConstraints:hConsts];
    [self.view addConstraints:vConsts];
}

//设置导航条
-(void)setNavigation{

    BackButton *button = [[BackButton alloc]init];
    [button setTitle:@"返回" forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:self action:@selector(finish) forControlEvents:UIControlEventTouchUpInside];
    
    // 导航条右
//    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    backButton.frame = CGRectMake(20, 0, 40, 20);
//    [backButton setTitle:@"关闭" forState:UIControlStateNormal];
//    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
//    backButton.titleLabel.font = [UIFont systemFontOfSize:16];
//    UIButton *NIButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    UIBarButtonItem * items = [[UIBarButtonItem alloc] initWithCustomView:button];
//    UIBarButtonItem * nilItems = [[UIBarButtonItem alloc] initWithCustomView:NIButton];
//    UIBarButtonItem * backItems = [[UIBarButtonItem alloc] initWithCustomView:backButton];／,nilItems,backItems
    self.navigationItem.leftBarButtonItems = @[items];
    
    // 导航条右
    UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    allButton.frame = CGRectMake(0, 0, 40, 20);
    [allButton setTitle:@"全选" forState:UIControlStateNormal];
    [allButton setTitle:@"重选" forState:UIControlStateSelected];
    [allButton addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
    allButton.titleLabel.font = [UIFont systemFontOfSize:16];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:allButton];
    
}

-(void)backAction:(UIButton *)sender{

    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[TaskSOPReleaseController class]]) {
            [self.navigationController popToViewController:vc animated:YES];
            break;
        }
    }
}

- (void)finish
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)allAction:(UIButton *)sender{

    sender.selected = !sender.selected;
    [self allSelectedItems:self.sourceData andSelect:sender.selected];
    [self.selectTable reloadData];
}
//全选
- (void)allSelectedItems:(NSArray *)list andSelect:(BOOL)select{

    for (TaskObject *item in list) {
        
        item.select = select;
        
        if (item.children.count > 0) {
            
            [self allSelectedItems:item.children andSelect:select];
        }

    }
}

-(void)createTitle{
    
    if (self.titleArray.count <= 4) {
        
        for (int i = 0; i < self.titleArray.count; i ++) {
            
            UIColor * color = i == self.titleArray.count -1 ?[UIColor blackColor]:[UIColor lightGrayColor];
            [self setTaskSelectV:self.titleArray[i] andIndex:i andLenght:self.titleArray.count andColor:color];
        }
    }else{
    
        for (int i = 0; i < 4; i ++) {
            
            NSString * title = i == 2 ?@"......":i == 0||i == 1? self.titleArray[i]:[self.titleArray lastObject];
            UIColor * color = i == 3 ?[UIColor blackColor]:[UIColor lightGrayColor];
            [self setTaskSelectV:title andIndex:i andLenght:4 andColor:color];
        }
    }
    
}
-(void)setTaskSelectV:(NSString * )title andIndex:(NSInteger)index andLenght:(NSInteger)lenght andColor:(UIColor *)color{

    TaskSelectView * selectView = [[TaskSelectView alloc] initWithFrame:CGRectMake(index*(ScreenW/4), 0, ScreenW/4, 45)];
    [selectView setTitleString:title andColor:color];
    [self.selectScroll addSubview:selectView];
    self.selectScroll.contentSize = CGSizeMake((ScreenW/4)*lenght, 45);
    self.selectScroll.scrollEnabled = NO;
}

- (IBAction)finishAction:(UIButton *)sender {
    
    if (sender.tag == 1000) {
        
        [self getData];
        
    }else{
    
        if (self.enterItemBlock) {
            
            NSArray *arr = [self selectedItems:self.allData];
            self.enterItemBlock(arr);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
        
        
    }
}

- (NSMutableArray *)selectedItems:(NSArray *)list {
    
    NSMutableArray *selectedList = [NSMutableArray array];
    
    for (TaskObject *item in list)
    {
        if (item.isSelect)
        {
            [selectedList addObject:item];
        }
        if (item.children.count>0)
        {
            NSArray *childrenSelected = [self selectedItems:item.children];
            [selectedList addObjectsFromArray:childrenSelected];
        }
    }
    
    return selectedList;
}
#pragma mark - Network
- (void)getData {
    
    [self showLoadingHUD];
    
    [TaskObject taskDepartmentConcatWithSuccess:^(NSArray *TaskObjectList) {
        
        
        self.sourceData = TaskObjectList;
        self.allData = self.sourceData;
        [self.selectTable reloadData];
        
        [self dismissLoadingHUD];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        [self dismissLoadingHUD];
        
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.sourceData.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    SelectTableCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TaskObject * taskModel = self.sourceData[indexPath.row];
    
    cell.taskModel = taskModel;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    TaskObject * taskModel = self.sourceData[indexPath.row];
    if ([taskModel.hasChild isEqualToString:@"false"]) return;
    
    TaskSelectObjectController *selectVC = [[UIStoryboard storyboardWithName:@"TaskManage" bundle:nil] instantiateViewControllerWithIdentifier:@"TaskSelectObjectController"];
    selectVC.isFirstCome = NO;
    selectVC.sourceData = taskModel.children;
    selectVC.deptName = taskModel.deptName;
    
    selectVC.allData = self.isFirstCome ? self.sourceData : self.allData;
    selectVC.titleArray = self.titleArray;
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:selectVC animated:YES];
    
}

@end



