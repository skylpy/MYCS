//
//  HealthHomeViewController.m
//  MYCS
//
//  Created by GuiHua on 16/7/4.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "HealthHomeViewController.h"
#import "DiseaseClassController.h"
#import "DiseaseViewController.h"
#import "FeatureViewController.h"
#import "MicrocinemaViewController.h"
#import "TrailerViewController.h"

@interface HealthHomeViewController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *imageBtnArrs;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *nameBtnArrs;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) UIButton * selectImageBtn;

@property (nonatomic,strong) UIButton * selectNameBtn;
///title按钮
@property (strong,nonatomic) UIButton * titleButton;
@property  (strong,nonatomic) UILabel *titleLabel;
@property  (strong,nonatomic) UIImageView *titleImage;

///疾病类别名称
@property (nonatomic,copy) NSString *diseaseType;
///疾病类别id
@property (nonatomic ,copy) NSString *diseaseCategoryId;

@property (nonatomic,assign) int page;

@end

@implementation HealthHomeViewController
- (void)addConstraints
{
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.automaticallyAdjustsScrollViewInsets                     = NO;
    
    id containerView = self.containerView;
    id topLayoutGuide = self.topLayoutGuide;
    
//    NSString *hVFL = @"H:|-(0)-[containerView(375)]";
    
    NSString *vVFL = @"V:|-(0)-[topLayoutGuide]-(0)-[containerView]-(0)-|";
    
//    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(topLayoutGuide, containerView)];
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(topLayoutGuide, containerView)];
    
//    [self.view addConstraints:hConsts];
    [self.view addConstraints:vConsts];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self addConstraints];
    
    self.navigationController.navigationBarHidden = NO;
 
    [UMAnalyticsHelper beginLogPageName:@"科普"];
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    
    [UMAnalyticsHelper endLogPageName:@"科普"];
}

#pragma mark - 顶部分类按钮
-(UIButton *)titleButton
{
    
    if (!_titleButton)
    {
        _titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _titleButton.frame = CGRectMake(100, 0, ScreenW - 200, 64);
        [_titleButton addTarget:self action:@selector(titleButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return _titleButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.diseaseCategoryId = @"-1";
    self.diseaseType = @"全部疾病";
    
    self.navigationItem.titleView = self.titleButton;
    
    self.selectNameBtn = [self.nameBtnArrs firstObject];
    self.selectImageBtn = [self.imageBtnArrs firstObject];
    
    [self buttonAction:[self.nameBtnArrs firstObject]];
}

-(void)showImage:(BOOL)show and:(NSString *)name
{
    
    for (UIView *view in _titleButton.subviews)
    {
        [view removeFromSuperview];
        
    }
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.text = name;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:18];
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake((ScreenW - 200) / 2, 32);
    [_titleButton addSubview:_titleLabel];
    
    _titleImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_titleLabel.frame)+5, 30, 8, 8)];
    _titleImage.image = [UIImage imageNamed:@"pulldown"];
    _titleImage.hidden = !show;
    
    [_titleButton addSubview:_titleImage];
    
}

#pragma mark - 顶部分类按钮Action（只有疾病才有）
-(void)titleButtonAction
{
    DiseaseClassController *classVC = [[UIStoryboard storyboardWithName:@"DoctorsHealth" bundle:nil] instantiateViewControllerWithIdentifier:@"DiseaseClassController"];
    classVC.title = self.diseaseType;
    
    classVC.selectId = self.diseaseCategoryId;
    
    classVC.DiseaseClassCellClickblock = ^(NSString *name, NSString *idStr)
    {
        self.diseaseType = name;
        
        [self showImage:YES and:name];
        
        self.diseaseCategoryId = idStr;
        DiseaseViewController *DVC = self.childViewControllers[0];
        [DVC loadDataWithDiseaseCategoryId:idStr];
        
    };
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:classVC animated:YES];
    
}

#pragma mark - 底部按钮Action
- (IBAction)buttonAction:(UIButton *)sender
{
    self.scrollView.scrollEnabled = NO;
    
    self.selectNameBtn.selected = NO;
    self.selectImageBtn.selected = NO;
    self.selectNameBtn = sender;
    NSUInteger tag = sender.tag;
    self.selectImageBtn = self.imageBtnArrs[tag];
    
    self.page = (int)tag;
    [self.scrollView setContentOffset:CGPointMake(ScreenW*tag, 0) animated:NO];
    self.selectNameBtn.selected = YES;
    self.selectImageBtn.selected = YES;
    
    [self.view layoutIfNeeded];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        
    } completion:^(BOOL finished) {
        
        if (sender.tag == 0)
        {
            [UMAnalyticsHelper eventLogClick:@"event_health_sick"];
            [self showImage:YES and:self.diseaseType];
            _titleButton.userInteractionEnabled = YES;
            
        }
        else if (sender.tag == 1)
        {
            [UMAnalyticsHelper eventLogClick:@"event_health_topic"];
            [self showImage:NO and:@"专题片"];
            _titleButton.userInteractionEnabled = NO;
            
            FeatureViewController *FVC = self.childViewControllers[tag];
            [FVC loadData];
        }
        else if (sender.tag == 2)
        {
            [UMAnalyticsHelper eventLogClick:@"event_health_flim"];
            [self showImage:NO and:@"微电影"];
            _titleButton.userInteractionEnabled = NO;
            
            MicrocinemaViewController *MVC = self.childViewControllers[tag];
            [MVC loadData];
            
            
        }else if(sender.tag == 3)
        {
            [UMAnalyticsHelper eventLogClick:@"event_health_video"];
            [self showImage:NO and:@"宣传片"];
            _titleButton.userInteractionEnabled = NO;
            
            TrailerViewController *TVC = self.childViewControllers[tag];
            [TVC loadData];
            
        }
    }];
    
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
