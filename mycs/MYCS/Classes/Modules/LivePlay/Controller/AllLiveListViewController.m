//
//  AllLiveListViewController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/4/20.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "AllLiveListViewController.h"
#import "LiveViewController.h"
#import "LiveDetailViewController.h"
#import "LanscapeNaviController.h"
#import "WatchLiveViewController.h"


@interface AllLiveListViewController ()
@property (weak, nonatomic) IBOutlet UIView *menuContent;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuBtns;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBarConstCenter;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic, strong) UIButton *selectButton;

@property (nonatomic, strong) LiveViewController * onLiveView;

@property (nonatomic, strong) LiveViewController * afterLiveView;

@property (nonatomic, strong) LiveViewController * endLiveView;
@end

@implementation AllLiveListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.scrollView.bounces = NO;
    
    [self.view layoutIfNeeded];

    [self setLiveControllerType];
    
    [self menuAction:self.menuBtns[0]];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.selectButton)
    {
        [self menuAction:self.selectButton];
    }
    
    if (iS_IOS10)
    {
        [self addConstraints];
    }
}
- (void)addConstraints
{
    self.menuContent.translatesAutoresizingMaskIntoConstraints = NO;
    self.automaticallyAdjustsScrollViewInsets                     = NO;
    
    id menuContent = self.menuContent;
    
    NSString *hVFL = @"H:|-(0)-[menuContent]-(0)-|";
    NSString *vVFL = @"V:|-(64)-[menuContent(45)]";
    
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(menuContent)];
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(menuContent)];
    
    
    [self.view addConstraints:hConsts];
    [self.view addConstraints:vConsts];
}

- (void)setLiveControllerType {

    self.onLiveView = self.childViewControllers[0];
    self.afterLiveView = self.childViewControllers[1];
    self.endLiveView = self.childViewControllers[2];

}

- (IBAction)menuAction:(UIButton *)button {
    self.selectButton.selected = NO;
    self.selectButton          = button;

    NSInteger tag = button.tag;

    // 设置scrollBar的位置
    [UIView animateWithDuration:0.25 animations:^{
        self.selectButton.selected         = YES;
        self.scrollBarConstCenter.constant = (ScreenW * 0.3333) * tag;
        [self.view layoutIfNeeded];
        
        self.scrollView.contentOffset = CGPointMake(ScreenW*tag, 0);
    }];

    if (tag == 0)
    {
        if (self.onLiveView.dataArr.count <= 0) {
            
            self.onLiveView.liveType = OnLive;
        }else
        {
            [self.onLiveView reloadNewsData];
        }
    }
    else if (tag == 1)
    {
        if (self.afterLiveView.dataArr.count <= 0) {
        self.afterLiveView.liveType = AfterLive;
        }else
        {
            [self.afterLiveView reloadNewsData];
        }
    }
    else
    {
        if (self.endLiveView.dataArr.count <= 0) {
        self.endLiveView.liveType = EndLive;
        }else
        {
            [self.endLiveView reloadNewsData];
        }
    }

}

#pragma mark - ScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSUInteger page = scrollView.contentOffset.x/self.view.width;
    UIButton *button = self.menuBtns[page];
    
    [self menuAction:button];
    
}

@end
