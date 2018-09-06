//
//  MessageHomeViewController.m
//  MYCS
//  消息列表
//  Created by Yell on 16/1/7.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MessageHomeViewController.h"
#import "FriendConversationViewController.h"
#import "FriendsListViewController.h"
#import "SearchNewFriendViewController.h"
#import "FriendChatViewController.h"
#import "commentTypeListViewController.h"
#import "friendModel.h"
#import "ConstKeys.h"
#import "DataCacheTool.h"
#import "EvaluationModel.h"
#import "NewMessagesTool.h"

@interface MessageHomeViewController ()<FriendConversationViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *commentView;

@property (weak, nonatomic) IBOutlet UIView *listView;

@property (weak, nonatomic) IBOutlet UILabel *newsNumbL;

@property (strong,nonatomic) FriendConversationViewController * conversationViewController;

@property (strong, nonatomic)  UIBarButtonItem *friendsBarButton;

@property (strong, nonatomic)  UIBarButtonItem *addBarButton;

@property (strong,nonatomic) UIButton * barButton;

@property (nonnull,strong) UIView * redView;

@end

@implementation MessageHomeViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.newsNumbL.layer.cornerRadius = self.newsNumbL.width / 2;
    self.newsNumbL.clipsToBounds = YES;
    [self buildUI];
    self.title = @"消息";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetList) name:ConnectIMSeverSuccess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetList) name:NewIMMessage object:nil];
    
    self.redView = [[UIView alloc] initWithFrame:CGRectMake(32, 17, 10, 10)];
    self.redView.layer.cornerRadius = 6;
    self.redView.backgroundColor = HEXRGB(0xFF463A);
    self.redView.clipsToBounds = YES;
    self.redView.hidden = YES;
    
    self.barButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.barButton setImage:[UIImage imageNamed:@"friends"] forState:UIControlStateNormal];
    [self.barButton addTarget:self action:@selector(FriendListAction) forControlEvents:UIControlEventTouchUpInside];
    self.barButton.frame = CGRectMake(0, 0, 55, 64);
    [self.barButton setImageEdgeInsets:UIEdgeInsetsMake(-5, 0, 0, 0)];
    [self.barButton addSubview:self.redView];
    
    self.friendsBarButton = [[UIBarButtonItem alloc] initWithCustomView:self.barButton];
    
    self.addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(AddFriendAction)];
    
    self.navigationItem.rightBarButtonItems = @[self.addBarButton,self.friendsBarButton];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getNotReadComment];
    [self getNewFriends];
    [self resetList];
    self.tabBarController.tabBar.hidden = NO;
    
    if ([AppManager hasLogin])
    {
        //监听未读消息
        [[NewMessagesTool sharedNewMessagesTool] startCheck];
    }
}

-(void)getNewFriends
{
    self.redView.hidden = YES;
    [FriendModel getRelationListSuccess:^(NSArray *list)
     {
         for (FriendModel * model in list)
         {
             if (!model.isfriend && model.addStatus.intValue == 3)
             {
                 self.redView.hidden = NO;
                 
                 break;
                 
             }
         }
         
     } Failure:^(NSError *error) {
         
     }];
}

-(void)getNotReadComment
{
    self.newsNumbL.hidden = YES;
    
    [EvaluationModel getNotReadCommentCountSuccess:^(NSArray *list) {
        
        
        int count = 0;
        
        for (EvaluationCommentCountModel * obj in list)
        {
            if (obj.count.intValue > 0)
            {
                
                count += obj.count.intValue;
            }
        }
        
        if (count > 0)
        {
            self.newsNumbL.hidden = NO;
            
            if (count <= 99)
            {
                self.newsNumbL.font = [UIFont systemFontOfSize:12];
                self.newsNumbL.text = [NSString stringWithFormat:@"%d",count];
            }
            else
            {
                self.newsNumbL.font = [UIFont systemFontOfSize:10];
                self.newsNumbL.text = @"99+";
            }
        }
        
        
    } Failure:^(NSError *error) {
        
    }];
}

#pragma mark 按钮Action
- (void)FriendListAction{
    
    self.redView.hidden = YES;
    
    FriendsListViewController * controller = [[UIStoryboard storyboardWithName:@"FriendsList" bundle:nil]instantiateViewControllerWithIdentifier:@"FriendsListViewController"];
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
    
}
- (void)AddFriendAction{
    
    SearchNewFriendViewController * controller = [[UIStoryboard storyboardWithName:@"FriendsList" bundle:nil]instantiateViewControllerWithIdentifier:@"SearchNewFriendViewController"];
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
}

- (IBAction)commenttypeListAction:(id)sender {
    commentTypeListViewController * controller = [[UIStoryboard storyboardWithName:@"Message" bundle:nil]instantiateViewControllerWithIdentifier:@"commentTypeListViewController"];
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
}



-(void)resetList
{
    [self.conversationViewController refreshConversationTableViewIfNeeded];
}


#pragma mark 设置会话列表大小

-(void)buildUI
{
    [self.listView addSubview:self.conversationViewController.view];
    
    [self addConstToConverSationView];
}

- (void)addConstToConverSationView {
    self.conversationViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    UIView *subView = self.conversationViewController.view;
    
    NSString *hVFL = @"H:|-(0)-[subView]-(0)-|";
    NSString *vVFL = @"V:|-(0)-[subView]-(0)-|";
    
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(subView)];
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(subView)];
    
    [self.listView addConstraints:hConsts];
    [self.listView addConstraints:vConsts];
}

#pragma mark 会话列表方法
-(FriendConversationViewController *)conversationViewController
{
    if (_conversationViewController == nil) {
        NSNumber * privateNum =[NSNumber numberWithInt:ConversationType_PRIVATE];
        NSArray *ConversationTypesArr = [NSArray arrayWithObject:privateNum];
        _conversationViewController = [[FriendConversationViewController alloc]initWithDisplayConversationTypes:ConversationTypesArr collectionConversationType:nil];
        _conversationViewController.listDelegate = self;
    }
    return _conversationViewController;
}

-(void)selectListCellWithTargetId:(NSString *)targetId
{
    
    FriendChatViewController * chatVC = [[FriendChatViewController alloc]initWithConversationType:ConversationType_PRIVATE targetId:targetId];
    
    FriendModel * model = [DataCacheTool getFriendDataWithfriendId:targetId];
    
    chatVC.conversationType = ConversationType_PRIVATE;
    if (model.friendId) {
        chatVC.targetId = model.friendId;
        chatVC.title = model.name;
        chatVC.model = model;
        
        [self.navigationController pushViewController:chatVC animated:YES];
    }else
    {
        [FriendModel searchFriendWithKeyword:targetId Searchtype:@"fanId" Success:^(NSMutableArray *friendList) {
            FriendModel * friendModel = friendList[0];
            chatVC.targetId = friendModel.friendId;
            chatVC.title = friendModel.name;
            chatVC.model = friendModel;
            
            [self.navigationController pushViewController:chatVC animated:YES];
            
        } Failure:^(NSError *error) {
            
            [self showErrorMessage:@"查无此人"];
        }];
    }
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
