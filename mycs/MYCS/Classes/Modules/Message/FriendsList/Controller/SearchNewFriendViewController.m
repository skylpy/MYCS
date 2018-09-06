//
//  SearchNewFriendViewController.m
//  MYCS
//
//  Created by Yell on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SearchNewFriendViewController.h"
#import "SearchNewFriendTableViewCell.h"
#import "PersonalInformationViewController.h"
#import "IQUIView+IQKeyboardToolbar.h"
#import "FriendModel.h"

@interface SearchNewFriendViewController ()<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (strong,nonatomic) NSMutableArray * dataSource;

@property (nonatomic,strong) UIControl * control;

@end

@implementation SearchNewFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.searchTextField.delegate = self;
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.title = @"搜索好友";
    self.listTableView.tableFooterView = [[UIView alloc]init];
    self.searchTextField.layer.cornerRadius = 2;
    
    
    [self.searchTextField addLeftRightOnKeyboardWithTarget:self leftButtonTitle:nil rightButtonTitle:@"完成" leftButtonAction:nil rightButtonAction:@selector(searchFriends) shouldShowPlaceholder:YES];
}
-(void)hidekeyBoard
{
    [self.searchTextField resignFirstResponder];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 
    [self.control removeFromSuperview];
    
    self.control = [[UIControl alloc] initWithFrame:CGRectMake(0, 60 * self.dataSource.count, ScreenW, ScreenH - 60 * self.dataSource.count)];
    [self.control addTarget:self action:@selector(hidekeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [self.listTableView addSubview:self.control];
    
    return self.dataSource.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchNewFriendTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SearchNewFriendTableViewCell" forIndexPath:indexPath];
    FriendModel * model = self.dataSource[indexPath.row];
    cell.model = model;
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendModel * model = self.dataSource[indexPath.row];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"FriendsList" bundle:nil];
    PersonalInformationViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"PersonalInformationViewController"];
    controller.model = model;
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchFriends];
    
    return YES;
    
}

-(void)searchFriends
{
    [self.searchTextField resignFirstResponder];
    [self showLoadingHUD];
    [FriendModel searchFriendWithKeyword:self.searchTextField.text Searchtype:nil Success:^(NSMutableArray *friendList) {
        self.dataSource = friendList;
        [self.listTableView reloadData];
        [self dismissLoadingHUD];
        
        if (friendList.count <=0)
        {
            [self showSuccessWithStatusHUD:@"未搜索到此人"];
        }
    } Failure:^(NSError *error) {
        [self dismissLoadingHUD];
        [self showSuccessWithStatusHUD:@"未搜索到此人"];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
