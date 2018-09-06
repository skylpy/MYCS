//
//  SearchMoreOtherController.m
//  MYCS
//
//  Created by wzyswork on 16/1/19.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SearchMoreOtherController.h"

#import "SearchModel.h"

#import "IQUIView+IQKeyboardToolbar.h"
#import "MJRefresh.h"
#import "SearchOfficeCell.h"
#import "SearchLaboratoryCell.h"
#import "InformationCell.h"
#import "DoctorCell.h"

#import "DoctorsPageViewController.h"
#import "WebViewDetailController.h"
#import "OfficePagesViewController.h"

@interface SearchMoreOtherController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSMutableArray * dataSourse;

@property (nonatomic,assign) int page;

@end

@implementation SearchMoreOtherController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchTextField resignFirstResponder];
    
}

-(void)searchClick
{
    [self.searchTextField resignFirstResponder];
    
    if (self.searchTextField.text.length == 0)
    {
        return;
    }
    [self.tableView headerBeginRefreshing];
}

-(void)hidekeyBoard
{
    [self.searchTextField resignFirstResponder];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.dataSourse = [NSMutableArray array];
    
    self.searchTextField.text = self.keyword;
    
    self.searchTextField.layer.cornerRadius = 4.0;
    self.searchTextField.clipsToBounds = YES;
    self.searchTextField.width = ScreenW - 110;
    
    UIButton * leftView = ({
        
        UIButton * btn = [UIButton new];
        
        btn.frame = CGRectMake(0, 0, 25, 15);
        
        btn.layoutMargins = UIEdgeInsetsMake(0, 5, 0, 5);
        
        [btn setImage:[UIImage imageNamed:@"search"]forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    self.searchTextField.leftView = leftView;
    
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
     [self.searchTextField addLeftRightOnKeyboardWithTarget:self leftButtonTitle:@"取消" rightButtonTitle:@"搜索" leftButtonAction:@selector(hidekeyBoard) rightButtonAction:@selector(searchClick) shouldShowPlaceholder:YES];
    
    self.searchTextField.delegate = self;
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView addFooterWithTarget:self action:@selector(loadMoreData)];
    
    //自动加载
    [self.tableView headerBeginRefreshing];
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)wrightClick:(UIBarButtonItem *)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
#pragma mark - tableView Delegate and DataSourse
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSourse.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.type == 0)
    {//医生
        static NSString *DoctorCellID = @"DoctorCell";
        UINib * nib = [UINib nibWithNibName:@"DoctorCell"
                                     bundle: [NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:DoctorCellID];
        
        DoctorCell *cell = [tableView dequeueReusableCellWithIdentifier:DoctorCellID];
        
        searchAllDoctorDataModel *model = self.dataSourse[indexPath.row];
        
        [cell.personImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
        cell.nameLabel.text = model.realname;
        [cell.nameLabel sizeToFit];
        cell.nameLConstraintW.constant = cell.nameLabel.width;
        cell.positionLabel.text = model.jobTitleName;
        cell.goodAtLabel.text =[NSString stringWithFormat:@"擅长:%@",model.goodat] ;
        cell.famousImageView.hidden = model.isAuth.integerValue == 1?NO:YES;
        cell.selectButton.hidden = YES;
        
        return cell;
        
        
    }else if (self.type == 1 || self.type == 2)
    {
        static NSString *OfficeCellID = @"SearchOfficeCell";
        UINib * nib = [UINib nibWithNibName:@"SearchOfficeCell"
                                     bundle: [NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:OfficeCellID];
        
        SearchOfficeCell *cell = [tableView dequeueReusableCellWithIdentifier:OfficeCellID];
        
        if (self.type == 1)
        {//科室
            searchAllOfficeDataModel *model = self.dataSourse[indexPath.row];
            
            [cell.personImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
            cell.nameLabel.text = model.realname;
            cell.positionLabel.text = model.hospital;
            cell.goodAtLabel.text =[NSString stringWithFormat:@"擅长:%@",model.skill];
            
        }
        else if (self.type == 2)
        {//医院
            searchAllHospitalDataModel *model = self.dataSourse[indexPath.row];
            
            [cell.personImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
            cell.nameLabel.text = model.realname;
            cell.positionLabel.text = model.levelStr;
            cell.goodAtLabel.text =[NSString stringWithFormat:@"擅长:%@",model.skill];
        }
        
        return cell;
        
    }else if (self.type == 3 || self.type == 4)
    {
        static NSString *LaboratoryCellID = @"SearchLaboratoryCell";
        UINib * nib = [UINib nibWithNibName:@"SearchLaboratoryCell"
                                     bundle: [NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:LaboratoryCellID];
        
        SearchLaboratoryCell *cell = [tableView dequeueReusableCellWithIdentifier:LaboratoryCellID];
        
        
        if (self.type == 3)
        {//实验室
            searchAllLabDataModel *model = self.dataSourse[indexPath.row];
            
            [cell.personImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
            cell.nameLabel.text = model.realname;
            cell.goodAtLabel.numberOfLines = 2;
            cell.goodAtLabel.text =[NSString stringWithFormat:@"擅长:%@",model.skill];
        }
        else if (self.type == 4)
        {//企业
            searchAllEnterpriseDataModel *model = self.dataSourse[indexPath.row];
            
            [cell.personImage sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:PlaceHolderImage];
            cell.nameLabel.text = model.realname;
            cell.goodAtLabel.numberOfLines = 2;
            cell.goodAtLabel.text =[NSString stringWithFormat:@"擅长:%@",model.skill];
            
        }
        
        return cell;
        
    }else
    {//名医资讯
        static NSString *NewsCellID = @"InformationCell";
        UINib * nib = [UINib nibWithNibName:@"InformationCell"
                                     bundle: [NSBundle mainBundle]];
        [tableView registerNib:nib forCellReuseIdentifier:NewsCellID];
        
        InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:NewsCellID];
        
        searchAllNewsDataModel * model = self.dataSourse[indexPath.row];
        
        [cell.ImageView sd_setBlurImageWithURL:[NSURL URLWithString:model.titlePic] placeholderImage:PlaceHolderImage];
        
        cell.TitleL.text = model.title;
        
        cell.ContentL.text = model.detail;
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        return cell;
        
        
    }
    
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.type == 0)
    {//医生
        searchAllDoctorDataModel *model = self.dataSourse[indexPath.row];
        
        DoctorsPageViewController * pageVC = [[UIStoryboard storyboardWithName:@"doctor" bundle:nil] instantiateViewControllerWithIdentifier:@"DoctorsPageViewController"];
        
        pageVC.uid = model.uid;
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:pageVC animated:YES];
        
    }else if (self.type == 1)
    {//科室
        
        searchAllOfficeDataModel *model = self.dataSourse[indexPath.row];
        
        [self pushofficeWithId:model.uid andType:self.type andYes:YES];
        
    }else if (self.type == 2)
    {//医院
        searchAllHospitalDataModel *model = self.dataSourse[indexPath.row];
        
        [self pushofficeWithId:model.uid andType:self.type andYes:YES];
        
    }else if (self.type == 3)
    {//实验室
        
        searchAllLabDataModel *model = self.dataSourse[indexPath.row];
        
        [self pushofficeWithId:model.uid andType:self.type andYes:NO];
        
    }else if (self.type == 4)
    {//企业
        
        searchAllEnterpriseDataModel *model = self.dataSourse[indexPath.row];
        
        [self pushofficeWithId:model.uid andType:self.type andYes:NO];
        
    }else if (self.type == 5)
    {//资讯
        
        searchAllNewsDataModel *model = self.dataSourse[indexPath.row];
        
        WebViewDetailController *webVC = [[UIStoryboard storyboardWithName:@"WebView" bundle:nil] instantiateViewControllerWithIdentifier:@"WebViewDetailController"];
        
        webVC.urlStr = model.linkURL;
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:webVC animated:YES];
        
    }
    
}

#pragma mark - 跳到 医院，科室，实验室，企业 Action
-(void)pushofficeWithId:(NSString *)uid andType:(int)type andYes:(BOOL)yes
{
    OfficePagesViewController * vc = [[UIStoryboard storyboardWithName:@"Office" bundle:nil] instantiateViewControllerWithIdentifier:@"OfficePagesViewController"];
    
    vc.uid = uid;
    vc.type = type;
    vc.isHospitalOrOffice = yes;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -Http
- (void)loadNewData{
    
    self.page = 1;
    
    NSString *trimmedString = [self.searchTextField.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.keyword = trimmedString;
    
    [SearchModel SearhOtherWithKeyWord:self.keyword type:self.type page:[NSString stringWithFormat:@"%i",self.page] Success:^(NSMutableArray *ListArr) {
        
        [self.dataSourse removeAllObjects];
        [self.dataSourse addObjectsFromArray:ListArr];
        
        [self.tableView reloadData];
        
        [self.tableView headerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        [self.tableView headerEndRefreshing];
    }];
    
    
}

- (void)loadMoreData{
    self.page ++;
    
    NSString *trimmedString = [self.searchTextField.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.keyword = trimmedString;
    
    [SearchModel SearhOtherWithKeyWord:self.keyword type:self.type page:[NSString stringWithFormat:@"%i",self.page] Success:^(NSMutableArray *ListArr) {
        
        [self.dataSourse addObjectsFromArray:ListArr];
        
        [self.tableView reloadData];
        
        [self.tableView footerEndRefreshing];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        [self.tableView footerEndRefreshing];
    }];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.tableView headerBeginRefreshing];
    
    [textField resignFirstResponder];
    
    return YES;
}


@end
