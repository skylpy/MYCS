//
//  SelectTableCell.m
//  MYCS
//
//  Created by yiqun on 16/8/30.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SelectTableCell.h"
#import "TaskObject.h"


@implementation SelectTableCell


-(void)setTaskModel:(TaskObject *)taskModel{

    _taskModel = taskModel;
    
    self.titleLabel.text = taskModel.deptName;
    self.icon.hidden = [taskModel.hasChild isEqualToString:@"false"]?YES:NO;
    self.selectBtn.selected = taskModel.isSelect;
    [self selectedItems:taskModel.children andModel:taskModel];
    
    if (taskModel.childIndex == taskModel.children.count &&taskModel.hasChildSelect) {
        
        [self.selectBtn setImage:[UIImage imageNamed:@"cho_sh"] forState:UIControlStateSelected];
        
    }else if (taskModel.childIndex == 0) {
        
        [self.selectBtn setImage:[UIImage imageNamed:@"cho_non"] forState:UIControlStateNormal];
    }else{
    
        [self.selectBtn setImage:[UIImage imageNamed:@"cho_s"] forState:UIControlStateSelected];
    }
    
}
- (void)selectedItems:(NSArray *)list andModel:(TaskObject *)model{

    model.childIndex = 0;
    if (list.count > 0) {
        
        for (TaskObject * item in list) {
            
            if (item.isSelect)
            {
                model.hasChildSelect = YES;
                model.select = YES;
                model.childIndex ++;
                
            }
            else{
            
                model.noChildSelect = YES;
                model.childSelect = YES;
            }
            
            if (item.children.count>0)
            {
                [self selectedItems:item.children andModel:item];
                
            }
        }
    }
    
}

- (IBAction)selectAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    self.taskModel.select = sender.selected;
    

    [self selectItems:self.taskModel.children andSelect:sender.selected];
}
- (void)selectItems:(NSArray *)list andSelect:(BOOL)select{

    for (TaskObject * item in list) {
        
        item.select = select;
        if (item.children.count>0){
            [self selectItems:item.children andSelect:item.select];
        }
    }
}

@end
