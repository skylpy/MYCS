//
//  SearchResultsViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/18.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "SearchResultsViewController.h"

#import "SearchVideoListBaseView.h"
#import "SearchDoctorListBaseView.h"
#import "SearchNewsListBaseView.h"
#import "SearchOfficeListBaseView.h"
#import "OfficePagesViewController.h"
#import "SearchModel.h"

#import "IQUIView+IQKeyboardToolbar.h"

@interface SearchResultsViewController ()<UITextFieldDelegate,UIScrollViewDelegate>


@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic,strong) SearchVideoListBaseView *videoView;

@property(nonatomic,strong) SearchDoctorListBaseView *doctorView;

@property(nonatomic,strong) SearchNewsListBaseView *newsView;

@property(nonatomic,strong)NSDictionary *AllDataSourceDict;

@property (nonatomic,strong) UIControl * controlVideo;

@property (nonatomic,strong) UIControl * controlDoctor;

@property (nonatomic,strong) UIControl * controlNews;

@end

@implementation SearchResultsViewController


-(UIControl *)controlVideo
{
    if (!_controlVideo)
    {
        _controlVideo = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        [_controlVideo addTarget:self action:@selector(hidekeyBoard) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _controlVideo;
}

-(UIControl *)controlDoctor
{
    if (!_controlDoctor)
    {
        _controlDoctor = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        [_controlDoctor addTarget:self action:@selector(hidekeyBoard) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _controlDoctor;
}
-(UIControl *)controlNews
{
    if (!_controlNews)
    {
        _controlNews = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 40)];
        [_controlNews addTarget:self action:@selector(hidekeyBoard) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _controlNews;
}
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
    [self searchAllDataWithKeyWord];
}

-(void)hidekeyBoard
{
    [self.searchTextField resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.AllDataSourceDict = [NSMutableDictionary dictionary];
    
    self.searchTextField.layer.cornerRadius = 4.0;
    self.searchTextField.clipsToBounds = YES;
    self.searchTextField.text = self.keyWord;
    self.searchTextField.width = ScreenW - 110;
    self.searchTextField.height = 30;
    
    UIButton * leftView = ({
        
        UIButton * btn = [UIButton new];
        
        btn.frame = CGRectMake(0, 0, 30, 20);
        
        [btn setImage:[UIImage imageNamed:@"search"]forState:UIControlStateNormal];
        
        [btn addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
        
        btn;
    });
    
    self.searchTextField.delegate = self;
    
    self.searchTextField.leftView = leftView;
    
    self.searchTextField.leftViewMode = UITextFieldViewModeAlways;
    
    [self.searchTextField addLeftRightOnKeyboardWithTarget:self leftButtonTitle:@"取消" rightButtonTitle:@"完成" leftButtonAction:@selector(hidekeyBoard) rightButtonAction:@selector(searchClick) shouldShowPlaceholder:YES];
    
    self.scrollView.delegate = self;
    
    [self searchAllDataWithKeyWord];
    
}
#pragma mark - Http
-(void)searchAllDataWithKeyWord
{
    for (UIView * view in self.scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    self.videoView = [SearchVideoListBaseView SearchVideoListBaseView];
    [self.videoView.headView addSubview:self.controlVideo];
    
    
    self.doctorView = [SearchDoctorListBaseView searchDoctorListBaseView];
    [self.doctorView.headView addSubview:self.controlDoctor];
    
    self.newsView = [SearchNewsListBaseView searchNewsListBaseView];
    [self.newsView.headView addSubview:self.controlNews];
    
    [self showLoadingHUD];
    
    NSString *trimmedString = [self.searchTextField.text stringByTrimmingCharactersInSet:
                               [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    self.keyWord = trimmedString;
    
    [SearchModel SearhAllListWithKeyWord:self.keyWord Success:^(NSMutableDictionary *ListDict) {
        
        self.AllDataSourceDict = ListDict;
        
        [self layoutDetailViews];
        
        [self dismissLoadingHUD];
        
    } failure:^(NSError *error) {
        
        [self showError:error];
        
        [self dismissLoadingHUD];
        
    }];
}



#pragma mark - build Data List
-(void)layoutDetailViews
{
    BOOL isHasData = NO;
    
    CGFloat totalHeight = 0;
    
    if([[self.AllDataSourceDict objectForKey:@"0"] count] > 0)
    {
        self.videoView.width = self.view.width;
        self.videoView.y = totalHeight + 10;
        self.videoView.titleLabel.text = @"视频";
        self.videoView.datasource = [NSMutableArray array];
        [self.videoView.datasource addObjectsFromArray:[self.AllDataSourceDict objectForKey:@"0"]];
        self.videoView.type = 1;
        self.videoView.keyWord = self.keyWord;
        [self.scrollView addSubview:self.videoView];
        
        if (self.videoView.hidden == NO)
        {
            totalHeight += self.videoView.height + 10;
            isHasData = YES;
        }
    }
    
    
    if([[self.AllDataSourceDict objectForKey:@"3"] count] > 0)
    {
        self.doctorView.width = self.view.width;
        self.doctorView.datasource = [NSMutableArray array];
        [self.doctorView.datasource addObjectsFromArray: [self.AllDataSourceDict objectForKey:@"3"]];
        self.doctorView.y = totalHeight + 10;
        [self.doctorView reflesh];
        self.doctorView.keyWord = self.keyWord;
        [self.scrollView addSubview:self.doctorView];
        
        if (self.doctorView.hidden == NO)
        {
            totalHeight += self.doctorView.height+10;
            isHasData = YES;
        }
        
    }
    
    if([[self.AllDataSourceDict objectForKey:@"8"] count] > 0)
    {
        self.newsView.width = self.view.width;
        self.newsView.datasource = [NSMutableArray array];
        [self.newsView.datasource addObjectsFromArray:  [self.AllDataSourceDict objectForKey:@"8"]];
        self.newsView.y = totalHeight+10;
        [self.newsView reflesh];
        self.newsView.keyWord = self.keyWord;
        [self.scrollView addSubview:self.newsView];
        
        if (self.newsView.hidden == NO)
        {
            totalHeight += self.newsView.height+10;
            isHasData = YES;
        }
    }
    
    if (!isHasData)
    {
        UILabel * la = [self.scrollView viewWithTag:7878];
        
        [la removeFromSuperview];
        
        UILabel * label = ({
            
            UILabel * label = [UILabel new];
            
            [label setText:@"没有相关数据！"];
            //self.scrollView.height / 2
            label.frame = CGRectMake(self.scrollView.width / 2 - 100,50 , 200, 40);
            label.tag = 7878;
            
            label.textAlignment = NSTextAlignmentCenter;
            
            label.font = [UIFont systemFontOfSize:18];
            
            label.textColor = HEXRGB(0x333333);
            
            label;
        });
        
        [self.scrollView addSubview:label];
    }
    
    self.scrollView.y = 0;
    self.scrollView.contentSize = CGSizeMake(self.view.width,totalHeight + 64);
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)cancelAction:(id)sender
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self searchAllDataWithKeyWord];
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
