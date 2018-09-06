//
//  HomeController.m
//  MYCS
//
//  Created by wzyswork on 16/4/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "MainHomeController.h"
#import "HeadView.h"
#import "HomeQRCodeController.h"
#import "QRCodeModel.h"
#import "MJExtension.h"
#import "VCSDetailViewController.h"
#import "DoctorsPageViewController.h"
#import "OfficePagesViewController.h"
#import "PlayRecordViewController.h"
#import "DoctorListsViewController.h"
#import "ActivityHomeController.h"
#import "NewsInformationViewController.h"
#import "WebViewDetailController.h"
#import "HomeMedicineController.h"
#import "OfficeHomeViewController.h"

@interface MainHomeController () <HomeQRCodeControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewBottomConst;

@end

@implementation MainHomeController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.automaticallyAdjustsScrollViewInsets = NO;

    //添加自定义导航条view
    [self configHeaderView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginOutAction:) name:LOGINOUT object:nil];

    [self.view layoutIfNeeded];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([AppManager hasLogin])
    { //登录
        [self cancelAction:nil];
    }
    else //未登录
    {
        [self showLoginView];
    }
}

- (void)loginOutAction:(NSNotification *)noti
{
    [self showLoginView];
}


- (IBAction)loginAction:(id)sender {
    UIStoryboard *loginSB     = [UIStoryboard storyboardWithName:@"Login" bundle:nil];
    UIViewController *loginVC = [loginSB instantiateInitialViewController];

    [self presentViewController:loginVC animated:YES completion:nil];
}

//登录提示的取消按钮事件
- (IBAction)cancelAction:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{

        self.loginViewBottomConst.constant = -35;
        [self.view layoutIfNeeded];

    }
        completion:^(BOOL finished) {
            self.loginView.alpha = 0;
        }];
}


//显示登录提示view
- (void)showLoginView {
    [self.view bringSubviewToFront:self.loginView];

    self.loginView.alpha = 0.7;

    [UIView animateWithDuration:0.5 animations:^{

        self.loginViewBottomConst.constant = 0;
        [self.view layoutIfNeeded];

    }];
}

- (void)configHeaderView {
    //使用自定义导航条
    HeadView *headerView = [HeadView headView];

    headerView.frame = CGRectMake(0, 0, ScreenW, 64);

    [self.navigationController.view insertSubview:headerView aboveSubview:self.navigationController.navigationBar];

    [headerView showBlock:^(NSInteger index) {

        if (index == 0)
        {
            [self searchAction];
        }
        else if (index == 1)
        {
            [self playRecordAction];
           
        }
        else if (index == 2)
        {
            [self showScan];
        }
    }];

    if (iS_IOS8LATER)
    {
        [self addConstsToHeaderView:headerView];
    }
}


//添加头部的约束
- (void)addConstsToHeaderView:(UIView *)headerView {
    headerView.translatesAutoresizingMaskIntoConstraints = NO;

    NSString *hVFL = @"H:|-(0)-[headerView]-(0)-|";
    NSString *vVFL = @"V:|-(0)-[headerView(64)]";

    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerView)];
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(headerView)];

    [headerView.superview addConstraints:hConsts];
    [headerView.superview addConstraints:vConsts];
}

#pragma mark - *** Action **
- (void)playRecordAction {
    UIStoryboard *sBoard               = [UIStoryboard storyboardWithName:@"PlayRecord" bundle:nil];
    PlayRecordViewController *recordVC = [sBoard instantiateInitialViewController];
//    recordVC.recordType                = PlayRecordTypeLocal;

    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:recordVC animated:YES];
}
- (void)searchAction {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Search" bundle:nil];

    UIViewController *searchVC = [sb instantiateInitialViewController];

    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:searchVC animated:YES];
}
- (void)showScan {
    HomeQRCodeController *QRCodeVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"HomeQRCodeController"];
    QRCodeVC.delegate              = self;

    [[AppDelegate sharedAppDelegate].rootNavi presentViewController:QRCodeVC animated:YES completion:nil];
}
#pragma mark - CustomDelegate
- (void)scanResultWith:(HomeQRCodeController *)controller resultString:(NSString *)result {
    //extData:二维码json数据的base64加密串
    NSRange range = [result rangeOfString:@"extData="];

    if (range.location == NSNotFound)
    {
        [self showVideoDetailWith:result];
        return;
    }

    NSString *base64Str = [result substringFromIndex:range.location + range.length];

    NSString *jsonStr = [self decodeWithBase64:base64Str];

    QRCodeModel *model = [self objectWithStr:jsonStr];

    [self reduceQRCodeModel:model];
}

- (void)showVideoDetailWith:(NSString *)result {
    NSRange range = [result rangeOfString:@"www.mycs.cn/player/"];
    //过滤掉不是本公司的二维码
    if (range.location == NSNotFound) return;

    //视频、教程、SOP：http://www.mycs.cn/player/{二维码类型}{二维码信息id}.html
    NSRange range1 = [result rangeOfString:@"player/"];
    NSRange range2 = [result rangeOfString:@".html"];

    NSRange newRange = NSMakeRange(range1.location + range1.length, range2.location - (range1.location + range1.length));

    //v44235,二维码类型为资源类型（字母），v--视频，c--教程，s--SOP
    NSString *str = [result substringWithRange:newRange];

    NSString *firstLetter = [str substringToIndex:1];
    NSString *videoId     = [str substringFromIndex:1];

    if ([firstLetter isEqualToString:@"v"])
    {
        [self showVCSDetailWithId:videoId VCSType:VCSDetailTypeVideo];
    }
    else if ([firstLetter isEqualToString:@"c"])
    {
        [self showVCSDetailWithId:videoId VCSType:VCSDetailTypeCourse];
    }
    else if ([firstLetter isEqualToString:@"s"])
    {
        [self showVCSDetailWithId:videoId VCSType:VCSDetailTypeSOP];
    }
}

//base64解码
- (NSString *)decodeWithBase64:(NSString *)base64Str {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:base64Str options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

//转换成模型对象
- (QRCodeModel *)objectWithStr:(NSString *)jsonStr {
    QRCodeModel *model = [QRCodeModel objectWithKeyValues:jsonStr];

    return model;
}

- (void)reduceQRCodeModel:(QRCodeModel *)model {
    if (model.type == QRCodeTypeVideo)
    {
        [self showVCSDetailWithId:model.id VCSType:VCSDetailTypeVideo];
    }
    else if (model.type == QRCodeTypeCourse)
    {
        [self showVCSDetailWithId:model.id VCSType:VCSDetailTypeCourse];
    }
    else if (model.type == QRCodeTypeSOP)
    {
        [self showVCSDetailWithId:model.id VCSType:VCSDetailTypeSOP];
    }
    else if (model.type == QRCodeTypeUser)
    {
        //医院
        if (model.agroup_id == 183)
        {
            [self showOfficeHomeWithId:model.id Type:OfficeTypeHospital IsHospitalOrOffice:YES];
        } //科室
        else if (model.agroup_id == 185)
        {
            [self showOfficeHomeWithId:model.id Type:OfficeTypeOffice IsHospitalOrOffice:YES];
        } //企业
        else if (model.agroup_id == 5)
        {
            [self showOfficeHomeWithId:model.id Type:OfficeTypeEnterprise IsHospitalOrOffice:NO];
        } //名医用户
        else if (model.agroup_id == 193)
        {
            DoctorsPageViewController *doctorPageVC = [[UIStoryboard storyboardWithName:@"doctor" bundle:nil] instantiateViewControllerWithIdentifier:@"DoctorsPageViewController"];

            doctorPageVC.uid = model.id;

            [[AppDelegate sharedAppDelegate].rootNavi pushViewController:doctorPageVC animated:YES];
        } //实验室用户
        else if (model.agroup_id == 187)
        {
            [self showOfficeHomeWithId:model.id Type:OfficeTypeLaboratory IsHospitalOrOffice:NO];
        }
    }
}

//isHospitalOrOffice;//医院和科室为YES其他为NO
- (void)showOfficeHomeWithId:(NSString *)officeId Type:(OfficeType)type IsHospitalOrOffice:(BOOL)isHospitalOrOffice {
    OfficePagesViewController *pVC = [[UIStoryboard storyboardWithName:@"Office" bundle:nil] instantiateViewControllerWithIdentifier:@"OfficePagesViewController"];

    pVC.type               = type;
    pVC.isHospitalOrOffice = isHospitalOrOffice;
    pVC.uid                = officeId;

    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:pVC animated:YES];
}
- (void)showVCSDetailWithId:(NSString *)videoId VCSType:(VCSDetailType)type {
    //创建视频详情的控制器
    UIStoryboard *vcsSB            = [UIStoryboard storyboardWithName:@"VideoSpace" bundle:nil];
    VCSDetailViewController *vcsVC = [vcsSB instantiateViewControllerWithIdentifier:@"VCSDetailViewController"];

    vcsVC.videoId = videoId;
    vcsVC.type    = type;
    
    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:vcsVC animated:YES];
}

@end
