//
//  ServiceDetailsController.m
//  MYCS
//
//  Created by wzyswork on 16/1/15.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "ServiceDetailsController.h"

#import "UIImageView+WebCache.h"

#import "MembershipServiceDetail.h"
#import "MemberOperation.h"

#import "StudyRecordController.h"
#import "InputReasonController.h"
#import "MemberDetailsController.h"

@interface ServiceDetailsController ()<UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;

@property (strong, nonatomic) IBOutlet UILabel *serviceNameLabel;

@property (strong, nonatomic) IBOutlet UILabel *yearLabel;

@property (strong, nonatomic) IBOutlet UILabel *startEndDateLabel;

@property (strong, nonatomic) IBOutlet UILabel *memberNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusTitleL;

@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@property (strong, nonatomic) IBOutlet UIButton *notCrossButton;

@property (strong, nonatomic) IBOutlet UIButton *crossButton;

@property (strong, nonatomic) IBOutlet UILabel *companyLabel;

@property (strong, nonatomic) IBOutlet UILabel *contactLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *greenViewLeft;

@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *menusBtn;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollViewBg;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollIView;

@property (weak, nonatomic) IBOutlet UIView *ContainerView;

@property (weak, nonatomic) IBOutlet UILabel *CourseIntroductionL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CourseIntroductionLHeight;

@property (weak, nonatomic) IBOutlet UILabel *organizactionIntroductionL;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *organizactionIntroductionLHeight;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@property (nonatomic,strong) MembershipServiceDetail * MemberDetail;

@property (nonatomic,strong)  UIButton * selectBtn;

@end

@implementation ServiceDetailsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notCrossButton.layer.borderColor = HEXRGB(0xcccccc).CGColor;
    self.notCrossButton.layer.borderWidth = 1;
    self.notCrossButton.layer.cornerRadius = 5;
    self.notCrossButton.clipsToBounds = YES;
    
    self.crossButton.layer.cornerRadius = 5;
    self.crossButton.clipsToBounds = YES;
    
    self.scrollViewBg.contentSize = CGSizeMake(ScreenW, ScreenH + 150);
    
    self.scrollIView.delegate = self;
 
    //获取页面详情
    [self updateInfo];
    
    self.bottomViewHeight.constant = ScreenH - 320;
}

#pragma mark -- Back Action
- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -- get Data
- (void)updateInfo
{
    [self showLoadingHUD];
    
    [MembershipServiceDetail requestMembershipServiceDetailWithUerId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] memberID:self.memberIDString success:^(MembershipServiceDetail *memberDetail) {
        
        self.MemberDetail = memberDetail;
        
        [self buildUI];
        
        [self dismissLoadingHUD];
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        [self showError:error];
    }];
}

#pragma mark -- build Data
- (void)buildUI
{
    //服务信息
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:self.MemberDetail.avatar] placeholderImage:[UIImage imageNamed:@"companyLogoDefault"]];
    
    self.serviceNameLabel.text = self.MemberDetail.gradeName;
    
    self.yearLabel.text = [NSString stringWithFormat:@"期限:%@年", self.MemberDetail.year];
    
    self.startEndDateLabel.text = [NSString stringWithFormat:@"%@--%@", self.MemberDetail.auditTime,  self.MemberDetail.expireTime];
    
    self.memberNumLabel.text = [NSString stringWithFormat:@"学员:%@人", self.MemberDetail.staff];
    
    UIColor *color = [UIColor darkGrayColor];
    switch ([self.MemberDetail.audit intValue])
    {
        case applyStatus_ing:
            
            self.statusLabel.text = @"审核中";
            self.notCrossButton.hidden = NO;
            self.crossButton.hidden = NO;
            color = HEXRGB(0xff9d5e);
            break;
        case applyStatus_cross:
            
            self.statusLabel.text = @"审核通过";
            self.notCrossButton.hidden = YES;
            self.crossButton.hidden = YES;
            color = HEXRGB(0x47c1a9);
            break;
        case applyStatus_reject:
            
            self.statusLabel.text = @"已拒绝";
            self.notCrossButton.hidden = YES;
            self.crossButton.hidden = YES;
            color = RGBCOLOR(138, 138, 138);
            break;
        case applyStatus_overdue:
            
            self.statusLabel.text = @"已过期";
            self.notCrossButton.hidden = YES;
            self.crossButton.hidden = YES;
            color = RGBCOLOR(138, 138, 138);
            break;
        default:
            self.statusLabel.text = @"";
            self.notCrossButton.hidden = YES;
            self.crossButton.hidden = YES;
            color = RGBCOLOR(138, 138, 138);
            break;
    }
    self.statusTitleL.hidden = NO;
    self.statusLabel.textColor = color;
    //会员信息
    self.companyLabel.text = self.MemberDetail.realname;
    self.contactLabel.text = [NSString stringWithFormat:@"%@  %@", self.MemberDetail.realname, self.MemberDetail.phone];
    
    self.CourseIntroductionL.numberOfLines = 0;
    self.CourseIntroductionL.text = self.MemberDetail.detail;
    [self.CourseIntroductionL sizeToFit];
    self.CourseIntroductionLHeight.constant = self.CourseIntroductionL.height;
    
    self.organizactionIntroductionL.numberOfLines = 0;
    self.organizactionIntroductionL.text = self.MemberDetail.introduction;
    [self.organizactionIntroductionL sizeToFit];
    self.organizactionIntroductionLHeight.constant = self.organizactionIntroductionL.height;
    
    self.scrollIView.hidden = NO;
    
    [self menusBtnAction:self.menusBtn[0]];
    
}

#pragma mark -- menusBtn Action
- (IBAction)menusBtnAction:(UIButton *)sender
{
    self.selectBtn.selected = NO;
    self.selectBtn = sender;
    NSUInteger tag = sender.tag;
    self.selectBtn.selected = YES;
    
    self.scrollIView.contentSize =CGSizeMake(ScreenW * 3, ScreenH - 320);
    [UIView animateWithDuration:0.25 animations:^{
        
        self.greenViewLeft.constant = sender.x;
        self.scrollIView.contentOffset = CGPointMake(self.view.width*tag, 0);
        
    } completion:^(BOOL finished) {
        
        if (tag == 0)
        {
            if (self.MemberDetail.audit.intValue != 1)
            {
                self.ContainerView.hidden = YES;
            }else
            {
                self.ContainerView.hidden = NO;
            }
            
            StudyRecordController * StudyVC = (StudyRecordController *)self.childViewControllers[0];
            
            StudyVC.memberID = self.memberIDString;
            
        }else if (tag == 1)
        {
            
        }else if (tag == 2)
        {
            
        }
    }];
    
}
#pragma mark - *** UIScrollView Delegate ***
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView != self.scrollIView)
    {
        return;
    }
    NSUInteger page = scrollView.contentOffset.x/self.view.width;
    if (page >= 3)
    {
        self.scrollIView.contentOffset = CGPointMake(self.view.width*2, 0);
        return;
    }
    
    UIButton *button = self.menusBtn[page];
    
    self.selectBtn.selected = NO;
    self.selectBtn = button;
    
    [self menusBtnAction:button];
    
}
#pragma mark -- 点击公司 Action
- (IBAction)companyDetailAction:(UIButton *)sender {
    
    //    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UserManager" bundle:nil];
    //    MemberDetailsController *controller = [storyboard instantiateViewControllerWithIdentifier:@"MemberDetailsController"];
    //
    //    controller.title = self.MemberDetail.realname;
    //    controller.memberUID = self.MemberDetail.uid;
    //
    //    [[AppDelegate sharedAppDelegate].rootNavi pushViewController:controller animated:YES];
    
    [self backAction:nil];
}
#pragma mark -- 拔打电话 Action
- (IBAction)callPhoneAction:(UIButton *)sender
{
    
    if (self.MemberDetail.phone == nil || self.MemberDetail.phone.length < 1)
    {
        return;
    }
    NSString *phoneStr = [NSString stringWithFormat:@"tel://%@", self.MemberDetail.phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneStr]];
    
}

#pragma mark -- 通过按钮 Action
- (IBAction)crossButtonAction:(UIButton *)sender
{
    
    [self showLoadingHUD];
    
    [self uploadToResult:@"pass" Reason:nil];
}

#pragma mark -- 不通过按钮 Action
- (IBAction)notCrossButtonAction:(UIButton *)sender
{
    
    InputReasonController * inPutVC = [[UIStoryboard storyboardWithName:@"UserManager" bundle:nil] instantiateViewControllerWithIdentifier:@"InputReasonController"];
    
    [[AppDelegate sharedAppDelegate].rootNavi presentViewController:inPutVC animated:YES completion:nil];
    
    __weak typeof(self)VC = self;
    inPutVC.sureBtnBlock = ^(NSString * str) {
        [VC showLoadingHUD];
        [VC uploadToResult:@"refuse" Reason:str];
    };
    
    
}

#pragma mark -- 通过或者不通过 Action
-(void)uploadToResult:(NSString *)audit Reason:(NSString *)Reason
{
    [MemberOperation auditMemberWithUerId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d", [AppManager sharedManager].user.userType] memberID:self.memberIDString audit:@"pass" reason:nil success:^{
        [self dismissLoadingHUD];
        [self showSuccessWithStatusHUD:@"提交成功"];
        
        [self performSelector:@selector(updateInfo) withObject:nil afterDelay:2.0];
        
        if (self.memberDetailVCRefleshBlock)
        {
            self.memberDetailVCRefleshBlock();
        }
        
    } failure:^(NSError *error) {
        [self showError:error];
        [self dismissLoadingHUD];
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
