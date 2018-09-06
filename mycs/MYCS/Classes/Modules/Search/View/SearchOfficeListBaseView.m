
//
//  SearchOfficeListBaseView.m
//  MYCS
//
//  Created by wzyswork on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SearchOfficeListBaseView.h"

#import "SearchModel.h"

#import "SearchLaboratoryCell.h"
#import "SearchOfficeCell.h"
#import "UIImageView+WebCache.h"

#import "SearchMoreOtherController.h"

@interface SearchOfficeListBaseView()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moreBtnHeight;

@end

@implementation SearchOfficeListBaseView

+ (instancetype)searchOfficeListBaseView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SearchOfficeListBaseView" owner:nil options:nil] lastObject];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.hidden = YES;
    
}

-(void)setType:(OfficeType)type
{
    _type = type;
    
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
    
    if (self.type <= 2 )
    {
        static NSString *OfficeCellID = @"SearchOfficeCell";
        UINib * nib = [UINib nibWithNibName:@"SearchOfficeCell"
                                     bundle: [NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:OfficeCellID];
        
        SearchOfficeCell *cell = [tableView dequeueReusableCellWithIdentifier:OfficeCellID];
        
        
        if (self.type == OfficeTypeOffice)
        {
            searchAllOfficeDataModel *model = self.datasource[indexPath.row];
            
            [cell.personImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
            cell.nameLabel.text = model.realname;
            cell.positionLabel.text = model.divisionName;
            cell.goodAtLabel.text =[NSString stringWithFormat:@"擅长:%@",model.skill];
            
            
        }
        else if (self.type == OfficeTypeHospital)
        {
            
            searchAllHospitalDataModel *model = self.datasource[indexPath.row];
            
            [cell.personImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
            cell.nameLabel.text = model.realname;
            cell.positionLabel.text = model.levelStr;
            cell.goodAtLabel.text =[NSString stringWithFormat:@"擅长:%@",model.skill];
        }
        
        return cell;
    }
    else
    {
        
        static NSString *LaboratoryCellID = @"SearchLaboratoryCell";
        UINib * nib = [UINib nibWithNibName:@"SearchLaboratoryCell"
                                     bundle: [NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:LaboratoryCellID];
        
        SearchLaboratoryCell *cell = [tableView dequeueReusableCellWithIdentifier:LaboratoryCellID];
        
        
        if (self.type == OfficeTypeLaboratory)
        {
            searchAllLabDataModel *model = self.datasource[indexPath.row];
            
            [cell.personImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
            cell.nameLabel.text = model.realname;
            cell.goodAtLabel.numberOfLines = 2;
            cell.goodAtLabel.text =[NSString stringWithFormat:@"擅长:%@",model.skill];
        }
        else if (self.type == OfficeTypeEnterprise)
        {
            searchAllEnterpriseDataModel *model = self.datasource[indexPath.row];
            
            [cell.personImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
            cell.nameLabel.text = model.realname;
            cell.goodAtLabel.numberOfLines = 2;
            cell.goodAtLabel.text =[NSString stringWithFormat:@"擅长:%@",model.skill];
            
        }
        
        return cell;
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 94;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == OfficeTypeOffice)
    {
        searchAllOfficeDataModel * model = self.datasource[indexPath.row];
        
         [self pushofficeWithId:model.uid andType:self.type andYes:YES];
    }
    else if (self.type == OfficeTypeHospital)
    {
        searchAllHospitalDataModel * model = self.datasource[indexPath.row];
        
         [self pushofficeWithId:model.uid andType:self.type andYes:YES];
       
    }
    else if (self.type == OfficeTypeLaboratory)
    {
        
        searchAllLabDataModel * model = self.datasource[indexPath.row];
        
        [self pushofficeWithId:model.uid andType:self.type andYes:NO];
        
    }
    else if (self.type == OfficeTypeEnterprise)
    {
        
        searchAllEnterpriseDataModel * model = self.datasource[indexPath.row];
        
        [self pushofficeWithId:model.uid andType:self.type andYes:NO];
        
    }
    
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

-(void)pushofficeWithId:(NSString *)uid andType:(int)type andYes:(BOOL)yes
{
    OfficePagesViewController * vc = [[UIStoryboard storyboardWithName:@"Office" bundle:nil] instantiateViewControllerWithIdentifier:@"OfficePagesViewController"];
    
    vc.uid = uid;
    vc.type = type;
    vc.isHospitalOrOffice = yes;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
}

- (IBAction)moreBtnAction:(id)sender
{
    
    SearchMoreOtherController * vc = [[UIStoryboard storyboardWithName:@"Search" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchMoreOtherController"];
    
    vc.keyword = self.keyWord;
    vc.type = self.type;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
}


@end
