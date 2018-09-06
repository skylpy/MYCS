//
//  SelectSourceController.m
//  MYCS
//  《我的视频空间－选择来源》
//  Created by AdminZhiHua on 16/1/11.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SelectSourceController.h"
#import "VideoSpaceModel.h"
#import "RATreeView.h"
#import "RADataObject.h"

#import "SourceViewCell.h"

static NSString *const reuseId = @"SelectSourceCell";

@interface SelectSourceController ()<RATreeViewDelegate, RATreeViewDataSource>

@property (nonatomic,strong) NSArray *sourceData;

@property (weak, nonatomic) RATreeView *treeView;

@end

@implementation SelectSourceController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestData];
}

#pragma mark - Action
- (IBAction)cancelAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setIsPostSystemViewController:(BOOL)isPostSystemViewController
{
    _isPostSystemViewController = isPostSystemViewController;
}

- (IBAction)sureAction:(id)sender {
    
    if (self.sureBtnBlock) {
        
        self.sureBtnBlock([self selectIdStr]);
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (NSString *)selectIdStr {
    
    NSArray *items = [self selectedItems:self.sourceData];
    
    NSMutableArray *ids = [NSMutableArray array];
    
    for (RADataObject *object in items)
    {
        [ids addObject:object.idStr];
    }
    
    NSString *idStr = [ids componentsJoinedByString:@","];
    
    return idStr;
}

- (NSArray *)selectedItems:(NSArray *)list {
    
    NSMutableArray *selectedList = [NSMutableArray array];
    
    if (self.isPostSystemViewController)
    {
        for (RADataObject *item in list)
        {
            
            if (item.children.count>0)
            {
                for (RADataObject * children in item.children)
                {
                    if (children.isSelected)
                    {
                        [selectedList addObject:children];
                    }
                    
                }
            }
            if (item.isSelected)
            {
                [selectedList addObject:item];
            }
            
        }
        
    }
    else
    {
        
        for (RADataObject *item in list)
        {
            if (item.isSelected)
            {
                [selectedList addObject:item];
            }
            else
            {
                if (item.children.count>0)
                {
                    NSArray *childrenSelected = [self selectedItems:item.children];
                    [selectedList addObjectsFromArray:childrenSelected];
                }
            }
            
        }
    }
    
    return selectedList;
}

#pragma mark - Http
- (void)requestData {
    
    [self showLoadingHUD];
    
    [SourceModel sourceListWithSuccess:^(NSArray *list) {
        
        self.sourceData = [self reverseSourceModelList:list];
        
        [self dismissLoadingHUD];
        
    } failure:^(NSError *error) {
        [self dismissLoadingHUD];
        [self showError:error];
    }];
    
}

- (NSArray *)reverseSourceModelList:(NSArray *)list {
    
    NSMutableArray *arr = [NSMutableArray array];
    
    for (SourceModel *model in list)
    {
        NSMutableArray *children = [NSMutableArray array];
        
        for (SourceChildren *child in model.children)
        {
            RADataObject *childObj = [[RADataObject alloc] initWithName:child.deptName children:nil];
            childObj.idStr = child.deptId;
            [children addObject:childObj];
        }
        
        RADataObject *data = [[RADataObject alloc] initWithName:model.deptName children:children];
        data.idStr = model.deptId;
        [arr addObject:data];
    }
    
    return arr;
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
    
    RADataObject *data = item;
    return [data.children count];
}

- (id)treeView:(RATreeView *)treeView child:(NSInteger)index ofItem:(id)item
{
    RADataObject *data = item;
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
    RADataObject *dataObject = item;
    
    NSInteger level = [self.treeView levelForCellForItem:item];
    
    RADataObject *parentObject = [treeView parentForItem:item];
    
    SourceViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([SourceViewCell class])];
    
    BOOL chooseBtnSelected = parentObject&&parentObject.isSelected?YES:dataObject.isSelected;
    
    dataObject.selected = chooseBtnSelected;
    
    [cell setupWithTitle:dataObject.name level:level chooseButtonSelected:chooseBtnSelected];
    
    [cell setArrowHiden:(dataObject.children.count==0)];
    
    //设置箭头的方向
    [cell setArrowDirection:dataObject.isArrowUp];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.chooseButtonAction = ^(SourceViewCell *cell,UIButton *button){
        
        BOOL expand = [treeView isCellExpanded:cell];
        
        dataObject.selected = button.selected;
        
        //没有展开同时父节点被选中
        if (!expand && dataObject.selected) {
            
            for (RADataObject * children in dataObject.children) {
                children.selected = YES;
            }
        }
        
        //刷新子节点
        if (expand)
        {
            [treeView reloadRowsForItems:dataObject.children withRowAnimation:RATreeViewRowAnimationFade];
        }
        
        //刷新父节点
        if (!dataObject.selected)
        {
            parentObject.selected = NO;
            
            if (parentObject)
            {
                [treeView reloadRowsForItems:@[parentObject] withRowAnimation:RATreeViewRowAnimationFade];
            }
        }
        
    };
    
    return cell;
}

- (void)treeView:(RATreeView *)treeView didSelectRowForItem:(id)item {
    
    RADataObject *dataObject = item;
    SourceViewCell *cell = (SourceViewCell *)[treeView cellForItem:dataObject];
    
    if ([cell isArrowHiden]) return;
    
    BOOL expand = [treeView isCellExpanded:cell];
    
    dataObject.arrowUp = !expand;
    //设置箭头的方向
    [cell setArrowDirection:!expand];
    
}


#pragma mark - getter setter
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

- (void)setSourceData:(NSArray *)sourceData {
    _sourceData = sourceData;
    [self.treeView reloadData];
}

@end