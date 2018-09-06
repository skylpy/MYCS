//
//  SelectDeptView.m
//  MYCS
//
//  Created by GuiHua on 16/4/21.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SelectDeptView.h"
#import "VideoSpaceModel.h"
#import "RATreeView.h"

#import "SourceViewCell.h"
#import "TaskObject.h"
#import "UIView+Message.h"

static NSString *const reuseId = @"SelectSourceCell";

@interface SelectDeptView()<RATreeViewDelegate, RATreeViewDataSource>

@property (nonatomic,strong) NSMutableArray *sourceData;

@property (weak, nonatomic) RATreeView *treeView;

@property (nonatomic,strong)TaskObject * selectObj;

@property (nonatomic,strong)TaskObject * didSelectObj;//默认选中上一个

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic,copy) NSString * currentDeptId;

@property (nonatomic,copy) NSString * govType;
@end

@implementation SelectDeptView

+(void)showInView:(UIViewController *)view WithCurrentDeptId:(NSString *)deptid andGovType:(NSString *)govType WithBlock:(void (^)(NSString *, NSString *))sureBlock
{
    SelectDeptView *selectView = [[[NSBundle mainBundle] loadNibNamed:@"SelectDeptView" owner:nil options:nil]lastObject];
    
    selectView.sureBtnBlock = sureBlock;
    
    selectView.frame = [UIScreen mainScreen].bounds;
    
    selectView.y = ScreenH;
    
    selectView.currentDeptId = deptid;
    selectView.govType = govType;
    
    [selectView loadData];
    
    [view.navigationController.view addSubview:selectView];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        selectView.y = 0;
        
    } completion:^(BOOL finished) {
        
        
    }];
}

-(void)loadData
{
    self.sourceData = [NSMutableArray array];
    
    TaskObject *obj = [[TaskObject alloc] init];
    obj.deptName = @"全部";
    obj.deptId = -1;
    obj.children = nil;
    obj.arrowUp = NO;
    obj.expand = NO;
    
    if (self.currentDeptId.integerValue == -1)
    {
        obj.arrowUp = YES;
        obj.expand = YES;
        self.selectObj = obj;
        self.didSelectObj = obj;
    }
    
    [self.sourceData addObject:obj];
    
    [self requestData];
    
}

- (IBAction)closeAction:(id)sender
{
    self.sureBtnBlock(nil,nil);
    [self removeSelfFromSuperview];
}

- (IBAction)sureAction:(UIButton *)sender
{
    
    [self removeSelfFromSuperview];
    
    if (self.sureBtnBlock) {
        
        if (self.selectObj.expand)
        {
            self.sureBtnBlock([NSString stringWithFormat:@"%ld",(long)self.selectObj.deptId],self.selectObj.deptName);
        }else
        {
            self.sureBtnBlock([NSString stringWithFormat:@"%ld",(long)self.didSelectObj.deptId],self.didSelectObj.deptName);
        }
        
        
    }
    
}

#pragma mark - Http
- (void)requestData {
    
    [self showLoadingWithStatus:@"加载中..."];
    
    [TaskObject taskDepartmentDevelopmentCommissionConcatWithGovType:self.govType Success:^(NSArray *TaskObjectList) {
        
        if (self.currentDeptId && self.currentDeptId.integerValue != -1)
        {
            [self.sourceData addObjectsFromArray:[self selectTaskObjectWith:TaskObjectList and:nil and:TaskObjectList and:self.currentDeptId.integerValue]];
            
        }else
        {
            [self.sourceData addObjectsFromArray:TaskObjectList];
        }
        
        
        [self.treeView reloadData];
        
        [self expandRows:self.sourceData];
        
        [self dismissLoading];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        [self dismissLoading];
        
    }];
}

//arr为备份数组
-(NSArray *)selectTaskObjectWith:(NSArray *)list and:(TaskObject *)parentObj and:(NSArray *)arr and:(NSInteger)currentDeptId;
{
    
    for (TaskObject *obj in list)
    {
        if (obj.deptId == currentDeptId)
        {
            obj.expand = YES;
            
            self.selectObj = obj;
            
            self.didSelectObj = obj;
            
            if (obj.parent_id)
            {
                [self selectParentTaskObjectArrowUp:arr andParentId:obj.parent_id and:arr];
            }
            
        }else
        {
            if (obj.hasChild)
            {
                [self selectTaskObjectWith:obj.children and:obj and:arr and:currentDeptId];
            }
        }
    }
    
    return list;
}

-(void)selectParentTaskObjectArrowUp:(NSArray *)list andParentId:(NSInteger)parentId and:(NSArray *)arr
{
    for (TaskObject * obj in list)
    {
        if (obj.deptId == parentId)
        {
            obj.arrowUp = YES;
            
            if (obj.parent_id)
            {
                [self selectParentTaskObjectArrowUp:arr andParentId:obj.parent_id and:arr];
            }
        }
        else
        {
            if (obj.hasChild)
            {
                [self selectParentTaskObjectArrowUp:obj.children andParentId:parentId and:arr];
            }
        }
    }
}

-(void)expandRows:(NSArray *)list
{
    for (TaskObject *dataObject in list)
    {
        if (dataObject.isArrowUp)
        {
            [self.treeView expandRowForItem:dataObject];
            
            if (dataObject.hasChild)
            {
                [self expandRows:dataObject.children];
            }
        }
    }
    
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
    
    SourceViewCell *cell = [self.treeView dequeueReusableCellWithIdentifier:NSStringFromClass([SourceViewCell class])];
    
    [cell.chooseButton setImage:[UIImage imageNamed:@"radio_select"] forState:UIControlStateSelected];
    
    [cell.chooseButton setImage:[UIImage imageNamed:@"radio_m"] forState:UIControlStateNormal];
    
    [cell setupWithTitle:dataObject.deptName level:level chooseButtonSelected:dataObject.isExpand];
    
    [cell setArrowHiden:(dataObject.children.count==0)];
    
    //设置箭头的方向
    [cell setArrowDirection:dataObject.isArrowUp];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.chooseButtonAction = ^(SourceViewCell *cell,UIButton *button){
        
        self.selectObj.expand = NO;
        
        dataObject.expand = button.selected;
        
        if (self.selectObj && ![self.selectObj isEqual:dataObject])
        {
            [treeView reloadRowsForItems:[NSArray arrayWithObject:self.selectObj] withRowAnimation:RATreeViewRowAnimationFade];
        }
        
        self.selectObj = dataObject;
    };
    
    return cell;
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
#pragma mark - getter setter
- (RATreeView *)treeView {
    if (!_treeView)
    {
        RATreeView *treeView = [[RATreeView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64)];
        _treeView = treeView;
        
        treeView.delegate = self;
        treeView.dataSource = self;
        treeView.treeFooterView = [UIView new];
        treeView.separatorStyle = RATreeViewCellSeparatorStyleNone;
        treeView.editing = NO;
        
        [self.treeView registerNib:[UINib nibWithNibName:NSStringFromClass([SourceViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([SourceViewCell class])];
        
        [self.bgView addSubview:treeView];
    }
    return _treeView;
}


-(void)removeSelfFromSuperview{
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.y = ScreenH;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

@end
