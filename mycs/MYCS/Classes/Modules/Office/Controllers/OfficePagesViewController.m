//
//  OfficePagesViewController.m
//  MYCS
//
//  Created by wzyswork on 16/1/13.
//  Copyright © 2016年 MYCS. All rights reserved.
//

#import "OfficePagesViewController.h"

#import "QCSlideSwitchView.h"
#import "UIImageView+WebCache.h"

#import "OfficeContentModel.h"
#import "InfomationModel.h"
#import "CollectionModel.h"

#import "IntroductionViewController.h"
#import "VideoCenterViewController.h"
#import "DoctorListController.h"
#import "NewsViewController.h"
#import "OfficeListViewController.h"
#import "CodeViewController.h"

@interface OfficePagesViewController ()<QCSlideSwitchViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *avartBgView;

@property (weak, nonatomic) IBOutlet UIImageView *avartView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *divisionLTop;
@property (weak, nonatomic) IBOutlet UILabel *divisionL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *divisionLWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *divisionLHeight;

@property (weak, nonatomic) IBOutlet UILabel *hospitalL;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hospitalLWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hospitalLHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hospitalLTop;

@property (weak, nonatomic) IBOutlet UIImageView *hospitalIdentify;

@property (weak, nonatomic) IBOutlet UIImageView *specialtyIdentify;

@property (weak, nonatomic) IBOutlet UIView *personInfoView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageV;

@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;

@property (nonatomic,strong) NSMutableArray *viewControllers;

@property (nonatomic,strong) QCSlideSwitchView *slideSwithchView;

@property (nonatomic,strong) NSArray *titleArray;

@property (nonatomic,assign) NSInteger lastSelect;

@property (nonatomic,assign) int selectTitle;

@property (nonatomic,strong) OfficeDetailModel *model;

@end

@implementation OfficePagesViewController

-(void)buildLeftBtnAndRightBtn
{
    
    
    UIBarButtonItem * rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"qr-code"] style:UIBarButtonItemStyleDone target:self action:@selector(responseRightButton)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}

#pragma mark -- 二维码 Action
-(void)responseRightButton{
    
    CodeViewController * CVC = [[UIStoryboard storyboardWithName:@"Office" bundle:nil] instantiateViewControllerWithIdentifier:@"CodeViewController"];
    
    CVC.imageURL = self.model.perQrCode;
    
    [[AppDelegate sharedAppDelegate].rootNavi presentViewController:CVC animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildLeftBtnAndRightBtn];
    
    self.avartView.layer.cornerRadius = self.avartView.width * 0.5;
    self.avartView.layer.masksToBounds = YES;
    
    self.avartBgView.layer.cornerRadius = self.avartBgView.width * 0.5;
    self.avartBgView.layer.masksToBounds = YES;
    
    self.avartView.center = self.avartBgView.center;
    self.avartView.contentMode = UIViewContentModeScaleToFill;
    
    [self buildUI];
}

#pragma mark -- top UI数据赋值
- (void)buildUI{
    
    self.collectionBtn.selected = self.model.is_collect.intValue == 1?YES:NO;
    
    [self.avartView sd_setImageWithURL:[NSURL URLWithString:_model.imgUrl] placeholderImage:PlaceHolderImage];
    
    if (self.type == OfficeTypeOffice)
    {
        
        self.divisionL.text = _model.divisionName;
        [self.divisionL sizeToFit];
        self.divisionLWidth.constant = self.divisionL.width;
        
        self.hospitalL.numberOfLines = 2;
        self.hospitalL.text = _model.realname;
        CGSize size = [self.hospitalL sizeThatFits:self.hospitalL.size];
        self.hospitalLWidth.constant = size.width;
        self.hospitalLHeight.constant = 21;
        
        if (size.width > ScreenW - 150 )
        {
            self.hospitalLHeight.constant = 40;
            self.hospitalLWidth.constant = ScreenW - 150;
            
        }
        if (self.divisionL.text.length == 0)
        {
            self.specialtyIdentify.hidden = YES;
            
        }else
        {
            self.specialtyIdentify.hidden = _model.isAuthByHos?NO:YES;
        }
        
        if (self.hospitalL.text.length == 0)
        {
            self.hospitalIdentify.hidden = YES;
            
        }else
        {
            self.hospitalIdentify.hidden = _model.platformAuth?NO:YES;
        }
        
    }else if (self.type == OfficeTypeHospital || self.type == OfficeTypeAcademy)
    {
        self.divisionL.numberOfLines = 2;
        self.divisionL.text = _model.realname;
        [self.divisionL sizeToFit];
        self.divisionLWidth.constant = self.divisionL.width;
        
        self.hospitalL.text = _model.levelStr;
        [self.hospitalL sizeToFit];
        self.hospitalLWidth.constant = self.hospitalL.width;
        
        if (self.divisionL.width > ScreenW - 150 )
        {
            self.divisionLWidth.constant = ScreenW - 150;
            self.divisionLHeight.constant = 40;
            self.hospitalLTop.constant = 96 + 19;
            
        }else
        {
            self.divisionLWidth.constant = self.divisionL.width;
            self.divisionLHeight.constant = 21;
            self.hospitalLTop.constant = 96;
        }
        
        if (self.divisionL.text.length == 0)
        {
            self.specialtyIdentify.hidden = YES;
            
        }else
        {
            
            self.specialtyIdentify.hidden = _model.platformAuth?NO:YES;
        }
        
        if (self.hospitalL.text.length == 0)
        {
            self.hospitalIdentify.hidden = YES;
            
        }else
        {
            self.hospitalIdentify.hidden = NO;;
        }
        
    }else if (self.type == OfficeTypeLaboratory || self.type == OfficeTypeEnterprise)
    {
        self.divisionL.numberOfLines = 2;
        self.divisionL.text = _model.realname;
        [self.divisionL sizeToFit];
        
        if (self.divisionL.width > ScreenW - 150 )
        {
            self.divisionLTop.constant = 75;
            self.divisionLWidth.constant = ScreenW - 150;
            self.divisionLHeight.constant = 40;
            
        }else
        {
            self.divisionLTop.constant = 80;
            self.divisionLWidth.constant = self.divisionL.width;
        }
        if (self.divisionL.text.length == 0)
        {
            self.specialtyIdentify.hidden = YES;
            
        }else
        {
            self.specialtyIdentify.hidden = _model.platformAuth?NO:YES;
        }
        
    }
    
    if (self.model)[self dismissLoadingHUD];
}

#pragma mark -- QCSlideSwitchView TopButton
- (void)setupSubviewController
{
    self.viewControllers = [NSMutableArray array];
    self.selectTitle = 0 ;
    
    if (self.type == OfficeTypeOffice)
    {
        
        self.titleArray = @[@"科室简介",@"视频空间",@"名医专家",@"新闻动态"];
        
    }else if (self.type == OfficeTypeHospital)
    {
        self.titleArray = @[@"医院简介",@"视频空间",@"名医专家",@"科室",@"新闻动态"];
        
    }else if (self.type == OfficeTypeLaboratory)
    {
        
        self.titleArray = @[@"实验室简介",@"视频空间",@"新闻动态"];
        
    }
    else if (self.type == OfficeTypeEnterprise)
    {
        
        self.titleArray = @[@"企业简介",@"视频空间",@"新闻动态"];
        
    }else if (self.type == OfficeTypeAcademy)
    {
        self.titleArray = @[@"学院简介",@"视频空间",@"名医专家",@"新闻动态"];
    }
    [self buildNib];
    
}
#pragma mark -- controllerView 的创建
- (void)buildNib{
    
    CGFloat  y = 214;
    
    if (iS_IOS8LATER)
    {
        y = 150;
    }
    
    self.slideSwithchView = [[QCSlideSwitchView alloc] initWithFrame:CGRectMake(0, y, ScreenW, ScreenH-214)];
    _slideSwithchView.slideSwitchViewDelegate = self;
    
    [self.view addSubview:_slideSwithchView];
    
    _slideSwithchView.tabItemNormalColor = HEXRGB(0x666666);
    _slideSwithchView.tabItemSelectedColor = HEXRGB(0x47c1a9);
    _slideSwithchView.topBackgroundColor = [UIColor whiteColor];
    
    _slideSwithchView.heightOfTopScrollView = 44.0;
    _slideSwithchView.widthOfButtonMargin = 0;
    
    if (self.type == OfficeTypeOffice)
    {
        _slideSwithchView.scrollBarWidth = ScreenW/4;
        
    }else if (self.type == OfficeTypeHospital)
    {
        _slideSwithchView.scrollBarWidth = ScreenW/5;
        
    }else if (self.type == OfficeTypeLaboratory || self.type == OfficeTypeEnterprise)
    {
        _slideSwithchView.scrollBarWidth = ScreenW / 3;
    }else if (self.type == OfficeTypeAcademy)
    {
        _slideSwithchView.scrollBarWidth = ScreenW/4;
    }
    
    
    if (self.isHospitalOrOffice)
    {
        for (int i=0; i<_titleArray.count; i++)
        {
            
            switch (i)
            {
                case 0:
                {
                    [self addControllerWithSBName:@"IntroductionViewController"];
                }
                    break;
                case 1:
                    [self addControllerWithSBName:@"VideoCenterViewController"];
                    break;
                case 2:
                    [self addControllerWithSBName:@"DoctorListController"];
                    break;
                case 3:
                {
                    if (self.type == OfficeTypeOffice||self.type == OfficeTypeAcademy)
                    {
                        [self addControllerWithSBName:@"NewsViewController"];
                    }else if (self.type == OfficeTypeHospital)
                    {
                        [self addControllerWithSBName:@"OfficeListViewController"];
                    }
                }
                    break;
                case 4:
                    [self addControllerWithSBName:@"NewsViewController"];
                    break;
                    
                default:
                    break;
            }
            
        }
        
    }else
    {
        
        for (int i=0; i<_titleArray.count; i++)
        {
            
            switch (i)
            {
                case 0:
                {
                    [self addControllerWithSBName:@"IntroductionViewController"];
                }
                    break;
                case 1:
                    [self addControllerWithSBName:@"VideoCenterViewController"];
                    break;
                case 2:
                    [self addControllerWithSBName:@"NewsViewController"];
                    break;
                    
                default:
                    break;
            }
            
        }
        
    }
    
    [_slideSwithchView buildUI];
}

#pragma mark -- controllerView 的创建
- (void)addControllerWithSBName:(NSString *)name{
    
    if ([name isEqualToString:@"VideoCenterViewController"])
    {
        UIViewController *VC = [[UIStoryboard storyboardWithName:@"doctor" bundle:nil] instantiateViewControllerWithIdentifier:name];
        
        VC.view.width = ScreenW;
        
        [self addChildViewController:VC];
        
        [_viewControllers addObject:VC];
    }
    else
    {
        UIViewController *VC = [[UIStoryboard storyboardWithName:@"Office" bundle:nil] instantiateViewControllerWithIdentifier:name];
        
        VC.view.width = ScreenW;
        
        [self addChildViewController:VC];
        
        [_viewControllers addObject:VC];
        
    }
    
}


#pragma mark - 滑动QCSlideSwitchView Delegate

- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return _titleArray.count;
}

- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    UIViewController *listController = [_viewControllers objectAtIndex:number];
    listController.title = _titleArray[number];
    
    return listController;
}

- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    
    _lastSelect = number;
    
    self.selectTitle = (int)number;
    
    if (self.isHospitalOrOffice)
    {
        if (number == 1)
        {
            VideoCenterViewController *videoVC = _viewControllers[number];
            
            videoVC.uid = self.uid;
            
        }else if (number == 2)
        {
            DoctorListController *listVC = _viewControllers[number];
            
            listVC.checkID = self.uid;
            
        }else if (number == 3)
        {
            if (self.type == OfficeTypeOffice || self.type == OfficeTypeAcademy)
            {
                NewsViewController *newsVC = _viewControllers[number];
                
                newsVC.checkID = self.uid;
                
            }else if (self.type == OfficeTypeHospital)
            {
                OfficeListViewController *listVC = _viewControllers[number];
                    
                    listVC.checkID = self.uid;
            }
        }else if (number == 4)
        {
            
            NewsViewController *newsVC = _viewControllers[number];
            
            newsVC.checkID = self.uid;
            
        }
        
    }else
    {
        if (number == 1)
        {
            VideoCenterViewController *videoVC = _viewControllers[number];
            
            videoVC.uid = self.uid;
            
        }else if (number == 2)
        {
            NewsViewController *newsVC = _viewControllers[number];
            
            newsVC.checkID = self.uid;
        }
    }
    
}

#pragma mark -- getter和setter方法

-(void)setType:(OfficeType)type
{
    _type = type;
    
    if (self.type == OfficeTypeOffice)
    {
        self.title = @"科室主页";
        
    }else if (self.type == OfficeTypeHospital)
    {
        self.title = @"医院主页";
        
    }else if (self.type == OfficeTypeLaboratory)
    {
        self.title = @"实验室主页";
        
    }else if (self.type == OfficeTypeEnterprise)
    {
        self.title = @"企业主页";
    }else if (self.type == OfficeTypeAcademy)
    {
        self.title = @"学院主页";
    }
    
}
#pragma mark -- getter和setter方法
- (void)setUid:(NSString *)uid
{
    _uid = uid;
    
    [self showLoadingHUD];
    
    __weak typeof(self) this = self;
    
    [OfficeContentModel OfficeDetailWithUid:uid success:^(OfficeDetailModel *model) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            IntroductionViewController *introVC = _viewControllers[0];
            
            
            introVC.model = self.model;
            if (model.isAcademy.intValue == 1)
            {
                self.type = OfficeTypeAcademy;
            }
            introVC.type = self.type;
            
        });
        
        this.model = model;
        
    } failure:^(NSError *error) {
        
        [self dismissLoadingHUD];
        
        [self showError:error];
    }];
}
#pragma mark -- getter和setter方法
- (void)setModel:(OfficeDetailModel *)model
{
    _model = model;
    
    if (model.isAcademy.intValue == 1)
    {
        self.type = OfficeTypeAcademy;
    }
    
    [self setupSubviewController];
    
    [self buildUI];
}

- (IBAction)collectionBtnAction:(UIButton *)sender
{
    if (![AppManager checkLogin])return;
    
    int collectType = 5;//1.医生 4.机构  5.企业(科室，医院)
    
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
    
    [CollectionModel AddCollectDoctorOrOfficeWithCollectId:self.model.uid userId:[AppManager sharedManager].user.uid collectType:collectType Collect:collect success:^(NSString *successStr) {
        
        sender.enabled = YES;
        
        [self showSuccessWithStatusHUD:messageStr];
        
        sender.selected = !sender.selected;
        
    } failure:^(NSError *error) {
        
        sender.enabled = YES;
        
        [self showError:error];
    }];
    
}
@end






















