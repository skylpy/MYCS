//
//  DoctorsPageViewController.m
//  MYCS
//
//  Created by wzyswork on 15/12/31.
//  Copyright © 2015年 MYCS. All rights reserved.
//

#import "DoctorsPageViewController.h"

#import "UIImageView+WebCache.h"

#import "DoctorModel.h"
#import "DoctorInfoModel.h"
#import "CollectionModel.h"

#import "LanscapeNaviController.h"
#import "PersonCardViewController.h"
#import "VideoCenterViewController.h"
#import "InfomactionViewController.h"
#import "CommentViewController.h"
#import "CommunicateViewController.h"
#import "CaseCenterViewController.h"

@interface DoctorsPageViewController ()<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avartBgView;

@property (weak, nonatomic) IBOutlet UIImageView *avartView;

@property (weak, nonatomic) IBOutlet UILabel *nameL;

@property (weak, nonatomic) IBOutlet UILabel *hospitalL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hospitalLWidth;

@property (weak, nonatomic) IBOutlet UILabel *specialtyL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *specialtyLWidth;

@property (weak, nonatomic) IBOutlet UIImageView *hospitalIdentify;

@property (weak, nonatomic) IBOutlet UIImageView *specialtyIdentify;

@property (weak, nonatomic) IBOutlet UIView *personInfoView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;

@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menuBtns;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greenViewLeading;

@property (nonatomic,strong) UIButton * selectBtn;


@property (nonatomic,strong) NSMutableArray *viewControllers;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,assign) NSInteger lastSelect;

@property (nonatomic,assign) int selectTitle;

@property (nonatomic,strong) DoctorInfoModel *doctorInfo;

@end

@implementation DoctorsPageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.scrollView.delegate  =self;
    
    self.avartView.layer.cornerRadius = self.avartView.width * 0.5;
    self.avartView.layer.masksToBounds = YES;
    
    self.avartBgView.layer.cornerRadius = self.avartBgView.width * 0.5;
    self.avartBgView.layer.masksToBounds = YES;
    
    self.avartView.center = self.avartBgView.center;
    self.avartView.contentMode = UIViewContentModeScaleToFill;
    
    [self setupPersonInfo];
    
}

- (IBAction)muneBtnsAction:(UIButton *)sender
{
    [self.scrollView setScrollEnabled:YES];
    self.selectBtn.selected = NO;
    self.selectBtn = sender;
    
    NSUInteger tag = sender.tag;
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.selectBtn.selected = YES;
        
        self.greenViewLeading.constant = sender.x;
        
        [self.view layoutIfNeeded];
        
        self.scrollView.contentOffset = CGPointMake(ScreenW*tag, 0);
        
    } completion:^(BOOL finished) {
        
        if (sender.tag == 0)
        {
           InfomactionViewController * infor = self.childViewControllers[0];
            infor.doctorInfo = self.doctorInfo;
        }
        else if (sender.tag == 1)
        {
    
          CaseCenterViewController * caseVC = self.childViewControllers[1];
            if (caseVC.caseList.count > 0) {
                return;
            }
            caseVC.uid = self.uid;

        }
        else if (sender.tag == 2)
        {
                
            VideoCenterViewController * videoVC = self.childViewControllers[2];
            if (videoVC.dataSource.count > 0) {
                return;
            }
            videoVC.agroup_id = self.doctorInfo.agroup_id;
            videoVC.uid = self.uid;
            
        }else if(sender.tag == 3)
        {
            CommunicateViewController * comVC  = self.childViewControllers[3];
            if (comVC.commentList.count > 0) {
                return;
            }
            comVC.uid = self.uid;
  
        }else if (sender.tag == 4)
        {
            
          CommentViewController * comVC  = self.childViewControllers[4];
            if (comVC.commentList.count > 0) {
                return;
            }
            comVC.uid = self.uid;
        }
        
    }];

}


#pragma mark - *** 代理 ***
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self.scrollView) {
        return;
    }
    
    NSUInteger page = scrollView.contentOffset.x/ScreenW;
    UIButton *button = self.menuBtns[page];
    
    self.selectBtn.selected = NO;
    self.selectBtn = button;
    
    [self muneBtnsAction:button];
    
}

#pragma mark - *** 数据显示 **
- (void)setupPersonInfo{
    
    self.collectionBtn.selected = self.doctorInfo.is_collect.intValue == 1?YES:NO;
    
    [self.avartView sd_setImageWithURL:[NSURL URLWithString:self.doctorInfo.imgUrl] placeholderImage:PlaceHolderImage];
    self.nameL.text = self.doctorInfo.realname;
    
    self.hospitalL.text = self.doctorInfo.hospital;
    [self.hospitalL sizeToFit];
    self.hospitalLWidth.constant = self.hospitalL.width;
    
    self.specialtyL.text = self.doctorInfo.divisionName;
    [self.specialtyL sizeToFit];
    self.specialtyLWidth.constant = self.specialtyL.width;
    
    if (self.hospitalL.width > ScreenW - 145 )
    {
        self.hospitalLWidth.constant = ScreenW - 145;
        
    }else
    {
        self.hospitalLWidth.constant = self.hospitalL.width;
    }
    
    if (!self.doctorInfo.isAuthByHos)
    {
        self.hospitalIdentify.hidden = YES;
        self.specialtyL.y = self.hospitalL.y;
        
    }else
    {
        self.hospitalIdentify.hidden = self.doctorInfo.isAuthByHos?NO:YES;
    }
    
    if (_doctorInfo.divisionName.length == 0)
    {
        self.specialtyIdentify.hidden = YES;
        
    }else
    {
        self.specialtyIdentify.hidden = self.doctorInfo.isAuthByDiv?NO:YES;
    }
    
}

#pragma mark - *** Back Action **
- (IBAction)backAction:(id)sender
{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - *** 名片 Action **
- (IBAction)responseRightButton:(id)sender
{
    
    PersonCardViewController *VC = [[UIStoryboard storyboardWithName:@"doctor" bundle:nil] instantiateViewControllerWithIdentifier:@"PersonCardViewController"];
    
    VC.doctorInfo = self.doctorInfo;
    
    //创建横屏导航控制器
    LanscapeNaviController *lansNavi = [[LanscapeNaviController alloc] init];
    [lansNavi addChildViewController:VC];
    
    [[AppDelegate sharedAppDelegate].rootNavi presentViewController:lansNavi animated:YES completion:nil];
    
    VC.backBlok = ^(){
    
        UIButton *btn = [self.menuBtns lastObject];
        [self muneBtnsAction:btn];
        
        CommentViewController * comVC  = self.childViewControllers[4];
        [comVC reloadData];
        
    };
}


#pragma mark - getter和setter方法
- (void)setUid:(NSString *)uid
{
    _uid = uid;
    
    [self showLoadingHUD];
    
    __weak typeof(self) this = self;
    [DoctorInfoModel doctorInfoWithDoctorUid:uid success:^(DoctorInfoModel *doctorInfo) {
        
        this.doctorInfo = doctorInfo;
        
        UIButton *btn = [self.menuBtns firstObject];
        [self muneBtnsAction:btn];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [self dismissLoadingHUD];
            
        });
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        
        [self showError:error];
        
    }];
    
}

#pragma mark - *** setting and getting ***
- (void)setDoctorInfo:(DoctorInfoModel *)doctorInfo
{
    _doctorInfo = doctorInfo;
    
    [self setupPersonInfo];
}

- (IBAction)collectionBtnAction:(UIButton *)sender
{
    
    if (![AppManager checkLogin])return;
    
    sender.enabled = NO;
    
    NSString * collect;
    NSString * messageStr;
    
//    不传collect或者collect为1则为收藏，若collect为0则为取消收藏
    if (sender.selected)
    {
        collect = @"0";
        messageStr = @"取消收藏";
    }else
    {
        collect = @"1";
        messageStr = @"收藏成功";
    }
    
    [CollectionModel AddCollectDoctorOrOfficeWithCollectId:self.doctorInfo.uid userId:[AppManager sharedManager].user.uid collectType:1 Collect:collect success:^(NSString *successStr) {
        
        sender.enabled = YES;
        
        [self showSuccessWithStatusHUD:messageStr];
        
        sender.selected = !sender.selected;
        
    } failure:^(NSError *error) {
        
        sender.enabled = YES;
        
        [self showError:error];
    }];
    
}


@end
