//
//  VideoManageController.m
//  MYCS
//
//  Created by AdminZhiHua on 16/1/8.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "VideoSpaceController.h"
#import "SpaceModuleController.h"
#import "SelectClassController.h"
#import "SelectSourceController.h"
#import "VCSDetailViewController.h"
#import "VideoSpaceModel.h"
#import "UICollectionView+NoDataTips.h"

#import "TaskSelectObjectController.h"
#import "TaskObject.h"
#import "ReceiverModel.h"
#import "SelectDeptController.h"

@interface VideoSpaceController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *menuContent;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuBtns;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBarConst;
@property (nonatomic,strong) UIButton *selectBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (nonatomic,strong) SpaceModuleController *selfVideoVC;
@property (nonatomic,strong) SpaceModuleController *baseVideoVC;

@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property (nonatomic,copy)NSMutableArray * selectedDep;

@end

@implementation VideoSpaceController

- (NSMutableArray *)selectedDep {
    if (_selectedDep == nil)
    {
        _selectedDep = [NSMutableArray array];
    }
    return _selectedDep;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [UMAnalyticsHelper endLogPageName:self.title];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (iS_IOS10)
    {
        [self addConstraints];
    }
    [UMAnalyticsHelper beginLogPageName:self.title];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.view.backgroundColor = bgsColor;
    [self.view layoutIfNeeded];
    
    UIButton *button = [self.menuBtns firstObject];
    [self menuAction:button];
    
    [self addLineToMenuContent];
    
    self.selfVideoVC = [self.childViewControllers firstObject];
    self.baseVideoVC = [self.childViewControllers lastObject];
    
    self.selfVideoVC.actionStr = @"lists";
    self.baseVideoVC.actionStr = @"basic";
    
    self.selfVideoVC.idStr = @"";
    self.baseVideoVC.idStr = @"";
    self.selfVideoVC.vipStr = @"-1";
    self.baseVideoVC.vipStr = @"-1";
    //根据类型改变内容
    [self setContentWith:self.type];
    
    [self setRightButton];

}

//根据内容设置，选择来源的显示或者隐藏
- (void)setRightButton {
    
    UserType type =[AppManager sharedManager].user.userType;
    
    if (type == UserType_personal||type==UserType_organization)
    {
        self.rightBtn.hidden = YES;
        [self.rightBtn setTitle:nil forState:UIControlStateNormal];
    }
    else
    {
        [self.rightBtn setTitle:@"选择来源" forState:UIControlStateNormal];
    }
    
}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self setCellClickAction];
}


- (void)setContentWith:(VideoSpaceType)type {
    
    if (type == VideoSpaceTypeVideo)
    {
        self.selfVideoVC.moduleType = SpaceModuleTypeVideo;
        self.baseVideoVC.moduleType = SpaceModuleTypeVideo;
        self.title = @"视频空间";
        if([AppManager sharedManager].user.userType == UserType_personal)
        {//个人的时候显示
            [self setMenuButtonTitleWith:@[@"自制视频",@"平台视频"]];
        }
        else if ([AppManager sharedManager].user.agroup_id.intValue == 9||[AppManager sharedManager].user.agroup_id.intValue == 10) {
            
            [self setMenuButtonTitleWith:@[@"自有视频",@"平台视频"]];
        }
        else
        {
            [self setMenuButtonTitleWith:@[@"本院视频",@"平台视频"]];
        }
        
    }
    else if (type == VideoSpaceTypeCourse)
    {
        self.selfVideoVC.moduleType = SpaceModuleTypeCourse;
        self.baseVideoVC.moduleType = SpaceModuleTypeCourse;
        self.title = @"教程管理";
        if ([AppManager sharedManager].user.agroup_id.intValue == 9||[AppManager sharedManager].user.agroup_id.intValue == 10) {
            
            [self setMenuButtonTitleWith:@[@"自有教程",@"基础教程"]];
        }else{
            [self setMenuButtonTitleWith:@[@"本院教程",@"平台教程"]];
        }
        
    }
    else
    {
        self.selfVideoVC.moduleType = SpaceModuleTypeSOP;
        self.baseVideoVC.moduleType = SpaceModuleTypeSOP;
        self.title = @"SOP管理";
        
        if ([AppManager sharedManager].user.agroup_id.intValue == 9 ||[AppManager sharedManager].user.agroup_id.intValue == 10){
        
            [self setMenuButtonTitleWith:@[@"自有SOP",@"基础SOP"]];
            
        }else{
            
            [self setMenuButtonTitleWith:@[@"本院SOP",@"基础SOP"]];
        
        }
        
    }
    
}

- (void)setMenuButtonTitleWith:(NSArray *)arr {
    
    for (int i = 0; i<self.menuBtns.count; i++)
    {
        UIButton *button = self.menuBtns[i];
        NSString *title = arr[i];
        [button setTitle:title forState:UIControlStateNormal];
    }
    
}

- (void)addLineToMenuContent {
    
    CALayer *lineLayer = [CALayer new];
    
    [self.menuContent.layer addSublayer:lineLayer];
    
    lineLayer.backgroundColor = HEXRGB(0xeeeeee).CGColor;
    
    lineLayer.frame = CGRectMake(0, self.menuContent.height-1, ScreenW, 1);
    
}

#pragma mark - Action
- (void)setCellClickAction {
    
    __weak typeof(self) weakSelf = self;
    self.selfVideoVC.cellClickAction = ^(VideoSpaceModel *model,SpaceModuleType moduleType){
        
        UIStoryboard *videoStroyboard = [UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil];
        VCSDetailViewController *vcsVC = [videoStroyboard instantiateViewControllerWithIdentifier:@"VCSDetailViewController"];
        vcsVC.type = (int)moduleType;
        vcsVC.videoId = model.id;
        vcsVC.mySelft = YES;
        [weakSelf.navigationController pushViewController:vcsVC animated:YES];
    };
    
    self.baseVideoVC.cellClickAction = self.selfVideoVC.cellClickAction;
    
}

- (IBAction)menuAction:(UIButton *)button {
    
    self.selectBtn.selected = NO;
    self.selectBtn = button;
    [self.selfVideoVC.collectionView removeNoDataTipsView];
    [self.baseVideoVC.collectionView removeNoDataTipsView];
    
    NSUInteger tag = button.tag;
    
    self.selectBtn.selected = YES;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.scrollBarConst.constant = (self.view.width*0.5)*tag;
        [self.view layoutIfNeeded];
        
        self.scrollView.contentOffset = CGPointMake(self.view.width*tag, 0);
        
    } completion:^(BOOL finished) {
        
        if (button.tag == 0)
        {
            self.selfVideoVC.index = 0;
            if (self.selfVideoVC.dataSource.count == 0)
            {
                [self.selfVideoVC refreshData];
            }
            [self setRightButton];
        }
        else if (button.tag == 1)
        {
            self.baseVideoVC.index = 1;
            if (self.baseVideoVC.dataSource.count == 0)
            {
                [self.baseVideoVC refreshData];
            }
            [self.rightBtn setTitle:@"选择分类" forState:UIControlStateNormal];
            self.rightBtn.hidden = NO;
        }
    }];
    
}

- (IBAction)rightButtonAction:(UIButton *)button {
    
    if ([button.currentTitle isEqualToString:@"选择来源"])
    {
//        [self performSegueWithIdentifier:@"SelectedSource" sender:nil];
        SelectDeptController *selectVC = [[UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil] instantiateViewControllerWithIdentifier:@"SelectDeptController"];
        selectVC.isFirstCome = YES;
        [[AppDelegate sharedAppDelegate].rootNavi pushViewController:selectVC animated:YES];
        __weak typeof(self) weakSelf = self;
        selectVC.sureBtnBlock = ^(NSString *selectIdStr) {
            NSLog(@"%@",selectIdStr);
            weakSelf.selfVideoVC.idStr = selectIdStr;
            [weakSelf.selfVideoVC refreshData];
        };
    }
    else if ([button.currentTitle isEqualToString:@"选择分类"])
    {
        [self performSegueWithIdentifier:@"SelectedClass" sender:nil];
    }
    
}
- (NSString *)selectIdStr:(NSArray *)list {
    
    NSString *idStr = [list componentsJoinedByString:@","];
    
    return idStr;
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"SelectedClass"])
    {
        SelectClassController *destVC = segue.destinationViewController;
        
        destVC.selectId = self.baseVideoVC.idStr;
        destVC.selectVipId = self.baseVideoVC.vipStr;
        
        __weak typeof(self) weakSelf = self;
        destVC.completeBlock = ^(NSString *selectIdStr,NSString * vipIdStr) {
            weakSelf.baseVideoVC.idStr = selectIdStr;
            weakSelf.baseVideoVC.vipStr = vipIdStr;
            [weakSelf.baseVideoVC refreshData];
        };
    }
    if ([segue.identifier isEqualToString:@"SelectedSource"])
    {
        SelectSourceController *destVC = segue.destinationViewController;
        
        __weak typeof(self) weakSelf = self;
        destVC.sureBtnBlock = ^(NSString *selectIdStr) {
            weakSelf.selfVideoVC.idStr = selectIdStr;
            [weakSelf.selfVideoVC refreshData];
        };
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSUInteger page = scrollView.contentOffset.x/self.view.width;
    UIButton *button = self.menuBtns[page];
    
    self.selectBtn.selected = NO;
    self.selectBtn = button;
    
    [self menuAction:button];
    
}

@end
