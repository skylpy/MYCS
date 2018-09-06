//
//  DefinitionView.m
//  MYCS
//
//  Created by GuiHua on 16/6/29.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "DefinitionView.h"

@implementation DefinitionView

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.transform = CGAffineTransformTranslate(self.tableView.transform, 200, 0);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.tableView.transform = CGAffineTransformIdentity;
        
    }];
}

+(instancetype)showInView:(UIView *)superView andSelectStr:(NSString *)selectStr and:(void (^)())block
{
    DefinitionView *definitionView = [[[NSBundle mainBundle]  loadNibNamed:@"DefinitionView" owner:nil options:nil] lastObject];

    definitionView.frame = superView.bounds;
    definitionView.selectStr = selectStr;
    definitionView.block = block;
    
    [superView addSubview:definitionView];
    
    [definitionView showAndFade];
    
    return definitionView;
}

- (void)showAndFade {
    
    [self performSelector:@selector(dismissWithBlock:) withObject:nil afterDelay:10];
    
}

-(void)setSelectStr:(NSString *)selectStr
{
    _selectStr = selectStr;
    [self.tableView reloadData];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"tableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.textLabel.textColor = HEXRGB(0xaaaaaa);
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.userInteractionEnabled = YES;
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"高清";
        
    }else
    {
        cell.textLabel.text = @"标清";
    }
    
    if ([cell.textLabel.text isEqualToString:self.selectStr])
    {
        cell.textLabel.textColor = HEXRGB(0x47c1a8);
    }
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellClick:)];
    [cell addGestureRecognizer:tap];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (self.height - 100) / 2;
}

-(void)cellClick:(UITapGestureRecognizer *)tap
{
    UITableViewCell *cell = (UITableViewCell *)tap.view;
    
    if (self.cellClickBlock)
    {
        self.cellClickBlock(self,cell.textLabel.text);
        
        [self dismissWithBlock:self.block];
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [self dismissWithBlock:self.block];
    
}

- (void)dismissWithBlock:(void (^)())block {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.tableView.transform = CGAffineTransformMakeTranslation(200, 0);
        
    } completion:^(BOOL finished) {
        if (self.block)
        {
            self.block();
        }
        
        [self removeFromSuperview];
    }];
}

@end



