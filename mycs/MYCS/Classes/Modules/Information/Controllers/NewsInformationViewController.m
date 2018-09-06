//
//  NewsInformationViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/3/17.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "NewsInformationViewController.h"
#import "NewsListViewController.h"

@interface NewsInformationViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuBtns;

@property (weak, nonatomic) IBOutlet UIView *btnsBgView;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) UIButton *selectBtn;

@property (nonatomic,assign) BOOL showFirst;
@property (nonatomic,assign) BOOL showSecond;
@property (nonatomic,assign) BOOL showThird;

@end

@implementation NewsInformationViewController

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [UMAnalyticsHelper beginLogPageName:@"资讯"];
    if (iS_IOS10)
    {
        [self addConstraints];
    }
}
- (void)addConstraints
{
    self.btnsBgView.translatesAutoresizingMaskIntoConstraints = NO;
    self.automaticallyAdjustsScrollViewInsets                     = NO;
    
    id btnsBgView = self.btnsBgView;
    
    NSString *hVFL = @"H:|-(0)-[btnsBgView]-(0)-|";
    NSString *vVFL = @"V:|-(64)-[btnsBgView(41)]";
    
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnsBgView)];
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(btnsBgView)];
    
    
    [self.view addConstraints:hConsts];
    [self.view addConstraints:vConsts];
}


-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [UMAnalyticsHelper endLogPageName:@"资讯"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.bounces = NO;
    
    self.selectBtn = [self.menuBtns firstObject];
    
    //设置类型
    [self setNewsListControllerType];
    
    [self.view layoutIfNeeded];
    
    [self menuBtnAction:self.selectBtn];
    
}

- (void)setNewsListControllerType {
    
    for (int i = 0; i<self.childViewControllers.count; i++)
    {
        NewsListViewController *vc = self.childViewControllers[i];
        vc.type = (NewsType)i;
    }
}

#pragma mark - Action
- (IBAction)menuBtnAction:(UIButton *)button {
    
    self.selectBtn.selected = NO;
    self.selectBtn = button;
    
    NSUInteger tag = button.tag;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.selectBtn.selected = YES;
        [self.view layoutIfNeeded];
        
        self.scrollView.contentOffset = CGPointMake(self.view.width*tag, 0);
        
    } completion:^(BOOL finished) {
        
        if (tag==0)
        {
            if (self.showFirst)return;
            
            self.showFirst = YES;
            NewsListViewController *vc = self.childViewControllers[0];
            [vc loadTableView];
            
        }
        else if (tag==1)
        {
            if (self.showSecond)return;
            
            self.showSecond = YES;
            NewsListViewController *vc = self.childViewControllers[1];
            [vc loadTableView];
            
        }
        else if (tag==2)
        {
            if (self.showThird)return;
            
            self.showThird = YES;
            NewsListViewController *vc = self.childViewControllers[2];
            [vc loadTableView];
        }
    }];
}


#pragma mark - ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSUInteger page = scrollView.contentOffset.x/self.view.width;
    UIButton *button = self.menuBtns[page];
    
    self.selectBtn.selected = NO;
    self.selectBtn = button;
    
    [self menuBtnAction:button];
    
}

@end
