//
//  BDDynamicTreeCell.m
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

#import "BDDynamicTreeCell.h"

#define DepartmentCellHeight 44
#define EmployeeCellHeight  60

@interface BDDynamicTreeCell ()

- (IBAction)chooseBtnDidClick:(UIButton *)sender;

@property (nonatomic,assign) BOOL isChoose;

@end

@implementation BDDynamicTreeCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.chooseBtn setImage:[UIImage imageNamed:@"multiple_m"] forState:UIControlStateNormal];
    [self.chooseBtn setImage:[UIImage imageNamed:@"multiple_select"] forState:UIControlStateSelected];
}

+ (CGFloat)heightForCellWithType:(CellType)type
{
    return DepartmentCellHeight;
}

- (void)fillWithNode:(BDDynamicTreeNode*)node
{
    if (node) {
        
        self.chooseBtn.selected = node.isSelect;
        
        if (node.isOpen) {
            [self.indicatorView setImage:[UIImage imageNamed:@"listArrows_up"] forState:UIControlStateNormal];
        }else{
            [self.indicatorView setImage:[UIImage imageNamed:@"listArrows"] forState:UIControlStateNormal];
        }
        NSInteger cellType = node.isDepartment;
        
        [self setCellStypeWithType:cellType originX:node.originX];
        
        self.labelTitle.text = [NSString stringWithFormat:@"%@",node.name];
    }
}

- (void)setCellStypeWithType:(NSInteger)type originX:(CGFloat)x
{
    self.contentView.frame = CGRectMake(self.contentView.frame.origin.x,
                                        self.contentView.frame.origin.y,
                                        self.contentView.frame.size.width, DepartmentCellHeight);
    
    //设置 + 号的位置
    self.chooseBtn.frame = CGRectMake(x, self.chooseBtn.frame.origin.y,
                                      self.chooseBtn.frame.size.width,
                                      self.chooseBtn.frame.size.height);
    
    //设置 label的位置
    self.labelTitle.frame = CGRectMake(self.chooseBtn.frame.origin.x+self.chooseBtn.frame.size.width + 5/*space*/, 0,
                                       self.contentView.frame.size.width - self.chooseBtn.frame.origin.x - self.chooseBtn.frame.size.width - 5 - 5/*space*/,
                                       self.contentView.frame.size.height);
    
    
    //underline
    self.underLine.frame = CGRectMake(x,
                                      self.contentView.frame.size.height - 1,
                                      self.contentView.frame.size.width - x,
                                      1);
    self.underLine.backgroundColor = RGBCOLOR(230, 230, 230);
}

- (IBAction)chooseBtnDidClick:(UIButton *)sender {
    
    if ([self.cellDelegate respondsToSelector:@selector(selectAllChildrenNodes:)]) {
        [self.cellDelegate selectAllChildrenNodes:self];
    }
    
}
@end
