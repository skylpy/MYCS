//
//  SelectDeptController.m
//  MYCS
//
//  Created by yiqun on 16/9/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SelectDeptController.h"
#import "RADataObject.h"
#import "VideoSpaceModel.h"
#import "SelectTableCell.h"
#import "TaskObject.h"

#import "TaskSelectView.h"

static NSString *const reuseId = @"SelectTableCell";
@interface SelectDeptController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;

@property (weak, nonatomic) IBOutlet UITableView *sellectTable;

@property (strong,nonatomic)NSArray * titleArray;
@end

@implementation SelectDeptController

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self.sellectTable reloadData];
    
}
-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
    [self.sellectTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sellectTable.tableFooterView = [UIView new];
    self.sellectTable.delegate = self;
    self.sellectTable.dataSource = self;
    self.sellectTable.backgroundColor = bgsColor;
    self.sellectTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib * nib = [UINib nibWithNibName:reuseId bundle:[NSBundle mainBundle]];
    [self.sellectTable registerNib:nib forCellReuseIdentifier:reuseId];
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
        
        [self requestData];
        self.bottomView.hidden = NO;
    }
    [self createTitle];
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
    [self.topScrollView addSubview:selectView];
    self.topScrollView.contentSize = CGSizeMake((ScreenW/4)*lenght, 45);
    self.topScrollView.scrollEnabled = NO;
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

    SelectDeptController *selectVC = [[UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectDeptController"];
    selectVC.isFirstCome = NO;
    selectVC.sourceData = taskModel.children;
    selectVC.deptName = taskModel.deptName;
    
    selectVC.allData = self.isFirstCome ? self.sourceData : self.allData;
    selectVC.titleArray = self.titleArray;
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:selectVC animated:YES];
    
}


#pragma mark - Http
- (void)requestData {
    
    [self showLoadingHUD];
    
    [SourceModel sourceListWithSuccess:^(NSArray *list) {
        
        self.sourceData = list;
        self.allData = self.sourceData;
        
        [self.sellectTable reloadData];
        [self dismissLoadingHUD];
        
    } failure:^(NSError *error) {
        [self dismissLoadingHUD];
        [self showError:error];
    }];
    
}

- (IBAction)setOffAction:(UIButton *)sender {
    
    [self requestData];
}
- (IBAction)sureAction:(UIButton *)sender {
    if (self.sureBtnBlock) {
        
        NSArray *arr = [self selectedItems:self.allData];
        
        
        NSString *idStr = [arr componentsJoinedByString:@","];
        self.sureBtnBlock(idStr);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//-(NSString *)selectItems:(NSArray *)list{
//
//    
//}

- (NSMutableArray *)selectedItems:(NSArray *)list {
    
    NSMutableArray *selectedList = [NSMutableArray array];
    
    for (TaskObject *item in list)
    {
        if (item.isSelect)
        {
            [selectedList addObject:[NSString stringWithFormat:@"%ld",item.deptId]];
        }
        if (item.children.count>0)
        {
            NSArray *childrenSelected = [self selectedItems:item.children];
            [selectedList addObjectsFromArray:childrenSelected];
        }
    }
    
    return selectedList;
}

@end
