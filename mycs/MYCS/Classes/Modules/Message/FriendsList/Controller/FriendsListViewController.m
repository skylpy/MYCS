//
//  FriendsListViewController.m
//  MYCS
//  朋友列表
//  Created by Yell on 16/1/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "FriendsListViewController.h"
#import "FriendChatViewController.h"
#import "FriendsSearchView.h"
#import "FriendModel.h"
#import "FriendsListTableViewCell.h"
#import "NewFriendListViewController.h"
#import "SearchNewFriendViewController.h"

@interface FriendsListViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *listTableView;

@property (strong,nonatomic) NSMutableArray * dataSource;
@property (strong,nonatomic) NSMutableArray * headArr;
@property (strong,nonatomic) NSMutableArray * newsDataSource;
@property (nonatomic,assign) BOOL isHasNewFriends;

@end

@implementation FriendsListViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"好友列表";
    self.navigationController.navigationBarHidden = NO;
    
    UIBarButtonItem * btn = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(pushToAddView)];
    self.navigationItem.rightBarButtonItem = btn;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"addNewsFriends" object:nil];
}
-(void)getData
{
    [self getFriendsList];
}
-(void)getNewsFriends
{
    self.newsDataSource = [NSMutableArray array];
    [self.newsDataSource removeAllObjects];
    [FriendModel getRelationListSuccess:^(NSArray *list) {
        [self.newsDataSource addObjectsFromArray:list];
        for (FriendModel * model in list)
        {
            if (!model.isfriend && model.addStatus.intValue == 3)
            {
                self.isHasNewFriends = YES;
                
                break;
            }else
            {
                self.isHasNewFriends = NO;
            }
        }
        
        [self.listTableView reloadData];
        
    } Failure:^(NSError *error) {
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.dataSource.count <= 1)
    {
        [self getFriendsList];
    }
    [self getNewsFriends];
    self.tabBarController.tabBar.hidden = YES;
    
}

-(void)getFriendsList
{
//    [self showLoadingHUD];
    self.dataSource = [NSMutableArray array];
    self.headArr= [NSMutableArray array];
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.allowsSelection = YES;
    self.listTableView.sectionIndexColor = [UIColor blackColor];
    self.listTableView.sectionIndexBackgroundColor = [UIColor clearColor];
    self.listTableView.tableFooterView = [[UIView alloc]init];
    
    if (self.dataSource.count == 0)
        [self addNewFriendCell];
    
    [self.listTableView reloadData];
    [FriendModel getFriendListsSuccess:^(NSArray *list) {
        
//        [self dismissLoadingHUD];
        [self.dataSource removeAllObjects];
        [self addNewFriendCell];
        [self.dataSource addObjectsFromArray:list];
        [self.listTableView reloadData];
    } failure:^(NSError *error) {
//        [self dismissLoadingHUD];
//        [self.listTableView reloadData];
    }];
}

-(void)pushToAddView
{
    SearchNewFriendViewController * controller = [[UIStoryboard storyboardWithName:@"FriendsList" bundle:nil]instantiateViewControllerWithIdentifier:@"SearchNewFriendViewController"];
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return self.dataSource.count;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    FriendGroupModel * model = self.dataSource[section];
    return model.fans.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * identifier = @"FriendsListTableViewCell";
    FriendsListTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    FriendGroupModel * groupModel = self.dataSource[indexPath.section];
    FriendModel * model =groupModel.fans[indexPath.row];
    
    if (indexPath.section == 0 && indexPath.row == 0)
    {
        cell.nameLabel.text = model.name;
        [cell.imageBtn setBackgroundImage:[UIImage imageNamed:@"new-friend"] forState:UIControlStateNormal];
        if (self.isHasNewFriends)
        {
            cell.newsImage.hidden = NO;
        }else
        {
            cell.newsImage.hidden = YES;
        }
        cell.allowView.hidden = NO;
    }
    else
    {
        cell.model = model;
        cell.newsImage.hidden = YES;
        cell.allowView.hidden = YES;
    }
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return  section ==0?50:22;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView == self.searchDisplayController.searchResultsTableView)
    {
        return nil;
    }
    UIView *headView = [[UIView alloc]init];
    
    if (section!=0)
    {
        headView.backgroundColor = [UIColor clearColor];
        FriendGroupModel * model = self.dataSource[section];
        //标题背景
        UIView *biaotiView = [[UIView alloc]init];
        biaotiView.backgroundColor = HEXRGB(0xeeeeee);
        biaotiView.frame=CGRectMake(0, 0, self.view.frame.size.width, 22);
        [headView addSubview:biaotiView];
        
        //标题文字
        UILabel *lblBiaoti = [[UILabel alloc]init];
        lblBiaoti.backgroundColor = [UIColor clearColor];
        lblBiaoti.textAlignment = NSTextAlignmentLeft;
        lblBiaoti.font = [UIFont systemFontOfSize:15];
        lblBiaoti.textColor = [UIColor blackColor];
        lblBiaoti.frame = CGRectMake(5,2,self.view.frame.size.width, 15);
        lblBiaoti.text = model.sort;
        [biaotiView addSubview:lblBiaoti];
    }else
    {
        headView = [FriendsSearchView FriendsSearchView];
        headView.frame=CGRectMake(0, 0, self.view.frame.size.width, 50);
        
    }
    return headView;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    [self.headArr removeAllObjects];
    for (FriendGroupModel * model in self.dataSource) {
        [self.headArr addObject:model.sort];
    }
    return self.headArr;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        
        FriendsListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.newsImage.hidden = YES;
        NewFriendListViewController * controller = [[UIStoryboard storyboardWithName:@"FriendsList" bundle:nil]instantiateViewControllerWithIdentifier:@"NewFriendListViewController"];
        controller.dataSource = self.newsDataSource;
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
        return;
    }
    
    FriendGroupModel * gorupModel =self.dataSource[indexPath.section];
    FriendModel * model = gorupModel.fans[indexPath.row];
    
    
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


-(void)addNewFriendCell
{
    
    FriendModel * newFriendModel = [[FriendModel alloc]init];
    newFriendModel.name = @"新的朋友";
    FriendGroupModel * newFriendGroupModel = [[FriendGroupModel alloc]init];
    newFriendGroupModel.sort =@"{search}";
    NSArray *newFriendModelArr = [NSArray arrayWithObject:newFriendModel];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wincompatible-pointer-types"
    
    newFriendGroupModel.fans = [NSMutableArray arrayWithArray:newFriendModelArr];
    
#pragma clang diagnostic pop
    
    [self.dataSource addObject:newFriendGroupModel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

