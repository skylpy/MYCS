//
//  HealthDetailController.m
//  MYCS
//
//  Created by GuiHua on 16/7/5.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "HealthDetailController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "RelateVideoView.h"
#import "VideoDetailView.h"
#import "DoctorDetailView.h"
#import "RelateImageView.h"
#import "HospitalDetailView.h"
#import "CommentView.h"
#import "HealthPictureView.h"
#import "DoctorsHealthList.h"
#import "UIImageView+WebCache.h"
#import "UMengHelper.h"
#import "VideoDetail.h"
#import "MediaPlayerViewController.h"
#import "GeneralCommentModel.h"
#import "UserCenterModel.h"
#import "ProfileView.h"

@interface HealthDetailController ()

///活动ScrollView
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
///背景View
@property (weak, nonatomic) IBOutlet UIView *bgView;
///低部点赞按钮
@property (weak, nonatomic) IBOutlet UIButton *praiseBtn;
//低部收藏按钮
@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
//类型
@property (weak, nonatomic) IBOutlet UILabel *typeL;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeL;
//播放背景图
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;
//底部视图
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeightConstraint;

///相关视频
@property (nonatomic,strong) RelateVideoView *relateVideoView;
///视频详情
@property (nonatomic,strong) VideoDetailView *videoDetailView;
///医生信息
@property (nonatomic,strong) DoctorDetailView *doctorDetailView;
///相关图片
@property (nonatomic,strong) RelateImageView *relateImageView;
///医院信息
@property (nonatomic,strong) HospitalDetailView * hospitalDetailView;
///显示相关图片详情
@property (nonatomic,strong) HealthPictureView *healthPictureView;

///是否显示所有视频简介
@property (nonatomic,assign) BOOL showVideoDetail;
///是否显示所有医生简介
@property (nonatomic,assign) BOOL showDoctorDetail;
///是否显示所有医院简介
@property (nonatomic,assign) BOOL showHopitalDetail;

///视频详情model
@property (nonatomic, strong) DoctorsHealthDetail *detail;

//评论视图
@property (nonatomic, strong)CommentView *commentView;
@end

@implementation HealthDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.typeL.layer.cornerRadius = 4;
    self.typeL.clipsToBounds = YES;
    
    self.timeL.layer.cornerRadius = 4;
    self.timeL.clipsToBounds = YES;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.topViewHeightConstraint.constant = 0.56 *ScreenW;

    self.fd_prefersNavigationBarHidden = YES;
    
    self.topViewHeightConstraint.constant = 0.56 *ScreenW;
    [self addConstrainstToView:self.bgView];
    
    self.videoDetailView = [VideoDetailView videoDetailView];
    self.doctorDetailView = [DoctorDetailView doctorDetailView];
    self.relateVideoView = [RelateVideoView relateVideoView];
    self.relateImageView = [RelateImageView relateImageView];
    self.hospitalDetailView = [HospitalDetailView hospitalDetailView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.commentView)
    {
        [self.commentView addKeyboardNotification];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.commentView)
    {
        [self.commentView removeNotification];
    }
}
/**
 *  @author GuiHua, 16-07-14 16:07:36
 *
 * 用于获取视频详情
 *  @param detailId 视频ID
 */
-(void)setDetailId:(NSString *)detailId
{
    _detailId = detailId;
    
    [self getData];
}
#pragma mark - 获取视频详情数据
-(void)getData
{
    [self showLoadingView:64];
    
    [DoctorsHealthList getDoctorsHealthDetailWithId:self.detailId Success:^(DoctorsHealthDetail *model) {
        
        self.detail = model;
        [self dismissLoadingView];
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingView];
        [self showError:error];
        
    }];
}
#pragma mark - 视频详情model的setting
-(void)setDetail:(DoctorsHealthDetail *)detail
{
    _detail = detail;
    [self buildUI];
}

//给WebView添加约束
- (void)addConstrainstToView:(UIView *)bgView {
    bgView.translatesAutoresizingMaskIntoConstraints = NO;
    
    id topLayoutGuide = self.topLayoutGuide;
    
    NSString *hVFL = @"H:|-(0)-[bgView]-(0)-|";
    NSString *vVFL = @"V:|-(0)-[bgView]-(0)-|";
    
    NSArray *hConsts = [NSLayoutConstraint constraintsWithVisualFormat:hVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(topLayoutGuide, bgView)];
    NSArray *vConsts = [NSLayoutConstraint constraintsWithVisualFormat:vVFL options:0 metrics:nil views:NSDictionaryOfVariableBindings(topLayoutGuide, bgView)];
    
    [bgView.superview addConstraints:hConsts];
    [bgView.superview addConstraints:vConsts];
    
}

-(void)setShowVideoDetail:(BOOL)showVideoDetail
{
    _showVideoDetail = showVideoDetail;
    [self buildUI];
}

-(void)setShowDoctorDetail:(BOOL)showDoctorDetail
{
    _showDoctorDetail = showDoctorDetail;
    [self buildUI];
}

-(void)setShowHopitalDetail:(BOOL)showHopitalDetail
{
    _showHopitalDetail = showHopitalDetail;
    [self buildUI];
    
}
-(void)setPraise
{
    
    NSString *praiseNumb =  [NSString stringWithFormat:@" %@",self.detail.video_praise];
    
    if (self.detail.video_praise.floatValue >= 100000.0)
    {
        praiseNumb =  [NSString stringWithFormat:@" %.1f万",self.detail.video_praise.floatValue / 10000];
    }
    
    [self.praiseBtn setTitle:praiseNumb forState:UIControlStateNormal];
    [self.praiseBtn setTitle:praiseNumb forState:UIControlStateSelected];
}
#pragma mark - 为UI添加数据
-(void)buildUI
{
    [self.view layoutIfNeeded];
    
    
    self.collectBtn.selected = self.detail.is_collect.intValue == 1?YES:NO;
    self.praiseBtn.selected = self.detail.is_praise.intValue == 1?YES:NO;;
    
    [self setPraise];
    
    CGFloat topY = 0;
    
    //头部UI
    [self.playImageView sd_setImageWithURL:[NSURL URLWithString:self.detail.video_img] placeholderImage:PlaceHolderImage];
    self.typeL.text = [NSString stringWithFormat:@" %@ ",self.detail.disease_category];
    self.typeL.hidden = !self.detail.disease_category;
    self.timeL.text = [NSString stringWithFormat:@" %@ ",self.detail.video_long];
    [self.timeL sizeToFit];
    self.timeL.hidden = NO;
    self.bottomView.hidden = NO;
    
    //视频详情UI
    self.videoDetailView.y = topY;
    self.videoDetailView.width = ScreenW;
    self.videoDetailView.model = self.detail;
    self.videoDetailView.showVideoDetail = self.showVideoDetail;
    
    __weak typeof(self) weakSelf = self;
    self.videoDetailView.ShowDetailblock = ^(BOOL showDetail)
    {
        weakSelf.showVideoDetail = showDetail;
        
    };
    [self.scrollView addSubview:self.videoDetailView];
    topY = CGRectGetMaxY(self.videoDetailView.frame) + 10;
    
    
    //医生或者医院详情UI
    if (self.detail.doctorData.count > 0)
    {//医生UI
        DoctorsHealthDoctor *model = self.detail.doctorData[0];
        if (model.uid)
        {
            self.doctorDetailView.y = topY;
            self.doctorDetailView.width = ScreenW;
            self.doctorDetailView.model = model;
            self.doctorDetailView.showDoctorDetail = self.showDoctorDetail;
            self.doctorDetailView.ShowDetailblock = ^(BOOL showDetail)
            {
                weakSelf.showDoctorDetail = showDetail;
                
            };
            self.doctorDetailView.tapImageViewblock = ^(){
                
                Param * param = [[Param alloc] init];
                param.id = model.uid;
                param.type = @"doctor";
                
                [ProfileView profileWtihParam:param];
                
            };
            
            self.doctorDetailView.hospitalNameTapblock = ^(){
                
                Param * param = [[Param alloc] init];
                param.id = model.hospUid;
                param.agroup_id = model.agroup_id;
                param.type = @"college";
                
                [ProfileView profileWtihParam:param];
            };
            
            [self.scrollView addSubview:self.doctorDetailView];
            
            topY = CGRectGetMaxY(self.doctorDetailView.frame) + 10;
            
        }
        
    }else if(self.detail.hospitalData.count > 0)
    {//医院UI
        
        DoctorsHealthHosptial *model = self.detail.hospitalData[0];
        if (model.uid)
        {
            self.hospitalDetailView.y = topY;
            self.hospitalDetailView.width = ScreenW;
            self.hospitalDetailView.showHopitalDetail = self.showHopitalDetail;
            self.hospitalDetailView.model = model;
            self.hospitalDetailView.ShowDetailblock = ^(BOOL showDetail)
            {
                weakSelf.showHopitalDetail = showDetail;
                
            };
            
            self.hospitalDetailView.tapImageViewblock = ^(){
                
                Param * param = [[Param alloc] init];
                param.id = model.hospUid;
                param.agroup_id = model.agroup_id;
                param.type = @"college";
                
                [ProfileView profileWtihParam:param];
            };
            
            [self.scrollView addSubview:self.hospitalDetailView];
            
            topY = CGRectGetMaxY(self.hospitalDetailView.frame) + 10;
            
        }
    }
    
    //相关视频UI
    if (self.detail.videoRecommend.count > 0)
    {
        self.relateVideoView.y = topY;
        self.relateVideoView.width = ScreenW;
        self.relateVideoView.dataArr = self.detail.videoRecommend;
        self.relateVideoView.cellClickblock = ^(NSString *idStr)
        {
            weakSelf.detailId = idStr;
            
        };
        
        [self.scrollView addSubview:self.relateVideoView];
        
        topY = CGRectGetMaxY(self.relateVideoView.frame) + 10;
    }
    
    //花絮图片
    if (self.detail.videoPhotos.count > 0)
    {
        self.relateImageView.y = topY;
        self.relateImageView.width = ScreenW;
        self.relateImageView.imageArrs = self.detail.videoPhotos;
        
        if(self.buttonType == 0)
        {
            self.relateImageView.titleL.text = @"拍摄花絮";
        }else
        {
            self.relateImageView.titleL.text = @"精彩图片";
        }
        
        self.relateImageView.tapImageViewblock = ^(UIImageView *imageView, NSInteger index){
            
            [weakSelf.healthPictureView removeFromSuperview];
            weakSelf.healthPictureView = [HealthPictureView healthPictureView];
            weakSelf.healthPictureView.frame = CGRectMake(0, 0, ScreenW, ScreenH);
            [weakSelf.view addSubview:weakSelf.healthPictureView];
            
            [weakSelf.healthPictureView setImageArrs:weakSelf.detail.videoPhotos andCurrentIndex:(int)index andImageView:imageView];
            
            
        };
        
        [self.scrollView addSubview:self.relateImageView];
        
        topY = CGRectGetMaxY(self.relateImageView.frame);
    }
    
    self.scrollView.contentSize = CGSizeMake(ScreenW, topY + 60);
    
    [self.scrollView layoutIfNeeded];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark - 返回按钮
- (IBAction)backAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - 点赞按钮
- (IBAction)praiseBtnAction:(UIButton *)sender
{
    if (![AppManager checkLogin]) return;
    
    sender.selected = !sender.selected;
    sender.userInteractionEnabled = NO;
    [self showLoadingHUD];
    
    [GeneralCommentModel praiseOrCollectWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] action:@"praise" targetType:@"7" targetId:self.detail.des_id success:^(SCBModel *model) {
        [self dismissLoadingHUD];
        if (sender.selected)
        {
            self.detail.video_praise = [NSNumber numberWithFloat:self.detail.video_praise.floatValue +1.0];
            
            [self setPraise];
            [self showSuccessWithStatusHUD:@"点赞成功！"];
        }else
        {
            self.detail.video_praise = [NSNumber numberWithFloat:self.detail.video_praise.floatValue - 1.0];
            [self showSuccessWithStatusHUD:@"取消点赞！"];
        }
        
        [self setPraise];
        sender.userInteractionEnabled = YES;
        
    } failure:^(NSError *error) {
        [self dismissLoadingHUD];
        [self showError:error];
        sender.userInteractionEnabled = YES;
    }];
    
}
#pragma mark - 收藏按钮
- (IBAction)collectBtnAction:(UIButton *)sender
{
    if (![AppManager checkLogin]) return;
    
    if (sender.selected)
    {
        [self showSuccessWithStatusHUD:@"已收藏！"];
        return;
    }
    
    [self showLoadingHUD];
    sender.selected = !sender.selected;
    sender.userInteractionEnabled = NO;
    
    [GeneralCommentModel praiseOrCollectWithUserId:[AppManager sharedManager].user.uid userType:[NSString stringWithFormat:@"%d",[AppManager sharedManager].user.userType] action:@"collect" targetType:@"7" targetId:self.detail.des_id success:^(SCBModel *model) {
        [self dismissLoadingHUD];
        if (sender.selected)
        {
            
            [self showSuccessWithStatusHUD:@"收藏成功！"];
        }else
        {
            [self showSuccessWithStatusHUD:@"取消收藏！"];
        }
        
        sender.userInteractionEnabled = YES;
        
    } failure:^(NSError *error) {
        [self dismissLoadingHUD];
        [self showError:error];
        sender.userInteractionEnabled = YES;
    }];
    
}
#pragma mark - 分享按钮
- (IBAction)shareBtnAction:(UIButton *)sender
{
    [UMengHelper shareWith:self.detail.video_titile content:self.detail.video_des shareUrl:self.detail.shareUrl shareImage:self.playImageView.image viewController:self];
}

#pragma mark - 评论按钮
- (IBAction)commentBtnAction:(UIButton *)sender
{
   self.commentView = [CommentView showInView:self.view WithTargetId:self.detail.des_id];
}

#pragma mark - 播放按钮
- (IBAction)playBtnAction:(UIButton *)sender
{
    if (!self.detail)return;
    
    [MediaPlayerViewController showWith:self coursePackArray:nil videoDetail:nil courseDetail:nil sopDetail:nil chapter:nil DoctorsHealthDetail:self.detail isTask:NO isPreview:NO previewTips:nil];
    
    self.detail.video_click = [NSNumber numberWithFloat:self.detail.video_click.floatValue +1.0];
    [self.videoDetailView setlookL];
}

@end
















