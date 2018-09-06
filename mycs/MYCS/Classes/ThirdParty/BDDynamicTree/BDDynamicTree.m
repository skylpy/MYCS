//
//  BDDynamicTree.m
//
//  Created by Scott Ban (https://github.com/reference) on 14/07/30.
//  Copyright (C) 2011-2020 by Scott Ban

//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "BDDynamicTree.h"
#import "BDDynamicTreeNode.h"
#import "BDDynamicTreeCell.h"
#import "ReceiverModel.h"

@interface BDDynamicTree () <UITableViewDataSource,UITableViewDelegate,BDDynamicTreeCellDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataSource;
    NSMutableArray *_nodesArray;
    
}

@property (strong, nonatomic)NSMutableArray * callBackSelectNodes;
@end


@implementation BDDynamicTree



- (id)initWithFrame:(CGRect)frame nodes:(NSArray *)nodes
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataSource = [[NSMutableArray alloc] init];
        _nodesArray = [[NSMutableArray alloc] init];
//        self.selectedNodes = [NSMutableArray array];
        
        if (nodes && nodes.count) {
            [_nodesArray addObjectsFromArray:nodes];
            
            //添加根节点
            [self rootNodes];
        }
        
        //tableview
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self searchNodesWithSelectNodes];
        [self addSubview:_tableView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame nodes:(NSArray *)nodes andSelectNode:(NSMutableArray *)selectNodes
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _dataSource = [[NSMutableArray alloc] init];
        _nodesArray = [[NSMutableArray alloc] init];
        //        self.selectedNodes = [NSMutableArray array];
        
        if (nodes && nodes.count) {
            [_nodesArray addObjectsFromArray:nodes];
            
            //添加根节点
            [self rootNodes];
        }
        
        //tableview
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)
                                                  style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.selectedNodes = [NSMutableArray array];
        self.callBackSelectNodes = [NSMutableArray array];
        self.callBackSelectNodes = selectNodes;
        [self searchNodesWithSelectNodes];
        [self addSubview:_tableView];
    }

    return self;
}


-(void)searchNodesWithSelectNodes
{
    for (int i = 0; i<self.callBackSelectNodes.count; i++) {
        ReceiverModel * nd = self.callBackSelectNodes[i];
        for (BDDynamicTreeNode * node in _dataSource) {
            if ([node.nodeId isEqualToString:nd.userID]) {
                node.isSelect =YES;

                [self nodeaddSelectNodes:node];

            }
        }
        
        for (BDDynamicTreeNode * node in _nodesArray) {
            if ([node.nodeId isEqualToString:nd.userID]) {
                node.isSelect =YES;

                [self nodeaddSelectNodes:node];


            }
        }
    }

}

#pragma mark - private methods

- (void)rootNodes
{
    for (BDDynamicTreeNode *node in _nodesArray) {
        if ([node isRoot]) {
            [_dataSource addObject: node];
        }
    }
}

//添加子节点
- (void)addSubNodesByFatherNode:(BDDynamicTreeNode *)fatherNode atIndex:(NSInteger )index
{
    if (fatherNode)
    {
        NSMutableArray *array = [NSMutableArray array];
        NSMutableArray *cellIndexPaths = [NSMutableArray array];
        
        NSUInteger count = index;
        for(BDDynamicTreeNode *node in _nodesArray) {
            if ([node.fatherNodeId isEqualToString:fatherNode.nodeId]) {
                node.originX = fatherNode.originX + 30/*space*/;
                [array addObject:node];
                [cellIndexPaths addObject:[NSIndexPath indexPathForRow:count++ inSection:0]];
                
            }
        }
        
        if (array.count) {
            fatherNode.isOpen = YES;
            fatherNode.subNodes = array;
            
            NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index,[array count])];
            [_dataSource insertObjects:array atIndexes:indexes];
            [_tableView insertRowsAtIndexPaths:cellIndexPaths withRowAnimation:UITableViewRowAnimationFade];
            [_tableView reloadData];
        }
    }
}

//根据节点减去子节点
- (void)minusNodesByNode:(BDDynamicTreeNode *)node
{
    if (node) {
        
        NSMutableArray *nodes = [NSMutableArray arrayWithArray:_dataSource];
        for (BDDynamicTreeNode *nd in nodes) {
            if ([nd.fatherNodeId isEqualToString:node.nodeId]) {
                [_dataSource removeObject:nd];
                [self minusNodesByNode:nd];
            }
        }
        
        node.isOpen = NO;
        [_tableView reloadData];
    }
}

- (void)setFatherNodesByNode:(BDDynamicTreeNode*)node{
    if (node) {
        for (BDDynamicTreeNode *nd in _dataSource) {
            if ([nd.nodeId isEqualToString:node.fatherNodeId]) { // 遍历出父节点
                
                [self allFatherNodeSelectedStatusByNode:nd];
                break;
            }
        }
    }
}


-(void)changeselectedNodes:(BDDynamicTreeNode *)node
{

    if (node.isDepartment == NO)
    {
        if (node.isSelect) {
            [self nodeaddSelectNodes:node];


        }else if (!node.isSelect)
        {
            [self.selectedNodes removeObject:node];
        }
    }else
    {
        if (node.isSelect) {
            [self nodeaddSelectNodes:node];

            

            
        }else
        {
            [self.selectedNodes removeObject:node];
        }
    }
}


-(void)nodeaddSelectNodes:(BDDynamicTreeNode *)node
{
    if (self.selectedNodes.count == 0) {
        [self.selectedNodes addObject:node];
        return;

    }
    for (BDDynamicTreeNode *nd in self.selectedNodes) {
        if ([nd.nodeId isEqualToString:node.nodeId]) {
            
            return;
        }
    }
    
    [self.selectedNodes addObject:node];

}

 //此方法是递归遍历出父节点（效率低，慎用）
- (void)allFatherNodeSelectedStatusByNode:(BDDynamicTreeNode*)node{
    if (!node ) {
        
        return ;
    }else if( !node.fatherNodeId)
    {
//        if (node.isSelect) {b
//            [self changeselectedNodes:node];
//            
//        }else if(!node.isSelect)
//        {
//            [self changeselectedNodes:node];
//        }
//        NSUInteger index=indexPath.row+1;
        
//        [self addSubNodesByFatherNode:node atIndex:index];
        
        
        return;
    }
    

    BDDynamicTreeNode *fatherNode = nil;
    for (BDDynamicTreeNode *nd in _dataSource) {
        if ([nd.nodeId isEqualToString:node.fatherNodeId]) {
//            
//            if (node.isSelect) {
//                [nd.selectSubNode addObject:node];
//                
//                
//                [self changeselectedNodes:node];
//                
//                
//                
//            }else if(!node.isSelect)
//            {
//                [nd.selectSubNode removeObject:node];
//                [self changeselectedNodes:node];
//
//                
//            }
//            
//            if (nd.selectSubNode.count == nd.subNodes.count) {
//                nd.isSelect = YES;
//                
//            }else
//            {
//                nd.isSelect = NO ;
//            }
//            
            
//            nd.isSelect = node.isSelect;
            fatherNode = nd;
            
            if (!node || !node.fatherNodeId) {
                return ;
            }else
            {
                [self allFatherNodeSelectedStatusByNode:nd];

            }
        }
    }
}


#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BDDynamicTreeNode *node = _dataSource[indexPath.row];
    CellType type = node.isDepartment?CellType_Department:CellType_Employee;
    return [BDDynamicTreeCell heightForCellWithType:type];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    BDDynamicTreeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        NSArray* topObjects = [[NSBundle mainBundle] loadNibNamed:@"BDDynamicTreeCell" owner:self options:nil];
        cell = [topObjects objectAtIndex:0];
    }
    
    cell.cellDelegate = self;
    
    cell.tag = indexPath.row;
    
    [cell fillWithNode:_dataSource[indexPath.row]];
    
    
    BDDynamicTreeNode *node = _dataSource[indexPath.row];
    if (node.isDepartment == NO) {
        cell.indicatorView.hidden = YES;
    }else
    {
        cell.indicatorView.hidden = NO;
    }



    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BDDynamicTreeNode *node = _dataSource[indexPath.row];
    
    BDDynamicTreeCell *cell = (BDDynamicTreeCell*)[tableView cellForRowAtIndexPath:indexPath];
//#warning 这里进行点击判断
    if (node.isDepartment == NO) {
        node.isSelect = !node.isSelect;

        [self changeselectedNodes:node];
        
        //判断节点的选中状态，如果选中则添加
//        if (node.isSelect) {
//            [self.selectedNodes addObject:node];
//        }else{
//            [self.selectedNodes removeObject:node];
//        }
        
//        [self setFatherNodesByNode:node];
//        [self allFatherNodeSelectedStatusByNode:node];
    }
    [tableView reloadData];
    
    if (node.isDepartment) {
        
    
        if (node.isOpen) {
            //减
            cell.indicatorView.selected = NO;
            [self minusNodesByNode:node];
        }
        else{
            //加一个
            cell.indicatorView.selected = YES;
            NSUInteger index=indexPath.row+1;
            
            [self addSubNodesByFatherNode:node atIndex:index];
        }
    }
    
    
}

#pragma mark - 选择按钮的点击事件
- (void)selectAllChildrenNodes:(BDDynamicTreeCell *)cell{

    
    BDDynamicTreeNode *fatherNode = _dataSource[cell.tag];
    if (fatherNode.isDepartment == 0) {
        return;
    }
    


    fatherNode.isSelect = !fatherNode.isSelect;
    
//    [self allFatherNodeSelectedStatusByNode:fatherNode];

    [self changeselectedNodes:fatherNode];
    NSInteger index = cell.tag + 1;

    
    if (fatherNode)
    {

        [self FindAllChildrenNodes:fatherNode andIndex:index];
    }
    else{

    }

    
}

//#warning  寻找下级节点
-(void)FindAllChildrenNodes:(BDDynamicTreeNode *)nd andIndex:(NSUInteger)index
{
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *cellIndexPaths = [NSMutableArray array];
    
    NSUInteger count = index;
    for(BDDynamicTreeNode *node in _nodesArray) {
        if ([node.fatherNodeId isEqualToString:nd.nodeId]) {

            node.originX = nd.originX + 30/*space*/;
            [array addObject:node];
            [cellIndexPaths addObject:[NSIndexPath indexPathForRow:count++ inSection:0]];
            
            node.isSelect = nd.isSelect;
            
            
            
            if (node.isSelect == YES) {
                [nd.selectSubNode addObject:node];
                [self changeselectedNodes:node];

            }else if (node.isSelect == NO)
            {
                [nd.selectSubNode removeObject:node];
                [self changeselectedNodes:node];

            }
            
            [self FindAllChildrenNodes:node andIndex:index];
            
        }else{

        }
        
        
        
    }
    
    if (array.count) {
        nd.isOpen = YES;
        nd.subNodes = array;
        
        [_tableView reloadData];
    }
    

    

}



- (BDDynamicTreeNode *)findFatherNode:(BDDynamicTreeNode *)node{
    if (!node || !node.fatherNodeId) {
        return nil;
    }
    BDDynamicTreeNode *fatherNode = nil;
    for (BDDynamicTreeNode *nd in _dataSource) {
        if ([nd.nodeId isEqualToString:node.fatherNodeId]) {
            nd.isSelect = node.isSelect;
            fatherNode = nd;
            break;
        }
    }
    return fatherNode;
}

@end
