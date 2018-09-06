//
//  MailBoxHomeViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MailBoxHomeViewController.h"

#import "InboxListTableViewController.h"
#import "OutboxListTableViewController.h"
#import "MailBoxEditorViewController.h"

@interface MailBoxHomeViewController ()<UISearchBarDelegate>

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menusBtn;

@property (weak, nonatomic) IBOutlet UIView *greenView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greenViewCenterX;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UIView *bgMailBoxView;

@property (nonatomic,strong) UIButton *selectBtn;

@property (nonatomic,assign) int MailBoxtype;

@property (nonatomic,strong)InboxListTableViewController * inVC;

@property (nonatomic,strong)OutboxListTableViewController * outVC;

@end

@implementation MailBoxHomeViewController

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [UMAnalyticsHelper endLogPageName:@"信箱"];
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [UMAnalyticsHelper beginLogPageName:@"信箱"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"邮箱";
    
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"write"] style:UIBarButtonItemStyleDone target:self action:@selector(responseRightButton)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    self.searchBar.delegate = self;
    
    self.inVC = [[UIStoryboard storyboardWithName:@"Mailbox" bundle:nil] instantiateViewControllerWithIdentifier:@"InboxListTableViewController"];
    
    self.outVC = [[UIStoryboard storyboardWithName:@"Mailbox" bundle:nil] instantiateViewControllerWithIdentifier:@"OutboxListTableViewController"];
    
    
    UIButton *btn = [self.menusBtn firstObject];
    [self menuBtnAction:btn];
    
}

#pragma mark --  edict Message Action
-(void)responseRightButton
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Mailbox" bundle:nil];
    MailBoxEditorViewController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MailBoxEditorViewController"];
    
    controller.sendType = 0;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
    
}
#pragma mark -- 收件箱或者发件箱 Action
- (IBAction)menuBtnAction:(UIButton *)sender
{
    
    self.selectBtn.selected = NO;
    self.selectBtn = sender;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    NSUInteger tag = sender.tag;
    self.MailBoxtype = (int)tag;
    
    
    self.greenViewCenterX.constant = (self.view.width*0.5)*tag;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.selectBtn.selected = YES;
        
    }];
    for (UIView * view in self.bgMailBoxView.subviews)
    {
        [view removeFromSuperview];
    }
    if (tag == 0)
    {
        self.inVC.view.height = self.bgMailBoxView.height;
        self.inVC.view.width = self.bgMailBoxView.width;
        [self.bgMailBoxView addSubview:self.inVC.view];
        
    }
    else if (tag == 1)
    {
        self.outVC.view.height = self.bgMailBoxView.height;
        self.outVC.view.width = self.bgMailBoxView.width;
        [self.bgMailBoxView addSubview:self.outVC.view];
    }
}

#pragma mark --  searchBar Delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    NSString * keyWord = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (keyWord.length<=0)keyWord = nil;

    if (self.MailBoxtype == 0)
    {//收件箱
        
        self.inVC.keyword = keyWord;
        
    }else
    {//发件箱
        
        self.outVC.keyword = keyWord;
    }
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString * keyWord = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if (keyWord.length<=0)keyWord = nil;
    
    [searchBar resignFirstResponder];
    
    if (self.MailBoxtype == 0)
    {
 
        self.inVC.keyword = keyWord;
        
    }else
    {
        self.outVC.keyword = keyWord;
    }
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
