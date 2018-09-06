//
//  ChooseDeptsViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/11.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ChooseDeptsViewController.h"

#import "BDDynamicTree.h"
#import "BDDynamicTreeNode.h"
#import "BDDynamicTreeCell.h"

#import "DeptModel.h"
#import "StaffModel.h"

#import "UIAlertView+Block.h"

@interface ChooseDeptsViewController ()<BDDynamicTreeDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (strong, nonatomic) BDDynamicTree *bDDynamicTree;

@property (strong, nonatomic) NSMutableArray *deptDataSource;

@end

@implementation ChooseDeptsViewController
-(NSMutableArray *)selectDep
{
    if (_selectDep == nil)
    {
        _selectDep = [NSMutableArray array];
    }
    return _selectDep;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sureBtn.layer.cornerRadius = 4.0;
    self.sureBtn.clipsToBounds = YES;
    
    
    self.deptDataSource = [NSMutableArray array];
    
    if (self.isMember)
    {
        [self getMemberData];
    }
    else
    {
        [self getDeptData];
    }
    
}
- (IBAction)backAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- 获取 data
- (void)getMemberData
{
    [DeptModel getMemberDetail:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] action:@"getGrade" success:^(NSArray *memberDetailList) {
        
        [self handleMemberData:memberDetailList parentId:nil];
        
        self.bDDynamicTree = [[BDDynamicTree alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.bgView.height) nodes:self.deptDataSource andSelectNode:self.selectDep];
        self.bDDynamicTree.delegate = self;
        
        [self.bgView addSubview:_bDDynamicTree];
        
    } failure:^(NSError *error)
     {
         [self showError:error];
     }];
}
#pragma mark -- 获取 data
- (void)getDeptData
{
    [DeptModel dataWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] action:@"getDept" success:^(NSArray *list) {
        
        [self handleDeptData:list parentId:nil];
        
        self.bDDynamicTree = [[BDDynamicTree alloc] initWithFrame:CGRectMake(0, 0, ScreenW, self.bgView.height) nodes:self.deptDataSource andSelectNode:self.selectDep];
        self.bDDynamicTree.delegate = self;
        
        [self.bgView addSubview:_bDDynamicTree];
        
    } failure:^(NSError *error)
     {
         [self showError:error];
     }];
}
- (void)handleMemberData:(NSArray*)arr parentId:(NSString*)parentId
{
    NSArray *array = [NSArray arrayWithArray:arr];
    
    for (MemModel *mem in array)
    {
        BDDynamicTreeNode *node = [[BDDynamicTreeNode alloc] init];
        node.originX = 20;
        node.isDepartment = NO;
        node.fatherNodeId = parentId;
        node.nodeId = mem.id;
        node.name = mem.text;
        node.data = @{@"name":mem.text};
        
        if (mem.children.count>0)
        {
            node.isDepartment = YES;
            [self handleMemberData:mem.children parentId:mem.id];
        }
        [self.deptDataSource addObject:node];
    }
}
- (void)handleDeptData:(NSArray*)arr parentId:(NSString*)parentId
{
    
    NSArray *array = [NSArray arrayWithArray:arr];
    
    for (DeptModel *dept in array)
    {
        BDDynamicTreeNode *node = [[BDDynamicTreeNode alloc] init];
        node.originX = 20;
        node.isDepartment = NO;
        node.fatherNodeId = parentId;
        node.nodeId = dept.deptId;
        node.name = dept.deptName;
        node.data = @{@"name":dept.deptName};
        
        if (dept.children.count>0)
        {
            node.isDepartment = YES;
            [self handleDeptData:dept.children parentId:dept.deptId];
        }
        [self.deptDataSource addObject:node];
    }
}

#pragma mark -- 确认添加 Action
- (IBAction)sureButtonAction:(id)sender
{
    NSMutableArray *ids = [NSMutableArray array];
    
    for (BDDynamicTreeNode *nd in self.bDDynamicTree.selectedNodes)
    {
        if (nd.isSelect)
        {
            [ids addObject:nd];
        }
    }
    
    if (self.sureBtnBlock)
    {
        
        self.sureBtnBlock(ids,0);
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
