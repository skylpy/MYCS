//
//  ChoosePersonsViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/11.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ChoosePersonsViewController.h"

#import "StaffModel.h"
#import "ServiceModel.h"

#import "ChoosePersonCell.h"

@interface ChoosePersonsViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (strong,nonatomic) NSMutableArray *dataSource;

@property (strong,nonatomic) NSMutableArray *selectArr;

@property (strong,nonatomic) NSString * keyWord;

@end

@implementation ChoosePersonsViewController

-(NSMutableArray *)selectMem
{
    if (_selectMem ==nil)
    {
        _selectMem = [NSMutableArray array];
    }
    return _selectMem;
}


-(NSMutableArray *)selectStaff
{
    if (_selectStaff ==nil)
    {
        _selectStaff = [NSMutableArray array];
    }
    return _selectStaff;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sureBtn.layer.cornerRadius = 4.0;
    self.sureBtn.clipsToBounds = YES;
    
    self.searchBar.delegate = self;
    
    self.dataSource = [NSMutableArray array];
    self.selectArr = [NSMutableArray array];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self getDataWithKeyWord:self.keyWord];
    
}
- (IBAction)backAction:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- hTTP
- (void)getDataWithKeyWord:(NSString *)keyword{
    if (_isMember)
    {//会员
        
        NSString * action;
        if (self.fromTask)
        {
            action = @"searchMember";
        }else
        {
            action = @"searchMemberByType";
        }
        
        [Mem listWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] action:action keyword:keyword success:^(NSArray *list) {
            
            if (self.fromTask)
            {
                for (Mem * men in list)
                {
                    men.uid = men.id;
                }
            }
            
            [self.dataSource removeAllObjects];
            
            self.dataSource = [self ChooseSelectDataWithList:list];
            
            [self.selectArr addObjectsFromArray:self.selectMem];
            
            [self.tableview reloadData];
            
        } failure:^(NSError *error) {
            //            [self showError:error];
        }];
    } else
    {//员工
        
        [StaffModel dataWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] action:@"searchStaff" keyword:keyword success:^(NSArray *list) {
            
            [self.dataSource removeAllObjects];
            
            self.dataSource = [self ChooseSelectDataWithList:list];
            
            [self.selectArr addObjectsFromArray:self.selectStaff];
            
            [self.tableview reloadData];
            
        } failure:^(NSError *error) {
            //                        [self showError:error];
        }];
    }
}
#pragma mark -- 筛选已选择的数据
-(NSMutableArray *)ChooseSelectDataWithList:(NSArray *)list
{
    NSMutableArray * arr = [NSMutableArray array];
    NSMutableArray * arr1 = [NSMutableArray array];
    
    [arr addObjectsFromArray:self.selectStaff];
    [arr1 addObjectsFromArray:self.selectMem];
    
    [self.selectMem removeAllObjects];
    [self.selectStaff removeAllObjects];
    
    NSMutableArray * Mutablelist = [NSMutableArray arrayWithArray:list];
    
    if (_isMember)
    {
        for (int i = 0; i < Mutablelist.count; i++)
        {
            Mem * men = Mutablelist[i];
            
            for (Mem * selectmen in arr1)
            {
                if ([men.uid isEqualToString: selectmen.uid])
                {
                    men.isSelected = YES;
                    
                    [self.selectMem addObject:men];
                }
            }
        }
        
        for (int i = 0; i < self.selectArr.count; i++)
        {
            Mem * men = self.selectArr[i];
            
            for (Mem * smen in self.selectStaff)
            {
                if ([men.uid isEqualToString: smen.uid])
                {
                    [self.selectArr removeObject:men];
                    
                    i--;
                }
            }
        }
        
    }else
    {
        for (int i = 0; i < Mutablelist.count; i++)
        {
            StaffModel * model = Mutablelist[i];
            
            for (StaffModel * selectModel in arr)
            {
                if ([model.uid isEqualToString: selectModel.uid])
                {
                    model.isSelected = YES;
                    
                    [self.selectStaff addObject:model];
                }
            }
        }
        
        for (int i = 0; i < self.selectArr.count; i++)
        {
            StaffModel * model = self.selectArr[i];
            
            for (StaffModel * selectModel in self.selectStaff)
            {
                if ([model.uid isEqualToString: selectModel.uid])
                {
                    [self.selectArr removeObject:model];
                    
                    i--;
                }
            }
        }
        

    }
    return Mutablelist;
}

#pragma mark - tableView delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isMember)
    {
        Mem *men = self.dataSource[indexPath.row];
        
        if (men.id == nil && men.name == nil)
        {
            return 15;
        }
    }else
    {
        StaffModel *model = self.dataSource[indexPath.row];
        
        if (model.uid == nil && model.username == nil)
        {
            return 15;
        }
    }
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSource count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ChoosePersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChoosePersonCell"];
    if (_isMember)
    {
        
        //设置间隔cell属性
        Mem *men = self.dataSource[indexPath.row];
        if (men.id == nil && men.name == nil)
        {
            cell.backgroundColor = RGBCOLOR(236, 236, 236);
            cell.chooseBtn.hidden = YES;
            cell.userInteractionEnabled = NO;
            cell.lbTitle.text = nil;
            cell.chooseBtn.selected = NO;
            
            return cell;
            
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
            cell.chooseBtn.hidden = NO;
            cell.userInteractionEnabled = YES;
            
        }
        
        cell.lbTitle.text = men.name.length > 0 ? men.name : @"";
        cell.chooseBtn.selected = men.isSelected;
        
    }else
    {
        
        //设置间隔cell属性
        StaffModel *model = self.dataSource[indexPath.row];
        if (model.uid == nil && model.username == nil)
        {
            cell.backgroundColor = RGBCOLOR(236, 236, 236);
            cell.userInteractionEnabled = NO;
            cell.chooseBtn.hidden = YES;
            cell.lbTitle.text = nil;
            cell.chooseBtn.selected = NO;
            
            return cell;
        }else
        {
            cell.backgroundColor = [UIColor whiteColor];
            cell.chooseBtn.hidden = NO;
            cell.userInteractionEnabled = YES;
            
        }
        
        cell.lbTitle.text = model.realname.length > 0 ? model.realname : @"";
        cell.chooseBtn.selected = model.isSelected;
        
    }
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.searchBar resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isMember)
    {
        Mem *men = self.dataSource[indexPath.row];
        men.isSelected = !men.isSelected;
        
        if (men.isSelected ==YES)
        {
            [self.selectArr addObject:men];
        }else
        {
            [self.selectArr removeObject:men];
        }
    }else
    {
        StaffModel *model = self.dataSource[indexPath.row];
        model.isSelected = !model.isSelected;
        
        if (model.isSelected ==YES)
        {
            [self.selectArr addObject:model];
        }else
        {
            [self.selectArr removeObject:model];
        }
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
}
#pragma mark -- 确认Action
- (IBAction)sureButtonAction:(UIButton *)sender {
    
    if (self.sureBtnBlock)
    {
        //        int type = 1;//员工
        //        if (_isMember)
        //        {
        //            type = 2;//会员
        //        }
        
        
        if (self.isMember)
        {
            
            self.sureBtnBlock(self.selectArr,2);
        }
        else
        {
            
            
            self.sureBtnBlock(self.selectArr,1);
        }
        
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - searchBarDelegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    [self getDataWithKeyWord:[searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
    [self.searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
