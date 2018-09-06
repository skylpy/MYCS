//
//  sopDetailView.m
//  MYCS
//
//  Created by wzyswork on 16/2/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "sopDetailView.h"
#import "sopDetailCell.h"
#import "CourseOfSOP.h"

@implementation sopDetailView

+(instancetype)getSopDetailView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"sopDetailView" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 35;
    
}
-(void)setSopSourse:(NSArray *)sopSourse
{
    _sopSourse = sopSourse;
    
    [self.tableView reloadData];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sopSourse.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *DoctorCellID = @"sopCell";
    UINib * nib = [UINib nibWithNibName:@"sopDetailCell"
                                 bundle: [NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:DoctorCellID];
    
    sopDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:DoctorCellID];
    
    CourseOfSOP *courseOfSop = self.sopSourse[indexPath.row];
    cell.nameL.text = [NSString stringWithFormat:@"%d、%@",(int)indexPath.row+1,courseOfSop.courseName];
    cell.passL.text = [NSString stringWithFormat:@"%d%%",courseOfSop.pass_rate];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.sopSourse.count > 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
        view.backgroundColor = RGBCOLOR(133, 206, 243);
        
        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 20)];
        leftLabel.backgroundColor = [UIColor clearColor];
        leftLabel.font = [UIFont systemFontOfSize:14];
        leftLabel.textColor = [UIColor whiteColor];
        leftLabel.text = @"教程";
        [view addSubview:leftLabel];
        
        UILabel *rigthLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW-85, 0, 100, 20)];
        rigthLabel.backgroundColor = [UIColor clearColor];
        rigthLabel.textAlignment = NSTextAlignmentCenter;
        rigthLabel.font = [UIFont systemFontOfSize:14];
        rigthLabel.textColor = [UIColor whiteColor];
        rigthLabel.text = @"通过指标";
        [view addSubview:rigthLabel];
        
        return view;
    }
    return nil;
}
@end












