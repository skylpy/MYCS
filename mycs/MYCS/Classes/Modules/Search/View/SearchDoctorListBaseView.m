//
//  SearchDoctorListBaseView.m
//  MYCS
//
//  Created by wzyswork on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//


#import "SearchDoctorListBaseView.h"

#import "SearchModel.h"

#import "DoctorCell.h"
#import "UIImageView+WebCache.h"

#import "SearchMoreOtherController.h"
#import "DoctorsPageViewController.h"

@interface SearchDoctorListBaseView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreBtnHeight;

@end

@implementation SearchDoctorListBaseView

+ (instancetype)searchDoctorListBaseView
{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"SearchDoctorListBaseView" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
    
    [super awakeFromNib];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.hidden = YES;
    
}

-(void)reflesh
{
    if (self.datasource.count < 4)
    {
        self.moreBtn.hidden = YES;
        
        self.moreBtnHeight.constant = 0.1;
        
        self.height = 40 + self.datasource.count * 94;
        
    }else
    {
        self.moreBtn.hidden = NO;
        
        self.moreBtnHeight.constant = 50;
        
        self.height = CGRectGetMaxY(self.moreBtn.frame);
    }
    if (self.datasource.count > 0)
    {
        self.hidden = NO;
    }
    
    [self.tableView reloadData];
}

#pragma mark -tableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.datasource.count > 4)
    {
        return 4;
    }
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *DoctorCellID = @"DoctorCell";
    UINib * nib = [UINib nibWithNibName:@"DoctorCell"
                                 bundle: [NSBundle mainBundle]];
    [tableView registerNib:nib forCellReuseIdentifier:DoctorCellID];
    
    DoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:DoctorCellID];
    
    searchAllDoctorDataModel *model = self.datasource[indexPath.row];
    
    [cell.personImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
    cell.nameLabel.text = model.realname;
    [cell.nameLabel sizeToFit];
    cell.nameLConstraintW.constant = cell.nameLabel.width;
    cell.positionLabel.text = model.jobTitleName;
    cell.goodAtLabel.text =[NSString stringWithFormat:@"擅长:%@",model.goodat] ;
    cell.famousImageView.hidden = model.isAuth.integerValue == 1?NO:YES;
    cell.selectButton.hidden = YES;
    cell.famousImageView.hidden = model.isAuth.integerValue == 1?NO:YES;

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    searchAllDoctorDataModel *model = self.datasource[indexPath.row];
    
    DoctorsPageViewController * pageVC = [[UIStoryboard storyboardWithName:@"doctor" bundle:nil] instantiateViewControllerWithIdentifier:@"DoctorsPageViewController"];
    
    pageVC.uid = model.uid;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:pageVC animated:YES];
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
- (IBAction)moreBtnAction:(id)sender
{
    SearchMoreOtherController * vc = [[UIStoryboard storyboardWithName:@"Search" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchMoreOtherController"];
    
    vc.keyword = self.keyWord;
    vc.type = 0;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
    
}


@end

