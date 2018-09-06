//
//  BDDynamicTreeCell.h
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

#import <UIKit/UIKit.h>
#import "BDDynamicTreeNode.h"

typedef enum {
    CellType_Department = 1, //目录
    CellType_Employee   //雇员
}CellType;


@class BDDynamicTreeCell;

//cell的代理方法
@protocol BDDynamicTreeCellDelegate <NSObject>

- (void)selectAllChildrenNodes:(BDDynamicTreeCell *)cell;

@end

@interface BDDynamicTreeCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIButton *chooseBtn;
@property (nonatomic, strong) IBOutlet UILabel *labelTitle;
@property (nonatomic, strong) IBOutlet UIView *underLine;
@property (nonatomic, strong) IBOutlet UIButton *indicatorView;

@property (nonatomic,assign) id<BDDynamicTreeCellDelegate> cellDelegate;


+ (CGFloat)heightForCellWithType:(CellType)type;

- (void)fillWithNode:(BDDynamicTreeNode*)node;

@end
