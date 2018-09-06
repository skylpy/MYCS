//
//  MemberDetailsController.m
//  MYCS
//
//  Created by wzyswork on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MemberDetailsController.h"

#import "MemberDetailCell.h"
#import "ServiceDetailsController.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#import "MemberInfo.h"

@interface MemberDetailsController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *introLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introLabelHeight;

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menusBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greenViewLeft;

@property (nonatomic,strong) UIButton *selectBtn;

@property (strong, nonatomic) NSMutableArray *dataSource
;

@end

@implementation MemberDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ScrollView.delegate = self;
   
    self.logoImageView.layer.cornerRadius = [self.logoImageView height]/2;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
     [self.tableView addHeaderWithTarget:self action:@selector(loadNewData)];
    [self.tableView headerBeginRefreshing];
    
    [self menusBtnAction:self.menusBtn[0]];
}
#pragma mark -- HTTP
- (void)loadNewData
{
    
    [MemberInfo requestMemberDetailWithUerId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] memberUID:self.memberUID success:^(MemberInfo *memberDetail) {
        
        [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:memberDetail.avatar] placeholderImage:[UIImage imageNamed:@"companyLogoDefault"]];

        self.introLabel.numberOfLines = 0;
        self.introLabel.text = memberDetail.introduction;
        [self.introLabel sizeToFit];
        self.introLabelHeight.constant = self.introLabel.height;
        
        self.dataSource = [NSMutableArray arrayWithArray:memberDetail.list];
        [self.tableView reloadData];
        
        [self.tableView headerEndRefreshing];

    } failure:^(NSError *error)
    {
        [self.tableView headerEndRefreshing];
        [self showError:error];
    }];
}
#pragma mark -- Back Action
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UITableViewDataSource, UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 48;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MemberDetailCell";
    MemberDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (self.dataSource.count > indexPath.row)
    {
        GradeModel *model = [self.dataSource objectAtIndex:indexPath.row];
        
        [cell setModel:model];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataSource.count > indexPath.row)
    {
        GradeModel *temp = [self.dataSource objectAtIndex:indexPath.row];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserManager" bundle:nil];
        ServiceDetailsController *controller = [storyboard instantiateViewControllerWithIdentifier:@"ServiceDetailsController"];
        
        controller.memberIDString = temp.memberID;
        
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
        
        __weak typeof(self)VC = self;
        controller.memberDetailVCRefleshBlock = ^(){
            [VC loadNewData];
        };
        
    }
}
#pragma mark -- menusBtn Action
- (IBAction)menusBtnAction:(UIButton *)sender {
    
    self.selectBtn.selected = NO;
    self.selectBtn = sender;
    self.selectBtn.selected = YES;
    NSUInteger tag = sender.tag;

     self.ScrollView.contentSize = CGSizeMake(ScreenW * 2, ScreenH - 207);
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.greenViewLeft.constant = sender.x;
        self.ScrollView.contentOffset = CGPointMake(ScreenW * tag, 0);
        
    } completion:^(BOOL finished) {
        
        if (tag == 0)
        {
            
        }else if (tag == 1)
        {
          
        }
     }];
}

#pragma mark - *** UIScrollView 代理 ***
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self.ScrollView)
    {
        return;
    }
    
    
    NSUInteger page = scrollView.contentOffset.x /ScreenW;
    if (page >= 2)
    {
        return;
    }
    
    UIButton *button = self.menusBtn[page];
    
    self.selectBtn.selected = NO;
    self.selectBtn = button;
    
    [self menusBtnAction:button];
    
}

@end
