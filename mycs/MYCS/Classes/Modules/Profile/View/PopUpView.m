//
//  PopUpView.m
//  退出二次确认
//
//  Created by yiqun on 16/4/15.
//  Copyright © 2016年 yiqun. All rights reserved.
//

#import "PopUpView.h"


@interface PopUpView()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sheetViewHight;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIView *sheetView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (retain,nonatomic) NSArray * dataArray;

@property (assign,nonatomic) BOOL fnBool;

@end

@implementation PopUpView

+ (instancetype)popUpView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"PopUpView" owner:nil options:nil] lastObject];
}

-(void)showInitView:(UIViewController *)controller array:(NSArray *)array bools:(BOOL)bools block:(void (^)(NSInteger))block{

    self.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    [controller.view.window addSubview:self];
    [controller.view.window bringSubviewToFront:self];
    self.sheetView.y = ScreenH;
    self.block = block;
    self.fnBool = bools;
    self.dataArray = array;

    [self setView];
}

-(void)setView{

    [UIView animateWithDuration:0.25 animations:^{
        self.bgView.alpha = 0.4;
        self.sheetView.y = 0;
    } completion:nil];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.scrollEnabled =NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    UINib * nib = [UINib nibWithNibName:@"PopUpCell" bundle:[NSBundle mainBundle]];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"PopUpCell"];
    [self.tableView reloadData];
    self.sheetViewHight.constant = self.tableView.contentSize.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    ComfirmModel *model = self.dataArray[indexPath.row];
    return [ComfirmModel countingSize:model.title fontSize:17 width:ScreenW-20].height+30;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [self.dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * PopUpCellID = @"PopUpCell";
    
    PopUpCell * cell = [tableView dequeueReusableCellWithIdentifier:PopUpCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    ComfirmModel *model = self.dataArray[indexPath.row];
    
    cell.titleLable.text = model.title;
    cell.titleLable.textColor = model.titleColor;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.fnBool) {
        
        if (indexPath.row == 0) {
            return;
        }
    }

    if (self.block){
        self.block(indexPath.row);
    }
    
    [self removeSelfFromSuperview];
}

-(void)removeSelfFromSuperview{

    [UIView animateWithDuration:0.25 animations:^{
        
        self.bgView.alpha = 0;
        self.sheetView.y = ScreenH;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
    }];
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    [self removeSelfFromSuperview];
}

@end

/*!
 @author Sky, 16-04-18 14:04:19
 
 @brief PopUpCell
 
 @since 
 */
@implementation PopUpCell


@end

/*!
 @author Sky, 16-04-18 11:04:25
 
 @brief ComfirmModel
 
 @since
 */
@implementation ComfirmModel

+ (instancetype)comfirmModelWith:(NSString *)title titleColor:(UIColor *)color {
    ComfirmModel *model = [ComfirmModel new];
    model.title         = title;
    model.titleColor    = color;
    
    return model;
}

#pragma mark - 动态高度
+ (CGSize)countingSize:(NSString *)str fontSize:(int)fontSize width:(float)width{
    // 高度估计文本大概要显示几行，宽度根据需求自己定义。 MAXFLOAT 可以算出具体要多高
    // label 可设置的最大高度和宽度
    CGSize size = CGSizeMake(width, MAXFLOAT);
    // 获取当前文本的属性
    NSDictionary *tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName,nil];
    CGSize actualsize = [str boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:tdic context:nil].size;
    
    return actualsize;
    
}
@end
