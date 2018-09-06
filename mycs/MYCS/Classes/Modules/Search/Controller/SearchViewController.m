//
//  SearchViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/6.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SearchViewController.h"

#import "SearchModel.h"

#import "UIView+LineView.h"
#import "IQUIView+IQKeyboardToolbar.h"

#import "SearchResultsViewController.h"
#import "IQKeyboardManager.h"

//文件路劲
#define DOCPATHS [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject]

@interface SearchViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hotSearchViewConstH;

@property (weak, nonatomic) IBOutlet UIView *hotSearchView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *searchTag;

//热搜列表
@property (nonatomic,strong) NSArray *hotSearchLists;

@property (nonatomic,strong) NSMutableArray *historyLists;

@property (nonatomic,strong) UIControl * control;

@end

@implementation SearchViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.searchTextField resignFirstResponder];
}

-(void)searchClick
{
    [self.searchTextField resignFirstResponder];
    
    if (self.searchTextField.text.length == 0) {
        return;
    }
    
    [self addHistoryWith:[self.searchTextField.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    [self pushToSearchResultViewWithSearchText:self.searchTextField.text];
}
-(void)hidekeyBoard
{
    [self.searchTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.searchTextField.delegate = self;
    self.searchTextField.layer.cornerRadius = 4.0;
    self.searchTextField.clipsToBounds = YES;
    self.searchTextField.height = 30;
    self.searchTextField.width = ScreenW - 110;
    
    UIButton * leftView = ({
        
        UIButton * btn = [UIButton new];
        
        btn.frame = CGRectMake(0, 0, 30, 20);
        
        [btn setImage:[UIImage imageNamed:@"search"]forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    self.searchTextField.leftView = leftView;
    
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
      [self.searchTextField addLeftRightOnKeyboardWithTarget:self leftButtonTitle:@"取消" rightButtonTitle:@"搜索" leftButtonAction:@selector(hidekeyBoard) rightButtonAction:@selector(searchClick) shouldShowPlaceholder:YES];
    
    [self.searchTextField becomeFirstResponder];
    
    [self getData];
}
- (IBAction)cancelBatnAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - HTTP
- (void)getData
{
    [self showLoadingHUD];
    
    [SearchModel getHotSearchListSuccess:^(HotSearchListItemModel *model) {
        
        self.hotSearchLists = model.list;
        
        [self setupHotSearchView];
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        
    }];
    
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView reloadData];
}

#pragma mark - 热搜UI的创建
- (void)setupHotSearchView
{
    
    if (self.hotSearchLists)
    {
        
        CGFloat leftMargin = 20;
        CGFloat margin = 10;
        
        int col = 1;//列
        int row = 1;//行
        CGFloat btnX = leftMargin;
        CGFloat btnY = CGRectGetMaxY(_searchTag.frame)+10;
        
        for (int i = 0; i<self.hotSearchLists.count;)
        {
            
            NSString *searchWord = _hotSearchLists[i];
            
            UIButton *hotSearchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [hotSearchBtn setTitle:searchWord forState:UIControlStateNormal];
            [hotSearchBtn setTitleColor:HEXRGB(0xAAAAAA) forState:UIControlStateNormal];
            [hotSearchBtn addTarget:self action:@selector(hotsearchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            hotSearchBtn.layer.cornerRadius = 4;
            hotSearchBtn.layer.masksToBounds = YES;
            hotSearchBtn.layer.borderColor = HEXRGB(0xAAAAAA).CGColor;
            hotSearchBtn.layer.borderWidth = 1;
            
            hotSearchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            
#pragma mark -- 使用iOS7之后没有的方法报警告
            //CGSize size = [searchWord sizeWithFont:[UIFont systemFontOfSize:12]];
            //CGSize size =[searchWord sizeWithAttributes:@{ NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light" size:12.0] }];
            CGSize size = [searchWord sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0]}];
            
            CGFloat btnH = 32;
            CGFloat btnW = size.width + 30;
            btnX = btnX + (col - 1)*margin;
            btnY = btnY;
            [self.hotSearchView addSubview:hotSearchBtn];
            hotSearchBtn.frame = CGRectMake(btnX, btnY, btnW, btnH);
            
            if ((btnX + btnW)>self.view.width)
            {
                [hotSearchBtn removeFromSuperview];
                btnX = 20;
                col = 1;
                row ++;
                btnY = btnY + btnH + margin;
            }else
            {
                btnX = btnX+btnW+margin;
                i++;
            }
            
            if (i>self.hotSearchLists.count)
            {
                break;
            }
            
        }
        
    }
    
    [self dismissLoadingHUD];
    
    self.hotSearchViewConstH.constant = CGRectGetMaxY([self.hotSearchView.subviews lastObject].frame)+15;
    
    [self.view layoutIfNeeded];
}


#pragma mark -热搜点击 Action
- (void)hotsearchBtnAction:(UIButton *)button
{
    
    [self addHistoryWith:button.titleLabel.text];
    
    [self pushToSearchResultViewWithSearchText:button.titleLabel.text];
    
}

#pragma mark - 把搜索的数据保存
- (void)addHistoryWith:(NSString *)title
{
    
    //添加搜索历史
    NSInteger historyCount = self.historyLists.count;
    
    [self.historyLists addObject:title];
    
    if (historyCount == self.historyLists.count) return;

    NSString *filePath = [DOCPATHS stringByAppendingPathComponent:@"SearchList.data"];
    
    [NSKeyedArchiver archiveRootObject:self.historyLists toFile:filePath];
    
    //刷新数据
    [self.tableView reloadData];
}

#pragma mark -tableView Delegate and DataSourse
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    [self.control removeFromSuperview];
    
    if (self.historyLists.count == 0)
    {
        self.control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        [self.tableView addSubview:self.control];
        [self.control addTarget:self action:@selector(hidekeyBoard) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self.historyLists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *reuseID = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseID];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseID];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSString *searchHistory = self.historyLists[indexPath.row];
    cell.textLabel.text = searchHistory;
    
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.textColor = HEXRGB(0xaaaaaa);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 44;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self pushToSearchResultViewWithSearchText:cell.textLabel.text];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = ({
        
        UIView *view = [UIView new];
        
        view.frame = CGRectMake(0, 0, ScreenW, 44);
        
        view.backgroundColor = [UIColor whiteColor];
        
        [view addLineWithLineType:LineViewTypeBottom];
        
        view;
    });
    
    UILabel *historyTag = ({
        
        UILabel *label = [UILabel new];
        label.text = @"历史搜索:";
        
        label.textColor = HEXRGB(0x333333);
        label.font = [UIFont systemFontOfSize:13];
        
        [label sizeToFit];
        
        label.translatesAutoresizingMaskIntoConstraints = NO;
        
        [headerView addSubview:label];
        
        label;
    });
    
    UIControl * control = [[UIControl alloc] initWithFrame:headerView.frame];
    
    [headerView addSubview:control];
    
    [control addTarget:self action:@selector(hidekeyBoard) forControlEvents:UIControlEventTouchUpInside];
    
    NSLayoutConstraint *constCenterY = [NSLayoutConstraint constraintWithItem:historyTag attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *leftConst = [NSLayoutConstraint constraintWithItem:historyTag attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeLeft multiplier:1 constant:20];
    
    [headerView addConstraints:@[constCenterY,leftConst]];
    
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (self.historyLists.count == 0)
    {
        return ({
            
            UIView *view = [UIView new];
            
            view.frame = CGRectMake(0, 0, ScreenW, 44);
            
            view.backgroundColor = [UIColor whiteColor];
            
            view;
        });
    }
    
    UIView *footerView = ({
        
        UIView *view = [UIView new];
        
        view.frame = CGRectMake(0, 0, ScreenW, 44);
        
        [view addLineWithLineType:LineViewTypeBottom|LineViewTypeTop];
        
         view.backgroundColor = HEXRGB(0xEEEEEE);
        
        view;
    });
    
    UIButton *clearBtn = ({
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [button setTitle:@"清空搜索历史" forState:UIControlStateNormal];
        
        [button setTitleColor:HEXRGB(0x333333) forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        
        button.translatesAutoresizingMaskIntoConstraints = NO;
        button.backgroundColor = HEXRGB(0xEEEEEE);
        
        button.width = ScreenW;
        button.height = 44;
        
        [footerView addSubview:button];
        
        [button addTarget:self action:@selector(clearHistoryBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
        
        button;
    });
    
    NSLayoutConstraint *constCenterY = [NSLayoutConstraint constraintWithItem:clearBtn attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:footerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    NSLayoutConstraint *constCenterX = [NSLayoutConstraint constraintWithItem:clearBtn attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:footerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    [footerView addConstraints:@[constCenterY,constCenterX]];

    return footerView;
}

#pragma mark - 清空搜索历史事件
- (void)clearHistoryBtnDidClick
{
    [self hidekeyBoard];
    
    [self.historyLists removeAllObjects];
    
    NSString *SearchPath = [DOCPATHS stringByAppendingPathComponent:@"SearchList.data"];
    [NSKeyedArchiver archiveRootObject:self.historyLists toFile:SearchPath];
    
    [self.tableView reloadData];
}

- (NSMutableArray *)historyLists
{
    
    if (!_historyLists)
    {
    
        NSString *filePath = [DOCPATHS stringByAppendingPathComponent:@"SearchList.data"];
        NSMutableArray *arr = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        
        if (arr)
        {
            _historyLists = arr;
        }
        else{
            _historyLists = [NSMutableArray array];
        }
        
    }
    
    return _historyLists;
}

#pragma mark - 跳转到搜索结果界面
-(void)pushToSearchResultViewWithSearchText:(NSString *)searchText
{
    [self.searchTextField resignFirstResponder];
    
    SearchResultsViewController *resultViewController = [[UIStoryboard storyboardWithName:@"Search" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchResultsViewController"];
    
    resultViewController.keyWord = [searchText stringByTrimmingCharactersInSet:
                                    [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:resultViewController animated:YES];
    
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self pushToSearchResultViewWithSearchText: self.searchTextField.text];
    
    [self addHistoryWith:[textField.text stringByTrimmingCharactersInSet:
                          [NSCharacterSet whitespaceAndNewlineCharacterSet]]];
    
    [textField resignFirstResponder];
    
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.searchTextField resignFirstResponder];
}

@end
