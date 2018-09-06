
//
//  SearchFriendListView.m
//  MYCS
//
//  Created by Yell on 16/1/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SearchFriendListView.h"
#import "SearchFriendListTableViewCell.h"
#import "FriendChatViewController.h"
#import "DataCacheTool.h"
#import "PersonalInformationViewController.h"

@interface SearchFriendListView ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,SearchFriendListTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (nonatomic,strong) NSMutableArray * listDataSource;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *searchBGView;

@property (nonatomic,strong) UIControl * control;

@end

@implementation SearchFriendListView

+(instancetype)SearchFriendListView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"SearchFriendListView" owner:nil options:nil]lastObject];
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    self.listTableView.tableFooterView = [[UIView alloc]init];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listDataSource = [NSMutableArray array];
    self.searchTextField.delegate = self;
    self.searchBGView.layer.cornerRadius = 2;
    [self.searchTextField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(search) name:UITextFieldTextDidChangeNotification object:nil];

}
-(void)search
{
    [self searchAction:nil];
}
- (IBAction)cancelAction:(UIButton *)sender {
    [self removeFromSuperview];
}

-(void)hidekeyBoard
{
    [self.searchTextField resignFirstResponder];
}

- (IBAction)searchAction:(id)sender {
    
    [self.listDataSource removeAllObjects];
    [self.listDataSource addObjectsFromArray: [DataCacheTool getFriendDataWithName:self.searchTextField.text ]];
    [self.listTableView reloadData];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction:nil];
    return YES;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self.control removeFromSuperview];
    
    self.control = [[UIControl alloc] initWithFrame:CGRectMake(0, 60 * self.listDataSource.count, ScreenW, ScreenH - 60 * self.listDataSource.count)];
    [self.control addTarget:self action:@selector(hidekeyBoard) forControlEvents:UIControlEventTouchUpInside];
    [self.listTableView addSubview:self.control];
    
    return self.listDataSource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * IdStr = @"SearchFriendListTableViewCell";
    UINib * nib = [UINib nibWithNibName:IdStr bundle:nil];
    
    [tableView registerNib:nib forCellReuseIdentifier:IdStr];
    
    
    SearchFriendListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:IdStr forIndexPath:indexPath ];
    FriendModel * model = self.listDataSource[indexPath.row];
    cell.deleagte = self;
    cell.model = model;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FriendModel * model = self.listDataSource[indexPath.row];
    [self removeFromSuperview];

    //新建一个聊天会话View Controller对象
    FriendChatViewController *chat = [[FriendChatViewController alloc]init];
    //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众账号等
    chat.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众账号服务为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = model.friendId;
    //设置聊天会话界面要显示的标题
    chat.title = model.name;
    //显示聊天会话界面
    
    chat.model = model;
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:chat animated:YES];

    
}

-(void)SearchFriendListTableViewCellClick:(FriendModel *)model
{
    [self removeFromSuperview];
    
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:@"FriendsList" bundle:nil];
    PersonalInformationViewController * controller = [storyboard instantiateViewControllerWithIdentifier:@"PersonalInformationViewController"];
    controller.model = model;
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
}
- (IBAction)buttonAction:(id)sender
{
    [self.searchTextField resignFirstResponder];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}
@end
