//
//  TaskSelectDepartController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/22.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "TaskSelectDepartController.h"
#import "TaskObject.h"
#import "RATreeView.h"

#import "SourceViewCell.h"

@interface TaskSelectDepartController ()<RATreeViewDelegate,RATreeViewDataSource>

@property (nonatomic,strong) NSArray *sourceData;
@property (weak, nonatomic) RATreeView *treeView;

@end

@implementation TaskSelectDepartController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getData];
    
}


#pragma mark - Action
- (IBAction)enterAction:(UIBarButtonItem *)item {
    
    if (self.enterItemBlock) {
        
        NSArray *arr = [self selectedItems:self.sourceData];
        
        self.enterItemBlock(arr);
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSMutableArray *)selectedItems:(NSArray *)list {
    
    NSMutableArray *selectedList = [NSMutableArray array];
    
    for (TaskObject *item in list)
    {
        if (item.isExpand)
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
        
        [self.treeView reloadData];
        
        [self dismissLoadingHUD];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        [self dismissLoadingHUD];
        
    }];
}

#pragma mark - Delegate
- (CGFloat)treeView:(RATreeView *)treeView heightForRowForItem:(id)item
{
    return 50;
}

- (NSInteger)treeView:(RATreeView *)treeView numberOfChildrenOfItem:(id)item
{
    if (item == nil) {
        return [self.sourceData count];
    }
    
    TaskObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    TaskObject *data = item;
    if (item == nil) {
        return [self.sourceData objectAtIndex:index];
    }
    
    return data.children[index];
}

- (BOOL)treeView:(RATreeView *)treeView canEditRowForItem:(id)item {
    return NO;
}

- (UITableViewCell *)treeView:(RATreeView *)treeView cellForItem:(id)item
{
    TaskObject *dataObject = item;
    
    NSInteger level = [self.treeView levelForCellForItem:item];
    
    TaskObject *parentObject = [treeView parentForItem:item];
    
    SourceViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([SourceViewCell class])];
    
    BOOL chooseBtnSelected = parentObject&&parentObject.isExpand?YES:dataObject.isExpand;
    
    dataObject.expand = chooseBtnSelected;
    
    [cell setupWithTitle:dataObject.deptName level:level chooseButtonSelected:chooseBtnSelected];
    
    [cell setArrowHiden:(dataObject.children.count==0)];
    
    //设置箭头的方向
    [cell setArrowDirection:dataObject.isArrowUp];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.chooseButtonAction = ^(SourceViewCell *cell,UIButton *button){
        
        BOOL expand = [treeView isCellExpanded:cell];
        
        dataObject.expand = button.selected;
        
        //没有展开同时父节点被选中
        if (!expand && dataObject.isExpand) {
            
            [self setObjects:dataObject.children andExpand:YES];
        }
        
        //刷新子节点
        if (expand)
        {
            [treeView reloadRowsForItems:dataObject.children withRowAnimation:RATreeViewRowAnimationFade];
        }
        
        //刷新父节点
        if (!dataObject.isExpand)
        {
            parentObject.expand = NO;
            
            if (parentObject)
            {
                [treeView reloadRowsForItems:@[parentObject] withRowAnimation:RATreeViewRowAnimationFade];
            }
        }
        
    };
    
    return cell;
}

//递归设置expand
- (void)setObjects:(NSArray *)arr andExpand:(BOOL)isExpand {
    
    for (TaskObject *object in arr)
    {
        object.expand = isExpand;
        
        if (object.children)
        {
            [self setObjects:object.children andExpand:isExpand];
        }
    }
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    
    TaskObject *dataObject = item;
    SourceViewCell *cell = (SourceViewCell *)[treeView cellForItem:dataObject];
    
    if ([cell isArrowHiden]) return;
    
    BOOL expand = [treeView isCellExpanded:cell];
    
    dataObject.arrowUp = !expand;
    //设置箭头的方向
    [cell setArrowDirection:!expand];
    
}
#pragma mark - getter和setter
- (RATreeView *)treeView {
    if (!_treeView)
    {
        RATreeView *treeView = [[RATreeView alloc] initWithFrame:self.view.bounds];
        _treeView = treeView;
        
        treeView.delegate = self;
        treeView.dataSource = self;
        treeView.treeFooterView = [UIView new];
        treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
        treeView.editing = NO;
        
        [self.treeView registerNib:[UINib nibWithNibName:NSStringFromClass([SourceViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SourceViewCell class])];
        
        [self.view addSubview:treeView];
        
        treeView.translatesAutoresizingMaskIntoConstraints = NO;
        
        id topLayoutGuide= self.topLayoutGuide;
        
        NSString *vVFL = @"V:|-[topLayoutGuide]-(0)-[treeView]-|";
        NSString *hVFL = @"H:|-(0)-[treeView]-(0)-|";
        
        NSArray *hConst = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(treeView)];
        NSArray *vConst = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(treeView,topLayoutGuide)];
        
        [self.view addConstraints:hConst];
        [self.view addConstraints:vConst];
    }
    return _treeView;
}

@end
